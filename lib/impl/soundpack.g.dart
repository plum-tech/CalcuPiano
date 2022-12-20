// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soundpack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundledSoundFile _$BundledSoundFileFromJson(Map<String, dynamic> json) =>
    BundledSoundFile(
      path: json['path'] as String,
    );

Map<String, dynamic> _$BundledSoundFileToJson(BundledSoundFile instance) =>
    <String, dynamic>{
      'path': instance.path,
    };

LocalSoundFile _$LocalSoundFileFromJson(Map<String, dynamic> json) =>
    LocalSoundFile(
      path: json['path'] as String,
    );

Map<String, dynamic> _$LocalSoundFileToJson(LocalSoundFile instance) =>
    <String, dynamic>{
      'path': instance.path,
    };

LocalSoundpack _$LocalSoundpackFromJson(Map<String, dynamic> json) =>
    LocalSoundpack(
      json['uuid'] as String,
      json['name'] as String,
    )..description = json['description'] as String;

Map<String, dynamic> _$LocalSoundpackToJson(LocalSoundpack instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'description': instance.description,
    };
