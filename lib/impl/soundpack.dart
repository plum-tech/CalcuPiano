import 'package:calcupiano/db.dart';
import 'package:calcupiano/r.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

import '../foundation.dart';

part 'soundpack.g.dart';

@JsonSerializable()
class BundledSoundFile implements SoundFile {
  @JsonKey()
  final String path;

  const BundledSoundFile({required this.path});

  @override
  Future<void> loadInto(AudioPlayer player) async {
    await player.setSourceAsset(path);
  }

  factory BundledSoundFile.fromJson(Map<String, dynamic> json) => _$BundledSoundFileFromJson(json);

  Map<String, dynamic> toJson() => _$BundledSoundFileToJson(this);
  static const String type = "calcupiano.BundledSoundFile";

  @override
  String get typeName => type;

  @override
  int get version => 1;
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
    return BundledSoundFile(path: "${R.assetsSoundpackDir}/$name/${note.path}");
  }

  static const String type = "calcupiano.BuiltinSoundpack";

  @override
  String get typeName => type;

  @override
  int get version => 1;
}

@JsonSerializable()
class LocalSoundFile implements SoundFile {
  @JsonKey()
  final String path;

  const LocalSoundFile({required this.path});

  @override
  Future<void> loadInto(AudioPlayer player) async {
    await player.setSourceDeviceFile(path);
  }

  factory LocalSoundFile.fromJson(Map<String, dynamic> json) => _$LocalSoundFileFromJson(json);

  Map<String, dynamic> toJson() => _$LocalSoundFileToJson(this);
  static const String type = "calcupiano.LocalSoundFile";

  @override
  String get typeName => type;

  @override
  int get version => 1;
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

  Map<String, dynamic> toJson() => _$LocalSoundpackToJson(this);
  static const String type = "calcupiano.LocalSoundpack";

  @override
  String get typeName => type;

  @override
  int get version => 1;
}

extension SoundpackX on Soundpack {
  static Future<Soundpack?> resolve({
    required String id,
  }) async {
    final builtin = R.id2BuiltinSoundpacks[id];
    if (builtin != null) {
      return builtin;
    } else {
      return H.soundpacks.getSoundpackById(id);
    }
  }
}
