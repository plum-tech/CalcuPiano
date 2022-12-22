import 'dart:convert';
import 'dart:io';

import 'package:calcupiano/db.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/platform/platform.dart';
import 'package:calcupiano/r.dart';
import 'package:collection/collection.dart';
import 'package:archive/archive_io.dart';

/// For the file format of a Soundpack, please check the [Soundpack Specification](https://github.com/liplum/calcupiano/specifications/Soundpack.md).
Future<void> importSoundpackFromFile(String path) async {
  final inputStream = InputFileStream(path);
  // Decode the zip from the InputFileStream. The archive will have the contents of the
  // zip, without having stored the data in memory.
  final archive = ZipDecoder().decodeBuffer(inputStream);

  final archiveFiles = archive.files.toList(growable: false);

  final uuid = UUID.v4();
  final rootDir = joinPath(R.soundpacksRootDir, uuid);
  final files = <String>[];
  // For all of the entries in the archive
  for (final file in archiveFiles) {
    // If it's a file and not a directory
    if (file.isFile) {
      final path = joinPath(rootDir, file.name);
      files.add(path);
      final outputStream = OutputFileStream(path);
      // The writeContent method will decompress the file content directly to disk without
      // storing the decompressed data in memory.
      file.writeContent(outputStream);
      // Make sure to close the output stream so the File is closed.
      outputStream.close();
    }
  }
  // TODO: Save this into LocalSoundpack
  final Map<Note, LocalSoundFile> note2SoundFile = {};
  // TODO: I18n exception.
  // TODO: Handle exception.
  // ignore: use_function_type_syntax_for_parameters
  void findAndAddSoundFile(Note note, List<MapEntry<String, ArchiveFile>> name2ArchiveFile) {
    final candidates = name2ArchiveFile.where((it) => it.key.startsWith(note.id)).toList(growable: false);
    if (candidates.isEmpty) throw Exception("Sound file of Note<$note> not found.");
    if (candidates.length > 1) throw Exception("Ambiguous sound files, $candidates, of Note<$note>.");
    final noteFile = candidates[0].value;
    for (final format in R.supportedAudioFormat) {
      if (noteFile.name == "${note.id}.$format") {
        note2SoundFile[note] = LocalSoundFile(localPath: joinPath(rootDir, noteFile.name));
        return;
      }
    }
    throw Exception("Unsupported audio format, ${noteFile.name}.");
  }

  final fileName2ArchiveFile = archiveFiles.map((it) => MapEntry<String, ArchiveFile>(it.name, it)).toList();
  for (final note in Note.all) {
    findAndAddSoundFile(note, fileName2ArchiveFile);
  }

  final soundpackJson = files.firstWhereOrNull((it) => it.endsWith("soundpack.json"));
  SoundpackMeta? meta;
  if (soundpackJson != null) {
    final metaContent = await File(soundpackJson).readAsString();
    meta = Converter.fromUntypedJson(metaContent, SoundpackMeta.fromJson);
  }
  final soundpack = LocalSoundpack(uuid, meta ?? SoundpackMeta());
  soundpack.note2SoundFile = note2SoundFile;
  H.soundpacks.addSoundpack(soundpack);
}
