import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

class K {
  K._();

  static const customSoundpackIdList = "Custom-Soundpack-ID-List";
  static const currentSoundpackID = "Current-Soundpack-ID";
  static const isDarkMode = "Is-Dark-Mode";
}

/// To reduce complexity, CalcuPiano will save the settings in only one box with fixed keys,
/// see [K], application-wide.
class H {
  H._();

  static late final Box<dynamic> box;

  static String? get currentSoundpackID => box.get(K.currentSoundpackID) as String?;

  static set currentSoundpackID(String? id) => box.put(K.currentSoundpackID, id);

  static List<String>? get customSoundpackIdList => box.get(K.customSoundpackIdList) as List<String>?;

  static set customSoundpackIdList(List<String>? list) => box.put(K.customSoundpackIdList, list);

  static bool? get isDarkMode => box.get(K.isDarkMode) as bool?;

  static set isDarkMode(bool? newVal) => box.put(K.isDarkMode, newVal);

  static ValueListenable<Box<dynamic>> listenToCurrentSoundpackID() {
    return box.listenable(keys: const [K.currentSoundpackID]);
  }

  static ValueListenable<Box<dynamic>> listenToCustomSoundpackIdList() {
    return box.listenable(keys: const [K.customSoundpackIdList]);
  }
}

class ListenTo {
  final List<String>? keys;

  /// It indicates this *Build Method* will listen to specific key/keys,
  /// any change will lead to a rebuild in this hierarchy.
  const ListenTo([this.keys]);
}
