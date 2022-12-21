// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundledSoundFile _$BundledSoundFileFromJson(Map<String, dynamic> json) =>
    BundledSoundFile(
      pathInAssets: json['pathInAssets'] as String,
    );

Map<String, dynamic> _$BundledSoundFileToJson(BundledSoundFile instance) =>
    <String, dynamic>{
      'pathInAssets': instance.pathInAssets,
    };

LocalSoundFile _$LocalSoundFileFromJson(Map<String, dynamic> json) =>
    LocalSoundFile(
      localPath: json['localPath'] as String,
    );

Map<String, dynamic> _$LocalSoundFileToJson(LocalSoundFile instance) =>
    <String, dynamic>{
      'localPath': instance.localPath,
    };

UrlSoundFile _$UrlSoundFileFromJson(Map<String, dynamic> json) => UrlSoundFile(
      url: json['url'] as String,
      md5: json['md5'] as String,
    );

Map<String, dynamic> _$UrlSoundFileToJson(UrlSoundFile instance) =>
    <String, dynamic>{
      'url': instance.url,
      'md5': instance.md5,
    };
