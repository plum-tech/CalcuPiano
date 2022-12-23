import 'dart:io';

import 'package:calcupiano/foundation.dart';
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

  @override
  bool operator ==(Object other) {
    return other is BundledFileProtocol && runtimeType == other.runtimeType && path == other.path;
  }

  @override
  int get hashCode => path.hashCode;

  @override
  String toString() => "Bundled($path)";
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

  @override
  bool operator ==(Object other) {
    return other is LocalFileProtocol && runtimeType == other.runtimeType && localPath == other.localPath;
  }

  @override
  int get hashCode => localPath.hashCode;

  @override
  String toString() => "LocalFile($localPath)";
}

extension LocalFileProtocolX on LocalFileProtocol {
  Future<void> tryDelete() async {
    await toFile().delete();
  }
  File toFile() => File(localPath);
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

  @override
  bool operator ==(Object other) {
    return other is UrlFileProtocol && runtimeType == other.runtimeType && url == other.url;
  }

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() => "URL($url)";
}
