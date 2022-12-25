import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/i18n.dart';
import 'package:calcupiano/r.dart';
import 'package:calcupiano/utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';

part 'soundpack.g.dart';

part 'soundpack.i18n.dart';

abstract class SoundpackProtocol {
  /// The identity.
  /// The [H.currentSoundpackID] will use this as identity.
  String get id;

  SoundFileProtocol resolve(Note note);

  ImageFileProtocol? get preview;
}

abstract class SoundFileLoc implements SoundFileResolveProtocol {
  SoundpackProtocol get soundpack;

  Note get note;

  factory SoundFileLoc.fromSoundpackType(SoundpackProtocol soundpack, Note note) {
    if (soundpack is LocalSoundpack) {
      return LocalSoundFileLoc(soundpack, note);
    } else if (soundpack is BuiltinSoundpack) {
      return BuiltinSoundFileLoc(soundpack, note);
    } else if (soundpack is UrlSoundpack) {
      return UrlSoundFileLoc(soundpack, note);
    } else {
      return _SoundFileLocImpl(soundpack, note);
    }
  }
}

class _SoundFileLocImpl implements SoundFileLoc {
  @override
  final SoundpackProtocol soundpack;
  @override
  final Note note;

  const _SoundFileLocImpl(this.soundpack, this.note);

  @override
  SoundFileProtocol resolve() => soundpack.resolve(note);
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
  BundledSoundFile resolve(Note note) {
    // Note: Don't use [joinPath] here, assets only slash-separator.
    // On Windows, [joinPath] will add backslashes.
    return BundledSoundFile(path: "assets/${R.assetsSoundpackDir}/$name/${note.id}.wav");
  }

  @override
  ImageFileProtocol get preview => BundledImageFile(path: "assets/${R.assetsSoundpackDir}/$name/preview.png");
}

class BuiltinSoundFileLoc implements SoundFileLoc {
  @override
  final BuiltinSoundpack soundpack;
  @override
  final Note note;

  const BuiltinSoundFileLoc(this.soundpack, this.note);

  @override
  BundledSoundFile resolve() => soundpack.resolve(note);
}

abstract class ExternalSoundpackProtocol implements SoundpackProtocol, Convertible {
  SoundpackMeta get meta;
}

@JsonSerializable()
class LocalSoundpack implements ExternalSoundpackProtocol {
  static const String type = "calcupiano.LocalSoundpack";
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
  LocalSoundFile resolve(Note note) {
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

class LocalSoundFileLoc implements SoundFileLoc {
  @override
  final LocalSoundpack soundpack;
  @override
  final Note note;

  const LocalSoundFileLoc(this.soundpack, this.note);

  @override
  LocalSoundFile resolve() => soundpack.resolve(note);
}

@JsonSerializable()
class UrlSoundpack implements ExternalSoundpackProtocol {
  static const String type = "calcupiano.UrlSoundpack";

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
  SoundFileProtocol resolve(Note note) {
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

class UrlSoundFileLoc implements SoundFileLoc {
  @override
  final UrlSoundpack soundpack;
  @override
  final Note note;

  const UrlSoundFileLoc(this.soundpack, this.note);

  @override
  SoundFileProtocol resolve() => soundpack.resolve(note);
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
  @JsonKey(includeIfNull: false)
  String? email;

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
    String? email,
  }) =>
      SoundpackMeta()
        ..name = name ?? this.name
        ..description = description ?? this.description
        ..author = author ?? this.author
        ..url = url ?? this.url
        ..email = email ?? this.email;

  @override
  bool operator ==(Object other) {
    return other is SoundpackMeta &&
        runtimeType == other.runtimeType &&
        name == other.name &&
        description == other.description &&
        author == other.author &&
        url == other.url &&
        email == other.email;
  }

  @override
  int get hashCode => hash4(name, description, author, url);
}

class NoSoundFileOfNoteException implements Exception {
  final Note note;

  NoSoundFileOfNoteException(this.note);
}

extension SoundpackX on SoundpackProtocol {
  bool idEquals(SoundpackProtocol other) => id == other.id;

  Iterable<MapEntry<Note, SoundFileProtocol>> iterateNote2SoundFile() sync* {
    for (final note in Note.all) {
      yield MapEntry(note, resolve(note));
    }
  }

  Iterable<SoundFileProtocol> iterateSoundFiles() sync* {
    for (final note in Note.all) {
      yield resolve(note);
    }
  }

  String get displayName {
    final self = this;
    if (self is ExternalSoundpackProtocol) {
      return self.meta.name.notEmptyNullOr(I18n.soundpack.nameEmpty);
    } else if (self is BuiltinSoundpack) {
      return I18n.nameOf(self);
    }
    return I18n.soundpack.nameEmpty;
  }

  String get author {
    final self = this;
    if (self is ExternalSoundpackProtocol) {
      return self.meta.author.notEmptyNullOr(I18n.soundpack.authorEmpty);
    } else if (self is BuiltinSoundpack) {
      return I18n.authorOf(self);
    }
    return I18n.soundpack.authorEmpty;
  }

  String get url {
    final self = this;
    if (self is ExternalSoundpackProtocol) {
      return self.meta.url ?? "";
    } else if (self is BuiltinSoundpack) {
      return I18n.urlOf(self);
    }
    return "";
  }

  String get email {
    final self = this;
    if (self is ExternalSoundpackProtocol) {
      return self.meta.email ?? "";
    } else if (self is BuiltinSoundpack) {
      return I18n.emailOf(self);
    }
    return "";
  }

  String get description {
    final self = this;
    if (self is ExternalSoundpackProtocol) {
      return self.meta.description.notEmptyNullOr(I18n.soundpack.descriptionEmpty);
    } else if (self is BuiltinSoundpack) {
      return I18n.descriptionOf(self);
    }
    return I18n.soundpack.descriptionEmpty;
  }
}
