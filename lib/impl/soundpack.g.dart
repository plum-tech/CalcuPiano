// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soundpack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
