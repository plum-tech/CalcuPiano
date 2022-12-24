import 'dart:io';

import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:collection/collection.dart';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sanitize_filename/sanitize_filename.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Packager provides An abstract layer to interact with local storage, disk and cloud.
///
/// ## Use cases:
/// - Dealing with soundpack archive, aka. `soundpack.zip`.
///
///
class Packager {
  Packager._();

  static Future<void> pickAndImportSoundpackArchive() async {
    final path = await Packager.tryPickSoundpackArchive();
    if (path != null) {
      await Packager.importSoundpackFromFile(path);
    }
  }

  /// Pick the possible soundpack archive depended on platform.
  /// Return the path if picked. Null if canceled.
  static Future<String?> tryPickSoundpackArchive() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['zip'],
      withData: true,
      lockParentWindow: true,
    );
    return result?.files.single.path;
  }

  /// For the file format of a Soundpack, please check the [Soundpack Specification](https://github.com/liplum/calcupiano/specifications/Soundpack.md).
  static Future<void> importSoundpackFromFile(String path) async {
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
      if (R.supportedAudioDotExtension.contains(extensionOfPath(noteFile.name).toLowerCase())) {
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
    final previewPngLocalPath = findCaseInsensitiveLocalFileByName("preview.png");
    LocalImageFile? previewImg;
    if (previewPngLocalPath != null) {
      previewImg = LocalImageFile(localPath: previewPngLocalPath);
    }
    // ----------------------------------------------------------------
    // Make the final LocalSoundpack object.
    final soundpack = LocalSoundpack(uuid: uuid, meta: meta ?? SoundpackMeta());
    soundpack.preview = previewImg;
    soundpack.note2SoundFile = note2SoundFile;
    DB.addSoundpackSnapshot(soundpack);
  }

  /// For the file format of a Soundpack, please check the [Soundpack Specification](https://github.com/liplum/calcupiano/specifications/Soundpack.md).
  /// Preconditions:
  /// - Ensure audio files of all essential notes are mounted in [LocalSoundpack.note2SoundFile].
  /// Postconditions:
  /// - The packed soundpack will be saved in temporary folder, see [getTemporaryDirectory].
  ///
  /// return the path of soundpack archive in temporary folder.
  static Future<String> packLocalSoundpack(LocalSoundpack soundpack, {String? fileNameSuggestion}) async {
    final String fileName;
    if (fileNameSuggestion != null) {
      fileName = sanitizeFilename(fileNameSuggestion);
    } else {
      fileName = sanitizeFilename("${soundpack.uuid}.zip");
    }
    final archiveTargetPath = joinPath(R.tmpDir, fileName);
    final rootDir = joinPath(R.soundpacksRootDir, soundpack.uuid);

    // ----------------------------------------------------------------
    // Zipping
    final archive = ZipFileEncoder();
    archive.zipDirectory(Directory(rootDir), filename: archiveTargetPath);
    // ----------------------------------------------------------------
    return archiveTargetPath;
  }

  /// Save-as the soundpack archive depended on platform.
  /// The archive will be removed after exported.
  /// ## Supported Platforms:
  /// - Windows
  /// - macOS
  /// - Linux
  static Future<void> saveAsSoundpackArchive(LocalSoundpack soundpack) async {
    var fileNameSuggestion = soundpack.meta.name;
    if (fileNameSuggestion != null) {
      fileNameSuggestion = sanitizeFilename("$fileNameSuggestion.zip");
    }
    final targetPath = await FilePicker.platform.saveFile(
      type: FileType.custom,
      fileName: fileNameSuggestion,
      allowedExtensions: const ['zip'],
      lockParentWindow: true,
    );
    if (targetPath != null) {
      final archivePath = await packLocalSoundpack(soundpack);
      // TODO: Windows works fine. It lacks test on Linux and macOS.
      await File(archivePath).copy(targetPath);
      await File(archivePath).delete();
    }
  }

  /// Share the soundpack archive depended on platform.
  /// The archive will be removed after exported.
  /// ## Supported Platforms:
  /// - Android
  /// - iOS
  /// - macOS
  /// - Web
  static Future<void> shareSoundpackArchive(LocalSoundpack soundpack) async {
    // TODO: Test on iOS, Web and macOS.
    var fileNameSuggestion = soundpack.meta.name;
    if (fileNameSuggestion != null) {
      fileNameSuggestion = sanitizeFilename("$fileNameSuggestion.zip");
    }
    final archivePath = await packLocalSoundpack(soundpack, fileNameSuggestion: fileNameSuggestion);
    // TODO: Better meta
    await Share.shareXFiles(
      [XFile(archivePath)],
      subject: soundpack.meta.name,
      text: soundpack.meta.description,
    );
    await File(archivePath).delete();
  }

  /// Write [LocalSoundpack.meta] to local storage.
  static Future<void> writeSoundpackMetaFile(LocalSoundpack soundpack) async {
    final rootDir = joinPath(R.soundpacksRootDir, soundpack.uuid);
    final soundpackJson = Converter.toUntypedJson(soundpack.meta, indent: 2);
    if (soundpackJson != null) {
      await File(joinPath(rootDir, "soundpack.json")).writeAsString(soundpackJson);
    }
  }

  /// Write [LocalSoundpack.note2SoundFile] to local storage.
  /// To prevent overwriting itself, all involved files will be cached in temporary folder during writing.
  static Future<void> writeSoundFiles(LocalSoundpack soundpack) async {}

  /// Duplicate doesn't work on Web
  static Future<void> duplicateSoundpack(SoundpackProtocol source) async {
    if (kIsWeb) return;
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
      final file = source.resolve(note);
      final localFilePath = await file.copyToFolder(rootDir);
      note2SoundFiles[note] = LocalSoundFile(localPath: localFilePath);
    }
    final soundpack = LocalSoundpack(uuid: uuid, meta: meta)..note2SoundFile = note2SoundFiles;
    DB.addSoundpackSnapshot(soundpack);
  }

  /// Only Works on Desktop
  static Future<void> revealSoundpackInFolder(LocalSoundpack soundpack) async {
    if (isDesktop) {
      final path = joinPath(R.soundpacksRootDir, soundpack.id);
      final url = Uri.file(path, windows: isWindows);
      launchUrl(url);
    }
  }

  /// Pick the possible audio file depended on platform.
  /// Return the path if picked. Null if canceled.
  static Future<String?> tryPickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: R.supportedAudioFormat,
      withData: true,
      lockParentWindow: true,
    );
    return result?.files.single.path;
  }

  static Future<String?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }

  /// Return the `preview.png`.
  static Future<LocalImageFile> copyImageAsPreview(LocalSoundpack soundpack, {required String sourceImagePath}) async {
    final targetPath = joinPath(R.soundpacksRootDir, soundpack.uuid, "preview.png");
    await File(sourceImagePath).copy(targetPath);
    return LocalImageFile(localPath: targetPath);
  }
}
