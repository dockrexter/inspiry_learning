import 'dart:io';
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:inspiry_learning/repositories/attachment_repositories.dart';

class Attachment {
  Attachment({
    String? path,
    required this.name,
    required this.size,
    this.downloadUrl,
  }) : _path = path;

  factory Attachment.fromMap(Map data, {Stream<List<int>>? readStream}) {
    return Attachment(
      name: data['file_name'],
      size: data['file_size'],
      downloadUrl: data['download_url'],
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

  Future<void> upload() async {
    downloadUrl ??=
        await AttachmentRepository().uploadAttachment(attachment: this);
  }

  String? get path {
    return _path;
  }

  bool get isUploaded {
    return downloadUrl != null;
  }

  String? _path;
  final int size;
  final String name;
  String? downloadUrl;
  String? get extension => name.split('.').last;
}
