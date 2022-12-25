import 'platform.dart';

PlatformType get currentPlatformBackend => PlatformType.web;

String join(
  String part1, [
  String? part2,
  String? part3,
  String? part4,
  String? part5,
  String? part6,
  String? part7,
  String? part8,
]) =>
    throw UnimplementedError('Tried to use `join` in the `path` package from Flutter Web.');

String basename(String path) =>
    throw UnimplementedError('Tried to use `basename` in the `path` package from Flutter Web.');

String extension(String path, [int level = 1]) =>
    throw UnimplementedError('Tried to use `extension` in the `path` package from Flutter Web.');
