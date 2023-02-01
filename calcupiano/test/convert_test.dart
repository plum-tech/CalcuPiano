import 'package:calcupiano/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jconverter/jconverter.dart';

void main() {
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
      const json =
          '{"localPath":"/usr/liplum/soundpack/1.wav","@type":"calcupiano.LocalSoundFile","@version":1}';
      final res = Converter.fromJson<LocalSoundFile>(json);
      assert(res != null);
      assert(res!.localPath == "/usr/liplum/soundpack/1.wav");
    });
    test("polymorphism", () {
      initConverter();
      const list = [
        BundledSoundFile(path: "assets/default/1.wav"),
        LocalSoundFile(localPath: '/usr/liplum/soundpack/1.wav'),
      ];
      final res = Converter.toJson(list);
      assert(res != null);
      assert(res!.contains("/usr/liplum/soundpack/1.wav"));
      final restored = Converter.fromJson<List>(res);
      assert(restored != null);
      assert(restored![1] is LocalSoundFile);
      assert((restored![1] as LocalSoundFile).localPath ==
          "/usr/liplum/soundpack/1.wav");
    });
    test("migration", () {
      const json =
          '[{"path":"default/1.wav","@type":"calcupiano.BundledSoundFile","@version":1},{"localPath":"/usr/liplum/soundpack/1.wav","@type":"calcupiano.LocalSoundFile","@version":1}]';
      initConverter();
      Converter.enableMigration = true;
      Converter.migrate("calcupiano.BundledSoundFile", (origin, oldVersion) {
        if (oldVersion == 1) {
          origin["path"] = "MIGRATED";
        }
        return origin;
      });
      final restored = Converter.fromJson<List>(json);
      assert(restored != null);
      assert(restored![0] is BundledSoundFile);
      assert((restored![0] as BundledSoundFile).path == "MIGRATED");
    });
  });
  group("Stuff", () {
    test("Test generic inheritance checking", () {
      assert(isSubtype<String, JConvertibleProtocol>() == false);
      assert(isSubtype<BundledSoundFile, JConvertibleProtocol>() == true);
    });
  });
}
