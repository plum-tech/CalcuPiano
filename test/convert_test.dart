import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Prototype of Custom JsonCodec", () {
    test("Map custom class", () {
      mapCustomClass();
    });
  });
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
