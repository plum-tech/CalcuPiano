import 'dart:io';

import 'package:calcupiano/db.dart';
import 'package:calcupiano/extension/soundpack.dart';
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
  // ----------------------------------------------------------------
  // Mapping(Copying) the archive files to local files.
  /// Only including file. No Folder.
  /// Note: If an archive file in a archive folder, its name is `myFolder/myFile.ext`
  final archiveFileName2LocalPath = <String, String>{};
  // For all of the entries in the archive
  for (final file in archiveFiles) {
    // If it's a file and not a directory
    if (file.isFile) {
      final targetPath = joinPath(rootDir, file.name);
      archiveFileName2LocalPath[file.name] = targetPath;
      final outputStream = OutputFileStream(targetPath);
      // The writeContent method will decompress the file content directly to disk without
      // storing the decompressed data in memory.
      file.writeContent(outputStream);
      // Make sure to close the output stream so the File is closed.
      outputStream.close();
    }
  }
  // ----------------------------------------------------------------
  // Find sound files of all notes.
  final Map<Note, LocalSoundFile> note2SoundFile = {};
  // TODO: I18n exception.
  // TODO: Handle exception.
  final fileName2ArchiveFile = archiveFiles.map((it) => MapEntry<String, ArchiveFile>(it.name, it)).toList();
  for (final note in Note.all) {
    final candidates = fileName2ArchiveFile.where((it) => it.key.startsWith(note.id)).toList(growable: false);
    if (candidates.isEmpty) throw Exception("Sound file of Note<$note> not found.");
    if (candidates.length > 1) throw Exception("Ambiguous sound audio file detected, $candidates, of Note<$note>.");
    final noteFile = candidates[0].value;
    if (R.supportedAudioExtension.contains(extensionOfPath(noteFile.name).toLowerCase())) {
      note2SoundFile[note] = LocalSoundFile(localPath: joinPath(rootDir, noteFile.name));
      continue;
    }
    throw Exception("Unsupported audio format, ${noteFile.name}.");
  }
  // ----------------------------------------------------------------
  // Finding helper function.
  String? findCaseInsensitiveLocalFileByName(String targetName) {
    return archiveFileName2LocalPath.entries.firstWhereOrNull((it) => it.key.toLowerCase() == targetName)?.value;
  }

  // ----------------------------------------------------------------
  // Find `soundpack.json`
  final soundpackJsonLocalPath = findCaseInsensitiveLocalFileByName("soundpack.json");
  SoundpackMeta? meta;
  if (soundpackJsonLocalPath != null) {
    final metaContent = await File(soundpackJsonLocalPath).readAsString();
    meta = Converter.fromUntypedJson(metaContent, SoundpackMeta.fromJson);
  }
  // ----------------------------------------------------------------
  // Find the `preview.png`
  final previewPngLocalPath = findCaseInsensitiveLocalFileByName("soundpack.json");

  // ----------------------------------------------------------------
  // Make the final LocalSoundpack object.
  final soundpack = LocalSoundpack(uuid: uuid, meta: meta ?? SoundpackMeta());
  soundpack.note2SoundFile = note2SoundFile;
  soundpack.addToStorage();
}

Future<void> duplicateSoundpack(SoundpackProtocol source) async {
  final uuid = UUID.v4();
  final SoundpackMeta meta;
  if (source is ExternalSoundpackProtocol) {
    final sourceName = source.meta.name;
    // TODO: L10n
    meta = source.meta.copyWith(
      name: sourceName == null ? null : "$sourceName~Copy",
    );
  } else {
    meta = SoundpackMeta();
  }
  final Map<Note, LocalSoundFile> note2SoundFiles = {};
  final rootDir = joinPath(R.soundpacksRootDir, uuid);
  await Directory(rootDir).create(recursive: true);
  for (final note in Note.all) {
    final file = await source.resolve(note);
    final localFilePath = await file.copyToFolder(rootDir);
    note2SoundFiles[note] = LocalSoundFile(localPath: localFilePath);
  }
  final soundpack = LocalSoundpack(uuid: uuid, meta: meta)..note2SoundFile = note2SoundFiles;
  soundpack.addToStorage();
}
