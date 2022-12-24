import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';

part 'soundpack.g.dart';

abstract class SoundpackProtocol {
  /// The identity.
  /// The [H.currentSoundpackID] will use this as identity.
  String get id;

  Future<SoundFileProtocol> resolve(Note note);

  String get displayName;

  ImageFileProtocol? get preview;
}

class SoundFileLoc {
  final SoundpackProtocol soundpack;
  final SoundFileProtocol file;

  SoundFileLoc(this.soundpack, this.file);
}

class BuiltinSoundpack implements SoundpackProtocol {
  @override
  String get displayName => name;

  /// The internal name.
  final String name;

  String get description => "By key";

  const BuiltinSoundpack(this.name);

  /// The ID is fixed.
  @override
  String get id => R.genBuiltinSoundpackId(name);

  @override
  Future<SoundFileProtocol> resolve(Note note) async {
    // Note: Don't use [joinPath] here, assets only slash-separator.
    // On Windows, [joinPath] will add backslashes.
    return BundledSoundFile(path: "assets/${R.assetsSoundpackDir}/$name/${note.id}.wav");
  }

  @override
  ImageFileProtocol get preview => BundledImageFile(path: "assets/${R.assetsSoundpackDir}/$name/preview.png");
}

abstract class ExternalSoundpackProtocol implements SoundpackProtocol, Convertible {
  SoundpackMeta get meta;
}

@JsonSerializable()
class LocalSoundpack implements ExternalSoundpackProtocol {
  static const String type = "calcupiano.LocalSoundpack";

  @override
  String get displayName => meta.name ?? "No Name";
  @JsonKey()
  final String uuid;
  @override
  @JsonKey(fromJson: Converter.directConvertFunc, toJson: Converter.directConvertFunc)
  SoundpackMeta meta;

  /// A LocalSoundpack can only hold [LocalSoundFile].
  @JsonKey(fromJson: _note2FilesFromJson, toJson: _note2FilesToJson)
  Map<Note, LocalSoundFile> note2SoundFile = {};
  @override
  @JsonKey(fromJson: Converter.directConvertFunc, toJson: Converter.directConvertFunc)
  LocalImageFile? preview;

  LocalSoundpack({required this.uuid, required this.meta, this.preview});

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

  LocalSoundpack copyWith({
    String? uuid,
    SoundpackMeta? meta,
    Map<Note, LocalSoundFile>? note2SoundFile,
    LocalImageFile? preview,
  }) =>
      LocalSoundpack(
        uuid: uuid ?? this.uuid,
        meta: meta ?? this.meta,
        preview: preview ?? this.preview,
      )..note2SoundFile = note2SoundFile ?? this.note2SoundFile;
}

@JsonSerializable()
class UrlSoundpack implements ExternalSoundpackProtocol {
  static const String type = "calcupiano.UrlSoundpack";

  @override
  String get displayName => meta.name ?? "No Name";
  @JsonKey()
  final String uuid;
  @JsonKey()
  final String url;
  @JsonKey(fromJson: Converter.directConvertFunc, toJson: Converter.directConvertFunc)
  @override
  SoundpackMeta meta;
  @override
  @JsonKey(fromJson: Converter.directConvertFunc, toJson: Converter.directConvertFunc)
  ImageFileProtocol? preview;

  /// A LocalSoundpack can only hold [LocalSoundFile].
  @JsonKey(fromJson: _note2FilesFromJson, toJson: _note2FilesToJson)
  Map<Note, SoundFileProtocol> note2SoundFile = {};

  UrlSoundpack({required this.uuid, required this.meta, required this.url, this.preview});

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

  UrlSoundpack copyWith({
    String? uuid,
    String? url,
    SoundpackMeta? meta,
    Map<Note, LocalSoundFile>? note2SoundFile,
    ImageFileProtocol? preview,
  }) =>
      UrlSoundpack(
        uuid: uuid ?? this.uuid,
        meta: meta ?? this.meta,
        url: url ?? this.url,
        preview: preview ?? this.preview,
      )..note2SoundFile = note2SoundFile ?? this.note2SoundFile;
}

@JsonSerializable()
class SoundpackMeta implements Convertible {
  static const String type = "calcupiano.SoundpackMeta";
  @JsonKey(includeIfNull: false)
  String? name;
  @JsonKey(includeIfNull: false)
  String? description;
  @JsonKey(includeIfNull: false)
  String? author;
  @JsonKey(includeIfNull: false)
  String? url;

  SoundpackMeta();

  factory SoundpackMeta.fromJson(Map<String, dynamic> json) => _$SoundpackMetaFromJson(json);

  Map<String, dynamic> toJson() => _$SoundpackMetaToJson(this);

  @override
  String get typeName => type;

  @override
  int get version => 1;

  SoundpackMeta copyWith({
    String? name,
    String? description,
    String? author,
    String? url,
  }) =>
      SoundpackMeta()
        ..name = name ?? this.name
        ..description = description ?? this.description
        ..author = author ?? this.author
        ..url = url ?? this.url;

  @override
  bool operator ==(Object other) {
    return other is SoundpackMeta &&
        runtimeType == other.runtimeType &&
        name == other.name &&
        author == other.author &&
        url == other.url;
  }

  @override
  int get hashCode => hash4(name, description, author, url);
}

class NoSoundFileOfNoteException implements Exception {
  final Note note;

  NoSoundFileOfNoteException(this.note);
}
