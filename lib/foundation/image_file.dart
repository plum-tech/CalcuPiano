import 'dart:io';

import 'package:calcupiano/foundation/file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image_file.g.dart';

abstract class ImageFileProtocol implements FileProtocol {
  Widget build(BuildContext context, {BoxFit? fit});
}

@JsonSerializable()
class BundledImageFile with BundledFileMixin implements ImageFileProtocol {
  static const String type = "calcupiano.BundledImageFile";
  @override
  @JsonKey()
  final String path;

  const BundledImageFile({required this.path});

  @override
  String get typeName => type;

  @override
  int get version => 1;

  @override
  Widget build(BuildContext context, {BoxFit? fit}) {
    return Image.asset(path, fit: fit);
  }

  factory BundledImageFile.fromJson(Map<String, dynamic> json) => _$BundledImageFileFromJson(json);

  Map<String, dynamic> toJson() => _$BundledImageFileToJson(this);
}

@JsonSerializable()
class LocalImageFile with LocalFileMixin implements ImageFileProtocol {
  static const String type = "calcupiano.LocalImageFile";

  const LocalImageFile({required this.localPath});

  @override
  @JsonKey()
  final String localPath;

  @override
  Widget build(BuildContext context, {BoxFit? fit}) {
    return Image.file(File(localPath), fit: fit);
  }

  @override
  String get typeName => type;

  @override
  int get version => 1;

  factory LocalImageFile.fromJson(Map<String, dynamic> json) => _$LocalImageFileFromJson(json);

  Map<String, dynamic> toJson() => _$LocalImageFileToJson(this);
}

@JsonSerializable()
class UrlImageFile with UrlFileMixin implements ImageFileProtocol {
  static const String type = "calcupiano.UrlImageFile";

  @override
  @JsonKey()
  final String url;

  const UrlImageFile({required this.url});

  @override
  Widget build(BuildContext context, {BoxFit? fit}) {
    return Image.network(url, fit: fit);
  }

  @override
  String get typeName => type;

  @override
  int get version => 1;

  factory UrlImageFile.fromJson(Map<String, dynamic> json) => _$UrlImageFileFromJson(json);

  Map<String, dynamic> toJson() => _$UrlImageFileToJson(this);
}
