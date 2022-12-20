import 'dart:convert';

import 'package:calcupiano/foundation.dart';

abstract class Convertible {
  String get typeName;

  int get version => 1;
}

typedef ToJsonFunc<T> = Map<String, dynamic> Function(T obj);
typedef FromJsonFunc<T> = T Function(Map<String, dynamic> json);
typedef Migration = Map<String, dynamic> Function(Map<String, dynamic> origin, int oldVersion);

class _K {
  _K._();

  static const type = "@type";
  static const version = "@version";
}

class Converter {
  static final Map<String, ToJsonFunc> _typeName2ToJson = {};
  static final Map<String, FromJsonFunc> _typeName2FromJson = {};
  static final Map<String, Migration> _migrations = {};

  static void registerConverter<T extends Convertible>(
      String typeName, ToJsonFunc<T> toJson, FromJsonFunc<T> fromJson) {
    _typeName2ToJson[typeName] = toJson as ToJsonFunc;
    _typeName2FromJson[typeName] = fromJson;
  }

  static void registerMigration(String typeName, Migration migration) {
    _migrations[typeName] = migration;
  }

  static Map<String, dynamic>? toJsonObj<T extends Convertible>(T obj) {
    final toJson = _typeName2ToJson[obj.typeName];
    if (toJson == null) {
      return null;
    }
    final dynamic jObj;
    try {
      jObj = toJson(obj);
    } catch (e) {
      Log.wtf("Failed to convert $T object to json???", e);
      return null;
    }
    jObj[_K.type] = obj.typeName;
    jObj[_K.version] = obj.version;
    return jObj;
  }

  static String? toJson<T extends Convertible>(T obj) {
    final jObj = toJsonObj<T>(obj);
    if (jObj == null) {
      return null;
    }
    return jsonEncode(jObj);
  }

  static List<dynamic> toJsonList<T extends Convertible>(List<T?> list) {
    final List<dynamic> res = [];
    for (final obj in list) {
      res.add(obj == null ? null : toJsonObj<T>(obj));
    }
    return res;
  }

  static T? fromJsonObj<T>(Map<String, dynamic> jObj) {
    try {
      final typeName = jObj[_K.type];
      if (typeName is! String) {
        return null;
      }
      final fromJson = _typeName2FromJson[typeName];
      if (fromJson == null) {
        return null;
      }
      final version = jObj[_K.version];
      if (version != null) {
        final migration = _migrations[typeName];
        if (migration != null) {
          jObj = migration(jObj, version);
        }
      }
      final res = fromJson(jObj);
      return res;
    } catch (e) {
      Log.e("Failed to convert json object to $T object", e);
      return null;
    }
  }

  static T? fromJson<T>(String json) {
    final dynamic jObj;
    try {
      jObj = jsonDecode(json);
    } catch (e) {
      Log.e("Failed to decode json object", e);
      return null;
    }
    return fromJsonObj<T>(jObj);
  }

  static List<T>? fromJsonList<T>(List<dynamic> list) {
    try {
      final List<T> res = [];
      for (final obj in list) {
        res.add(fromJsonObj<T>(obj) as T);
      }
      return res;
    } catch (e) {
      Log.e("Failed to convert json list to $T list", e);
      return null;
    }
  }

  static List<T?>? fromJsonNullableList<T>(List<dynamic> list) {
    try {
      final List<T?> res = [];
      for (final obj in list) {
        res.add(fromJsonObj<T>(obj));
      }
      return res;
    } catch (e) {
      Log.e("Failed to convert json list to $T? list", e);
      return null;
    }
  }
}
