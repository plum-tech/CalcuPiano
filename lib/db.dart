import 'dart:io';

import 'package:calcupiano/r.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

class K {
  K._();

  static const externalSoundpackIdList = "External-Soundpack-ID-List";
  static const currentSoundpackID = "Current-Soundpack-ID";
  static const isDarkMode = "Is-Dark-Mode";
}

final H = HImpl._();
// ignore: non_constant_identifier_names
final DB = DBImpl();

class HImpl {
  HImpl._();

  /// To reduce complexity, CalcuPiano will save the settings in only one box with fixed keys,
  /// see [K], application-wide.
  late Box<dynamic> box;

  String? get currentSoundpackID => box.get(K.currentSoundpackID) as String?;

  set currentSoundpackID(String? id) => box.put(K.currentSoundpackID, id);

  List<String>? get externalSoundpackIdList => box.get(K.externalSoundpackIdList) as List<String>?;

  set externalSoundpackIdList(List<String>? list) => box.put(K.externalSoundpackIdList, list);

  bool? get isDarkMode => box.get(K.isDarkMode) as bool?;

  set isDarkMode(bool? newVal) => box.put(K.isDarkMode, newVal);

  ValueListenable<Box<dynamic>> listenToCurrentSoundpackID() {
    return box.listenable(keys: const [K.currentSoundpackID]);
  }

  ValueListenable<Box<dynamic>> listenToCustomSoundpackIdList() {
    return box.listenable(keys: const [K.externalSoundpackIdList]);
  }
}

extension HImplX on HImpl {
  void ensureCurrentSoundpackIdValid() {
    final idList = H.externalSoundpackIdList ?? [];
    final current = currentSoundpackID;
    if (current == null) {
      currentSoundpackID = R.defaultSoundpack.id;
    } else if (!idList.contains(current)) {
      currentSoundpackID = idList.isNotEmpty ? idList.first : R.defaultSoundpack.id;
    }
  }
}

class ListenTo {
  final List<String>? keys;

  /// It indicates this *Build Method* will listen to specific key/keys,
  /// any change will lead to a rebuild in this hierarchy.
  const ListenTo([this.keys]);
}

/// [SoundpackStorage] contains all external soundpacks.
class DBImpl {
  late final Box<String> box;

  /// High-level operation
  ExternalSoundpackProtocol? getSoundpackById(String id) {
    final json = box.get(id);
    return Converter.fromJson<ExternalSoundpackProtocol>(json);
  }

  /// Low-level operation.
  /// Set the soundpack directly will not clear the local file, or change [H.externalSoundpackIdList].
  /// Note: Any further change won't be saved.
  void setSoundpackSnapshotById(ExternalSoundpackProtocol soundpack) {
    final json = Converter.toJson<ExternalSoundpackProtocol>(soundpack);
    if (json != null) {
      box.put(soundpack.id, json);
    }
  }

  /// High-level operation
  /// Add current snapshot of soundpack to storage.
  /// Note: Any further change won't be saved.
  void addSoundpackSnapshot(ExternalSoundpackProtocol soundpack) {
    setSoundpackSnapshotById(soundpack);
    final idList = H.externalSoundpackIdList ?? [];
    idList.add(soundpack.id);
    idList.distinct();
    H.externalSoundpackIdList = idList;
  }

  /// High-level operation
  Future<void> removeSoundpackById(String id) async {
    final idList = H.externalSoundpackIdList ?? [];
    String? nextOne;
    final deletedIndex = idList.indexOf(id);
    idList.remove(id);
    if (idList.isNotEmpty) {
      // Don't worry, `deletedIndex + 1` must be larger-equal then 0.
      nextOne = idList[(deletedIndex + 1) % idList.length];
    }
    H.externalSoundpackIdList = idList;
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

  ValueListenable<Box<String>> listenable({List<String>? keys}) => box.listenable(keys: keys);
}
