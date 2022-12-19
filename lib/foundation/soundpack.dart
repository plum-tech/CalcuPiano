part of '../foundation.dart';

abstract class SoundFile {
  Future<void> loadInto(AudioPlayer player);
}

class AssetSoundFile implements SoundFile {
  final String path;

  const AssetSoundFile(this.path);

  @override
  Future<void> loadInto(AudioPlayer player) async {
    await player.setSourceAsset(path);
  }
}

class LocalSoundFile implements SoundFile {
  final String path;

  const LocalSoundFile(this.path);

  @override
  Future<void> loadInto(AudioPlayer player) async {
    await player.setSourceDeviceFile(path);
  }
}

class SoundPack {

}
