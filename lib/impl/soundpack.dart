import 'package:calcupiano/r.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

import '../foundation.dart';

part 'soundpack.g.dart';

class BuiltinSoundFile implements SoundFile {
  final String path;

  const BuiltinSoundFile({required this.path});

  @override
  Future<void> loadInto(AudioPlayer player) async {
    await player.setSourceAsset(path);
  }
}

class BuiltinSoundpack implements Soundpack {
  /// The internal name.
  final String name;

  @override
  String get description => "By key";

  const BuiltinSoundpack(this.name);

  /// The ID is fixed.
  @override
  String get id => R.genBuiltinSoundpackId(name);

  @override
  Future<SoundFile> resolve(Note note) async {
    return BuiltinSoundFile(path: "${R.assetsSoundpackDir}/$name/${note.path}");
  }
}

class LocalSoundFile implements SoundFile {
  final String path;

  const LocalSoundFile({required this.path});

  @override
  Future<void> loadInto(AudioPlayer player) async {
    await player.setSourceDeviceFile(path);
  }
}

@JsonSerializable()
class LocalSoundpack implements Soundpack {
  @JsonKey()
  final String uuid;

  /// User can name this whatever they want.
  @JsonKey()
  final String name;

  @override
  @JsonKey()
  String description = "";

  LocalSoundpack(this.uuid, this.name);

  /// The ID is generated
  @override
  String get id => uuid;

  @override
  Future<SoundFile> resolve(Note note) async {
    final dir = await getApplicationSupportDirectory();
    return LocalSoundFile(path: "${dir.path}/${R.customSoundpackDir}/$id/${note.path}");
  }

  factory LocalSoundpack.fromJson(Map<String, dynamic> json) => _$LocalSoundpackFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LocalSoundpackToJson(this);
}

extension SoundpackX on Soundpack {
  static Future<Soundpack> resolve({
    required String? id,
  }) async {
    final builtin = R.id2BuiltinSoundpacks[id];
    if (builtin != null) {
      return builtin;
    } else {
      // TODO: Read the soundpack info from Hive.
      return R.defaultSoundpack;
    }
  }
}
