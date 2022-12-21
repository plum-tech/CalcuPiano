// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soundpack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalSoundpack _$LocalSoundpackFromJson(Map<String, dynamic> json) =>
    LocalSoundpack(
      json['uuid'] as String,
    );

Map<String, dynamic> _$LocalSoundpackToJson(LocalSoundpack instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
    };

UrlSoundpack _$UrlSoundpackFromJson(Map<String, dynamic> json) => UrlSoundpack(
      json['uuid'] as String,
    );

Map<String, dynamic> _$UrlSoundpackToJson(UrlSoundpack instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
    };

SoundpackMeta _$SoundpackMetaFromJson(Map<String, dynamic> json) =>
    SoundpackMeta()
      ..name = json['name'] as String?
      ..description = json['description'] as String?
      ..author = json['author'] as String?
      ..url = json['url'] as String?
      ..l10n = (json['l10n'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, Map<String, String>.from(e as Map)),
      );

Map<String, dynamic> _$SoundpackMetaToJson(SoundpackMeta instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'author': instance.author,
      'url': instance.url,
      'l10n': instance.l10n,
    };
