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

  /// A LocalSoundpack can only hold [LocalSoundFile].
  @JsonKey(fromJson: _note2FilesFromJson, toJson: _note2FilesToJson)
  Map<Note, LocalSoundFile> note2SoundFile = {};

  LocalSoundpack(this.uuid, this.meta);

  /// The ID is generated
  @override
  String get id => uuid;

  @override
  Future<SoundFileProtocol> resolve(Note note) async {
    final file = note2SoundFile[note];
    if (file == null) {
      throw NoSoundFileOfNoteException(note);
    }
    return file;
  }

  factory LocalSoundpack.fromJson(Map<String, dynamic> json) => _$LocalSoundpackFromJson(json);

  Map<String, dynamic> toJson() => _$LocalSoundpackToJson(this);

  @override
  String get typeName => type;

  @override
  int get version => 1;

  static Map<String, dynamic> _note2FilesToJson(Map<Note, LocalSoundFile> note2Files) {
    return note2Files.map((key, value) => MapEntry(key.id, value));
  }

  static Map<Note, LocalSoundFile> _note2FilesFromJson(Map<String, dynamic> note2Files) {
    return note2Files.map((key, value) => MapEntry(Note.of(key), value));
  }
}

@JsonSerializable()
class UrlSoundpack implements ExternalSoundpackProtocol {
  static const String type = "calcupiano.LocalSoundpack";
  @JsonKey()
  final String uuid;
  @JsonKey(fromJson: Converter.directConvertFunc, toJson: Converter.directConvertFunc)
  SoundpackMeta meta;

  /// A LocalSoundpack can only hold [LocalSoundFile].
  @JsonKey(fromJson: _note2FilesFromJson, toJson: _note2FilesToJson)
  Map<Note, SoundFileProtocol> note2SoundFile = {};

  UrlSoundpack(this.uuid, this.meta);

  /// The ID is generated
  @override
  String get id => uuid;

  @override
  Future<SoundFileProtocol> resolve(Note note) async {
    final file = note2SoundFile[note];
    if (file == null) {
      throw NoSoundFileOfNoteException(note);
    }
    return file;
  }

  factory UrlSoundpack.fromJson(Map<String, dynamic> json) => _$UrlSoundpackFromJson(json);

  Map<String, dynamic> toJson() => _$UrlSoundpackToJson(this);

  @override
  String get typeName => type;

  @override
  int get version => 1;

  static Map<String, dynamic> _note2FilesToJson(Map<Note, SoundFileProtocol> note2Files) {
    return note2Files.map((key, value) => MapEntry(key.id, value));
  }

  static Map<Note, SoundFileProtocol> _note2FilesFromJson(Map<String, dynamic> note2Files) {
    return note2Files.map((key, value) => MapEntry(Note.of(key), value));
  }
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

class NoSoundFileOfNoteException implements Exception {
  final Note note;

  NoSoundFileOfNoteException(this.note);
}
