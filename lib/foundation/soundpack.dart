part of '../foundation.dart';

abstract class SoundFile {
  Future<void> loadInto(AudioPlayer player);
}

class AssetSoundFile implements SoundFile {
  final String path;

  const AssetSoundFile({required this.path});

  @override
  Future<void> loadInto(AudioPlayer player) async {
    await player.setSourceAsset(path);
  }
}

abstract class SoundPack {
  String get id;

  Future<SoundFile> resolve(Note note);
}

class AssetSoundPack implements SoundPack {
  /// The internal name.
  final String name;

  AssetSoundPack(this.name);

  /// The ID is fixed.
  @override
  String get id => "calcupiano.$name";

  @override
  Future<SoundFile> resolve(Note note) async {
    return AssetSoundFile(path: "${R.assetSoundpackDir}/$id/${note.path}");
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

class LocalSoundPack implements SoundPack {
  final String uuid;

  /// User can name this whatever they want.
  final String name;

  LocalSoundPack(this.uuid, this.name);

  /// The ID is generated
  @override
  String get id => uuid;

  @override
  Future<SoundFile> resolve(Note note) async {
    final dir = await getApplicationSupportDirectory();

    return LocalSoundFile(path: "${dir.path}/${R.customSoundpackDir}/$id/${note.path}");
  }
}
