import 'package:audioplayers/audioplayers.dart';
import 'package:calcupiano/foundation/file.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sound_file.g.dart';

/// SoundFile is an abstract file of a sound.
/// It could be the ref of a bundled file, or a real local file.
abstract class SoundFileProtocol implements FileProtocol {
  Future<void> loadInto(AudioPlayer player);
}

/// A bundled sound file in assets.
@JsonSerializable()
class BundledSoundFile with BundledFileMixin implements SoundFileProtocol {
  static const String type = "calcupiano.BundledSoundFile";
  @override
  @JsonKey()
  final String path;

  const BundledSoundFile({required this.path});

  @override
  Future<void> loadInto(AudioPlayer player) async {
    await player.setSourceAsset(path);
  }

  factory BundledSoundFile.fromJson(Map<String, dynamic> json) => _$BundledSoundFileFromJson(json);

  Map<String, dynamic> toJson() => _$BundledSoundFileToJson(this);

  @override
  String get typeName => type;

  @override
  int get version => 1;
}

@JsonSerializable()
class LocalSoundFile with LocalFileMixin implements SoundFileProtocol {
  static const String type = "calcupiano.LocalSoundFile";
  @override
  @JsonKey()
  final String localPath;

  const LocalSoundFile({required this.localPath});

  @override
  Future<void> loadInto(AudioPlayer player) async {
    await player.setSourceDeviceFile(localPath);
  }

  factory LocalSoundFile.fromJson(Map<String, dynamic> json) => _$LocalSoundFileFromJson(json);

  Map<String, dynamic> toJson() => _$LocalSoundFileToJson(this);

  @override
  String get typeName => type;

  @override
  int get version => 1;
}

@JsonSerializable()
class UrlSoundFile with UrlFileMixin implements SoundFileProtocol {
  static const String type = "calcupiano.UrlSoundFile";
  @override
  @JsonKey()
  final String url;

  const UrlSoundFile({required this.url});

  @override
  Future<void> loadInto(AudioPlayer player) async {
    await player.setSourceUrl(url);
  }

  factory UrlSoundFile.fromJson(Map<String, dynamic> json) => _$UrlSoundFileFromJson(json);

  Map<String, dynamic> toJson() => _$UrlSoundFileToJson(this);

  @override
  String get typeName => type;

  @override
  int get version => 1;
}
