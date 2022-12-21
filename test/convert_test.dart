import 'dart:convert';

import 'package:calcupiano/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Prototype of Custom JsonCodec", () {
    test("Map custom class", () {
      mapCustomClass();
    });

    test("Work with generated adapter", () {
      workWithGeneratedAdapter();
    });
  });

  group("Test", () {
    test("toJson", () {
      initConverter();
      const local = LocalSoundFile(localPath: '/usr/liplum/soundpack/1.wav');
      final res = Converter.toJson(local);
      assert(res != null);
      assert(res!.contains(LocalSoundFile.type));
    });
    test("fromJson", () {
      initConverter();
      const json = '{"localPath":"/usr/liplum/soundpack/1.wav","@type":"calcupiano.LocalSoundFile","@version":1}';
      final res = Converter.fromJson<LocalSoundFile>(json);
      assert(res != null);
      assert(res!.localPath == "/usr/liplum/soundpack/1.wav");
    });
    test("polymorphism", () {
      initConverter();
      const list = [
        BundledSoundFile(pathInAssets: "default/1.wav"),
        LocalSoundFile(localPath: '/usr/liplum/soundpack/1.wav'),
      ];
      final res = Converter.toJson(list);
      assert(res != null);
      assert(res!.contains("/usr/liplum/soundpack/1.wav"));
      final restored = Converter.fromJson<List>(res);
      assert(restored!=null);
      assert(restored![1] is LocalSoundFile);
      assert((restored![1] as LocalSoundFile).localPath == "/usr/liplum/soundpack/1.wav");
    });
  });
}

void workWithGeneratedAdapter() {
  final from = {
    "calcupiano.BundledSoundFile": BundledSoundFile.fromJson,
  };
  final to = {
    "calcupiano.BundledSoundFile": (obj) => obj.toJson(),
  };
  Object? reviver(Object? key, Object? value) {
    if (value is! Map) {
      return value;
    } else {
      final type = value["@type"];
      final fromFunc = from[type]!;
      return fromFunc(value as Map<String, dynamic>);
    }
  }

  Object? toEncodable(dynamic object) {
    if (object is Convertible) {
      final type = object.typeName;
      final toFunc = to[type]!;
      final json = toFunc(object);
      json["@type"] = type;
      return json;
    }
    return object;
  }

  final JsonCodec json = JsonCodec(reviver: reviver, toEncodable: toEncodable);
  const f = BundledSoundFile(pathInAssets: "default/1.wav");
  final res = json.encode(f);
  assert(res.contains('default/1.wav'));
  final restored = json.decode(res);
  assert(restored is! LocalSoundFile);
  assert((restored as BundledSoundFile).pathInAssets == "default/1.wav");
}

void mapCustomClass() {
  Object? reviver(Object? key, Object? value) {
    if (value is! Map) {
      return value;
    } else {
      return Foo(value["a"]);
    }
  }

  Object? toEncodable(dynamic object) {
    if (object is Foo) {
      return {"a": object.a};
    }
  }

  final JsonCodec json = JsonCodec(reviver: reviver, toEncodable: toEncodable);
  final ta = Foo("toJson");
  final res = json.encode(ta);
  assert(res == '{"a":"toJson"}');
  const fa = '{"a":"fromJson"}';
  final res2 = json.decode(fa) as Foo;
  assert(res2.a == "fromJson");
}

class Foo {
  final String a;

  Foo(this.a);
}
