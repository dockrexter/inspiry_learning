import 'dart:io';
import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:inspiry_learning/repositories/attachment_repositories.dart';

class Attachment {
  Attachment({
    String? path,
    required this.name,
    required this.size,
    this.downloadUrl,
  }) : _path = path;

  factory Attachment.fromJson(dynamic data) {
    return Attachment(
      name: data["file_name"] as String,
      size: data["file_size"] as int,
      downloadUrl: data["download_url"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['file_name'] = name;
    data['file_size'] = size;
    data['download_url'] = size;
    return data;
  }

  factory Attachment.formFile(File file) {
    return Attachment(
      path: file.path,
      name: file.path.split('/').last,
      size: file.lengthSync(),
    );
  }

  factory Attachment.formPlatformFile(PlatformFile platformFile) {
    return Attachment(
      name: platformFile.name,
      path: platformFile.path,
      size: platformFile.size,
    );
  }

  Future<bool> upload() async {
    if (downloadUrl != null) return true;
    _path = await Utils.copyFile(_path, name);
    if (_path == null) return false;
    downloadUrl ??=
        await AttachmentRepository().uploadAttachment(attachment: this);
    return downloadUrl != null;
  }

  Future<bool> download() async {
    if (path != null) return true;
    if (downloadUrl == null) return false;
    _path ??= await Utils.downloadFile(downloadUrl!, name);
    return _path != null;
  }

  Future<bool> resolvePath(bool isUploaded) async {
    if (path != null) return true;
    _path = await Utils.resolvePath(name, isUploaded);
    return _path != null;
  }

  String? get path {
    return _path;
  }

  bool get isUploaded {
    return downloadUrl != null;
  }

  bool get isDownloaded {
    return _path != null;
  }

  String? _path;
  final int size;
  final String name;
  String? downloadUrl;
  String? get extension => name.split('.').last;
}
