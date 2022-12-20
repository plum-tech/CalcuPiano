part of '../foundation.dart';

abstract class SoundFile implements Convertible{
  Future<void> loadInto(AudioPlayer player);
}

abstract class Soundpack implements Convertible{
  String get id;

  String get description;

  Future<SoundFile> resolve(Note note);
}
