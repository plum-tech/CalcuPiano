import 'dart:convert';

import 'package:calcupiano/foundation.dart';

abstract class Convertible {
  String get typeName;

  int get version => 1;
}

typedef ToJsonFunc<T> = Map<String, dynamic> Function(T obj);
typedef FromJsonFunc<T> = T Function(Map<String, dynamic> json);
typedef Migration = Map<dynamic, dynamic> Function(Map<dynamic, dynamic> origin, int oldVersion);

class _K {
  _K._();

  static const type = "@type";
  static const version = "@version";
}

class Converter {
  Converter._();

  static final Map<String, ToJsonFunc> _typeName2ToJson = {};
  static final Map<String, FromJsonFunc> _typeName2FromJson = {};
  static final Map<String, Migration> _migrations = {};
  static const JsonCodec _jsonCodec = JsonCodec(reviver: _reviver, toEncodable: _toEncodable);

  static Object? _reviver(Object? key, Object? value) {
    if (value is Map) {
      final type = value[_K.type];
      final fromFunc = _typeName2FromJson[type];
      if (fromFunc == null) {
        throw Exception("No FromJson for ${value.runtimeType} was found.");
      }
      final version = value[_K.version];
      if (version is int) {
        final migration = _migrations[type];
        if (migration != null) {
          value = migration(value, version);
        }
      }
      return fromFunc(value as Map<String, dynamic>);
    } else {
      return value;
    }
  }

  static Object? _toEncodable(dynamic object) {
    if (object is Convertible) {
      final type = object.typeName;
      final toFunc = _typeName2ToJson[type];
      if (toFunc == null) {
        throw Exception("No ToJson for ${object.typeName} was found.");
      }
      final json = toFunc(object);
      json[_K.type] = type;
      json[_K.version] = object.version;
      return json;
    }
    return object;
  }

  static void registerConverter<T extends Convertible>(String typeName, ToJsonFunc toJson, FromJsonFunc<T> fromJson) {
    _typeName2ToJson[typeName] = toJson;
    _typeName2FromJson[typeName] = fromJson;
  }

  static void registerMigration(String typeName, Migration migration) {
    _migrations[typeName] = migration;
  }

  static String? toJson<T>(T obj) {
    try {
      return _jsonCodec.encode(obj);
    } on JsonUnsupportedObjectError catch (e) {
      Log.e("Failed to convert $T to json", e.cause, e.stackTrace);
      return null;
    } on Error catch (e) {
      Log.e("Failed to convert $T to json", e, e.stackTrace);
      return null;
    } catch (any, stacktrace) {
      Log.e("Failed to convert $T to json", any, stacktrace);
      return null;
    }
  }

  /// If [T] is a collection, please use [List.cast], [Map.cast] or [Set.cast] to make a runtime-casting view.
  static T? fromJson<T>(String? json) {
    if (json == null) return null;
    try {
      return _jsonCodec.decode(json) as T?;
    } on JsonUnsupportedObjectError catch (e) {
      Log.e("Failed to convert json to $T", e.cause, e.stackTrace);
      return null;
    } on Error catch (e) {
      Log.e("Failed to convert json to $T", e, e.stackTrace);
      return null;
    } catch (any, stacktrace) {
      Log.e("Failed to convert json to $T", any, stacktrace);
      return null;
    }
  }

  static T? fromUntypedJson<T>(String? json, T Function(Map<String, dynamic> json) fromJson) {
    if (json == null) return null;
    try {
      final jObj = jsonDecode(json);
      return fromJson(jObj);
    } on JsonUnsupportedObjectError catch (e) {
      Log.e("Failed to convert json to $T", e.cause, e.stackTrace);
      return null;
    } on Error catch (e) {
      Log.e("Failed to convert json to $T", e, e.stackTrace);
      return null;
    } catch (any, stacktrace) {
      Log.e("Failed to convert json to $T", any, stacktrace);
      return null;
    }
  }

  static String? toUntypedJson<T>(T? obj, Map<String, dynamic> Function(T obj) toJson) {
    if (obj == null) return null;
    try {
      final jObj = toJson(obj);
      return jsonEncode(jObj);
    } on JsonUnsupportedObjectError catch (e) {
      Log.e("Failed to convert $T to json", e.cause, e.stackTrace);
      return null;
    } on Error catch (e) {
      Log.e("Failed to convert $T to json", e, e.stackTrace);
      return null;
    } catch (any, stacktrace) {
      Log.e("Failed to convert $T to json", any, stacktrace);
      return null;
    }
  }
  static dynamic directConvertFunc(dynamic any) => any;
}
