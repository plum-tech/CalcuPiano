import 'package:audioplayers/audioplayers.dart';
import 'package:calcupiano/db.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

part 'sound_file.g.dart';

/// SoundFile is an abstract file of a sound.
/// It could be the ref of a bundled file, or a real local file.
abstract class SoundFileProtocol implements Convertible {
  Future<void> loadInto(AudioPlayer player);
}

/// A bundled sound file in assets.
@JsonSerializable()
class BundledSoundFile implements SoundFileProtocol {
  static const String type = "calcupiano.BundledSoundFile";
  @JsonKey()
  final String pathInAssets;

  const BundledSoundFile({required this.pathInAssets});

  @override
  Future<void> loadInto(AudioPlayer player) async {
    await player.setSourceAsset(pathInAssets);
  }

  factory BundledSoundFile.fromJson(Map<String, dynamic> json) => _$BundledSoundFileFromJson(json);

  Map<String, dynamic> toJson() => _$BundledSoundFileToJson(this);

  @override
  String get typeName => type;

  @override
  int get version => 1;
}

@JsonSerializable()
class LocalSoundFile implements SoundFileProtocol {
  static const String type = "calcupiano.LocalSoundFile";
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
class UrlSoundFile implements SoundFileProtocol {
  static const String type = "calcupiano.UrlSoundFile";
  @JsonKey()
  final String url;
  final String md5;

  const UrlSoundFile({required this.url, required this.md5});

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
