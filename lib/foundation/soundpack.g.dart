// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soundpack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalSoundpack _$LocalSoundpackFromJson(Map<String, dynamic> json) =>
    LocalSoundpack(
      uuid: json['uuid'] as String,
      meta: Converter.directConvertFunc(json['meta']),
      preview: Converter.directConvertFunc(json['preview']),
    )..note2SoundFile = LocalSoundpack._note2FilesFromJson(
        json['note2SoundFile'] as Map<String, dynamic>);

Map<String, dynamic> _$LocalSoundpackToJson(LocalSoundpack instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'meta': Converter.directConvertFunc(instance.meta),
      'note2SoundFile':
          LocalSoundpack._note2FilesToJson(instance.note2SoundFile),
      'preview': Converter.directConvertFunc(instance.preview),
    };

UrlSoundpack _$UrlSoundpackFromJson(Map<String, dynamic> json) => UrlSoundpack(
      uuid: json['uuid'] as String,
      meta: Converter.directConvertFunc(json['meta']),
      url: json['url'] as String,
      preview: Converter.directConvertFunc(json['preview']),
    )..note2SoundFile = UrlSoundpack._note2FilesFromJson(
        json['note2SoundFile'] as Map<String, dynamic>);

Map<String, dynamic> _$UrlSoundpackToJson(UrlSoundpack instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'url': instance.url,
      'meta': Converter.directConvertFunc(instance.meta),
      'preview': Converter.directConvertFunc(instance.preview),
      'note2SoundFile': UrlSoundpack._note2FilesToJson(instance.note2SoundFile),
    };

SoundpackMeta _$SoundpackMetaFromJson(Map<String, dynamic> json) =>
    SoundpackMeta()
      ..name = json['name'] as String?
      ..description = json['description'] as String?
      ..author = json['author'] as String?
      ..url = json['url'] as String?;

Map<String, dynamic> _$SoundpackMetaToJson(SoundpackMeta instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'author': instance.author,
      'url': instance.url,
    };
