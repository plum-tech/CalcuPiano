import 'package:calcupiano/db.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

import '../platform/platform.dart';

part 'soundpack.g.dart';

abstract class SoundpackProtocol {
  /// The identity.
  /// The [H.currentSoundpackID] will use this as identity.
  String get id;

  Future<SoundFileProtocol> resolve(Note note);
}

class BuiltinSoundpack implements SoundpackProtocol {
  /// The internal name.
  final String name;

  String get description => "By key";

  const BuiltinSoundpack(this.name);

  /// The ID is fixed.
  @override
  String get id => R.genBuiltinSoundpackId(name);

  @override
  Future<SoundFileProtocol> resolve(Note note) async {
    return BundledSoundFile(pathInAssets: joinPath(R.assetsSoundpackDir, name, "${note.id}.wav"));
  }
}

abstract class ExternalSoundpackProtocol implements SoundpackProtocol, Convertible {}

@JsonSerializable()
class LocalSoundpack implements ExternalSoundpackProtocol {
  static const String type = "calcupiano.LocalSoundpack";
  @JsonKey()
  final String uuid;
  @JsonKey(fromJson: Converter.directConvertFunc, toJson: Converter.directConvertFunc)
  SoundpackMeta meta;

  LocalSoundpack(this.uuid, this.meta);

  /// The ID is generated
  @override
  String get id => uuid;

  @override
  Future<SoundFileProtocol> resolve(Note note) async {
    return LocalSoundFile(localPath: joinPath(R.soundpacksRootDir, uuid, note.id + ".wav"));
  }

  factory LocalSoundpack.fromJson(Map<String, dynamic> json) => _$LocalSoundpackFromJson(json);

  Map<String, dynamic> toJson() => _$LocalSoundpackToJson(this);

  @override
  String get typeName => type;

  @override
  int get version => 1;
}

@JsonSerializable()
class UrlSoundpack implements ExternalSoundpackProtocol {
  static const String type = "calcupiano.LocalSoundpack";
  @JsonKey()
  final String uuid;
  @JsonKey(fromJson: Converter.directConvertFunc, toJson: Converter.directConvertFunc)
  SoundpackMeta meta;

  UrlSoundpack(this.uuid, this.meta);

  /// The ID is generated
  @override
  String get id => uuid;

  @override
  Future<SoundFileProtocol> resolve(Note note) async {
    throw UnimplementedError();
  }

  factory UrlSoundpack.fromJson(Map<String, dynamic> json) => _$UrlSoundpackFromJson(json);

  Map<String, dynamic> toJson() => _$UrlSoundpackToJson(this);

  @override
  String get typeName => type;

  @override
  int get version => 1;
}

extension SoundpackX on SoundpackProtocol {
  static Future<SoundpackProtocol> resolve({
    required String id,
  }) async {
    final builtin = R.id2BuiltinSoundpacks[id];
    if (builtin != null) {
      return builtin;
    } else {
      return H.soundpacks.getSoundpackById(id) ?? R.defaultSoundpack;
    }
  }
}

@JsonSerializable()
class SoundpackMeta implements Convertible {
  static const String type = "calcupiano.SoundpackMeta";
  @JsonKey()
  String? name;
  @JsonKey()
  String? description;
  @JsonKey()
  String? author;
  @JsonKey()
  String? url;
  @JsonKey()
  Map<String, Map<String, String>>? l10n;

  SoundpackMeta();

  factory SoundpackMeta.fromJson(Map<String, dynamic> json) => _$SoundpackMetaFromJson(json);

  Map<String, dynamic> toJson() => _$SoundpackMetaToJson(this);

  @override
  String get typeName => type;

  @override
  int get version => 1;
}