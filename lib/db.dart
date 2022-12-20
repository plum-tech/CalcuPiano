import 'package:calcupiano/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

import 'converter.dart';

class K {
  K._();

  static const customSoundpackIdList = "Custom-Soundpack-ID-List";
  static const currentSoundpackID = "Current-Soundpack-ID";
  static const isDarkMode = "Is-Dark-Mode";
}

class H {
  H._();

  /// To reduce complexity, CalcuPiano will save the settings in only one box with fixed keys,
  /// see [K], application-wide.
  static late final Box<dynamic> box;

  /// [SoundpackStorage] contains all custom soundpacks, including copies.
  static late final SoundpackStorage soundpacks;

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

class SoundpackStorage {
  final Box<String> soundpacks;

  const SoundpackStorage(this.soundpacks);

  Soundpack? getSoundpackById(String id) {
    final json = soundpacks.get(id);
    if (json == null) {
      return null;
    }
    return Converter.fromJson<Soundpack>(json);
  }

  ValueListenable<Box<String>> listenable({List<String>? keys}) => soundpacks.listenable(keys: keys);
}
