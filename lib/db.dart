import 'dart:io';

import 'package:calcupiano/r.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/platform/platform.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

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
  static late Box<dynamic> box;

  /// [SoundpackStorage] contains all external soundpacks.
  static late SoundpackStorage soundpacks;

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

  /// High-level operation
  ExternalSoundpackProtocol? getSoundpackById(String id) {
    final json = soundpacks.get(id);
    return Converter.fromJson<ExternalSoundpackProtocol>(json);
  }

  /// Low-level operation.
  /// Set the soundpack directly will not clear the local file, or change [H.customSoundpackIdList].
  void setSoundpackById(ExternalSoundpackProtocol soundpack) {
    final json = Converter.toJson<ExternalSoundpackProtocol>(soundpack);
    if (json != null) {
      soundpacks.put(soundpack.id, json);
    }
  }

  /// High-level operation
  void addSoundpack(ExternalSoundpackProtocol soundpack) {
    setSoundpackById(soundpack);
    final idList = H.customSoundpackIdList ?? [];
    idList.add(soundpack.id);
    H.customSoundpackIdList = idList;
  }

  /// High-level operation
  Future<void> removeSoundpackById(String id) async {
    final idList = H.customSoundpackIdList ?? [];
    String? nextOne;
    final deletedIndex = idList.indexOf(id);
    idList.remove(id);
    if (idList.isNotEmpty) {
      // Don't worry, `deletedIndex + 1` must be larger-equal then 0.
      nextOne = idList[(deletedIndex + 1) % idList.length];
    }
    H.customSoundpackIdList = idList;
    if (H.currentSoundpackID == id) {
      // If currently-used soundpack was deleted, jump to next one.
      if (nextOne != null) {
        H.currentSoundpackID = nextOne;
      } else {
        // If id list is empty, use default soundpack.
        H.currentSoundpackID = R.defaultSoundpack.id;
      }
    }
    // Delete the local files.
    // TODO: What if the [LocalSoundFile] is referenced in another soundpack? To prevent the deletion, or to only delete unreferenced files?
    final file = File(joinPath(R.soundpacksRootDir, id));
    await file.delete(recursive: true);
  }

  ValueListenable<Box<String>> listenable({List<String>? keys}) => soundpacks.listenable(keys: keys);
}
