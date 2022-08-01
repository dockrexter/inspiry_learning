import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:inspiry_learning/repositories/attachment_repositories.dart';

class Attachment {
  Attachment({
    String? path,
    required this.name,
    required this.size,
    this.bytes,
    this.downloadUrl,
  }) : _path = path;

  factory Attachment.fromMap(Map data, {Stream<List<int>>? readStream}) {
    return Attachment(
      name: data['name'],
      path: data['path'],
      bytes: data['bytes'],
      size: data['size'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['path'] = path;
    data['size'] = size;
    data['bytes'] = bytes;
    return data;
  }

  factory Attachment.formFile(File file) {
    return Attachment(
      name: file.path.split('/').last,
      path: file.path,
      bytes: file.readAsBytesSync(),
      size: file.lengthSync(),
    );
  }

  factory Attachment.formPlatformFile(PlatformFile platformFile) {
    return Attachment(
      name: platformFile.name,
      path: platformFile.path,
      bytes: platformFile.bytes,
      size: platformFile.size,
    );
  }

  Future<void> upload() async {
    downloadUrl ??= await AttachmentRepository().uploadAttachment(attachment: this);
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
  final Uint8List? bytes;
  String? get extension => name.split('.').last;
}
