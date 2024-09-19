// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundledImageFile _$BundledImageFileFromJson(Map<String, dynamic> json) =>
    BundledImageFile(
      path: json['path'] as String,
    );

Map<String, dynamic> _$BundledImageFileToJson(BundledImageFile instance) =>
    <String, dynamic>{
      'path': instance.path,
    };

LocalImageFile _$LocalImageFileFromJson(Map<String, dynamic> json) =>
    LocalImageFile(
      localPath: json['localPath'] as String,
    );

Map<String, dynamic> _$LocalImageFileToJson(LocalImageFile instance) =>
    <String, dynamic>{
      'localPath': instance.localPath,
    };

UrlImageFile _$UrlImageFileFromJson(Map<String, dynamic> json) => UrlImageFile(
      url: json['url'] as String,
    );

Map<String, dynamic> _$UrlImageFileToJson(UrlImageFile instance) =>
    <String, dynamic>{
      'url': instance.url,
    };
