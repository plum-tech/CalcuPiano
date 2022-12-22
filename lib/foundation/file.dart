import 'dart:io';

import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/platform/platform.dart';
import 'package:flutter/services.dart';

abstract class FileProtocol implements Convertible {
  /// Return the target path.
  Future<String> copyToFolder(String pathOfFolder);
}

abstract class BundledFileProtocol implements FileProtocol {
  String get path;
}

mixin BundledFileMixin implements BundledFileProtocol {
  @override
  Future<String> copyToFolder(String pathOfFolder) async {
    ByteData data = await rootBundle.load(path);
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    String targetFile = joinPath(pathOfFolder, basenameOfPath(path));
    await File(targetFile).writeAsBytes(bytes);
    return targetFile;
  }
}

abstract class LocalFileProtocol implements Convertible {
  String get localPath;
}

mixin LocalFileMixin implements LocalFileProtocol {
  Future<String> copyToFolder(String pathOfFolder) async {
    String targetFile = joinPath(pathOfFolder, basenameOfPath(localPath));
    await File(localPath).copy(targetFile);
    return targetFile;
  }
}

abstract class UrlFileProtocol implements Convertible {
  String get url;
}

mixin UrlFileMixin implements UrlFileProtocol {
  Future<String> copyToFolder(String pathOfFolder) async {
    // TODO: How can I know the file name and extension?
    String targetFile = joinPath(pathOfFolder, basenameOfPath(url));
    await Web.download(url, targetFile);
    return targetFile;
  }
}
