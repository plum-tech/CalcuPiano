import 'dart:io';

import 'package:calcupiano/foundation.dart';
import 'package:flutter/services.dart';

abstract class FileProtocol implements Convertible {
  /// Return the target path.
  /// The file name should follow [extSuggestion], but it is not required to.
  /// ## For example:
  /// - [parentFolder] is `myDisk/myFolder`.
  /// - [basenameWithoutExt] is `myFile`.
  /// - [extSuggestion] is `.wav`.
  /// The return value could be `myDisk/myFolder/myFile.wav`.
  /// But if the source file isn't a *.wav but a *.mp3, it can be `myDisk/myFolder/myFile.mp3`.
  Future<String> copyTo(String parentFolder, String basenameWithoutExt, {String? extSuggestion});
}

abstract class BundledFileProtocol implements FileProtocol {
  String get path;
}

mixin BundledFileMixin implements BundledFileProtocol {
  @override
  Future<String> copyTo(String parentFolder, String basenameWithoutExt, {String? extSuggestion}) async {
    ByteData data = await rootBundle.load(path);
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    String targetFile = joinPath(parentFolder, basenameWithoutExt, extensionOfPath(path));
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

abstract class LocalFileProtocol implements FileProtocol, Convertible {
  String get localPath;
}

mixin LocalFileMixin implements LocalFileProtocol {
  @override
  Future<String> copyTo(String parentFolder, String basenameWithoutExt, {String? extSuggestion}) async {
    String targetFile = joinPath(parentFolder, basenameWithoutExt, extensionOfPath(localPath));
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

abstract class UrlFileProtocol implements FileProtocol, Convertible {
  String get url;
}

mixin UrlFileMixin implements UrlFileProtocol {
  @override
  Future<String> copyTo(String parentFolder, String basenameWithoutExt, {String? extSuggestion}) async {
    String targetFile = joinPath(parentFolder, basenameWithoutExt, extSuggestion);
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
