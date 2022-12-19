part of '../foundation.dart';

abstract class SoundFile {
  Future<void> loadInto(AudioPlayer player);
}

abstract class Soundpack {
  String get id;

  String get description;

  Future<SoundFile> resolve(Note note);
}
