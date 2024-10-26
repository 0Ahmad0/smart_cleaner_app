import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cleaner_app/core/enums/enums.dart';
import 'package:smart_cleaner_app/core/models/file_model.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';

class FileListWidget extends StatelessWidget {
  final List<FileModel>? files;
  final Function(FileModel)? onDelete;

  const FileListWidget({Key? key, this.files, this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Files (${files?.length ?? 0})",
          style: TextStyle(fontWeight: FontWeight.bold)),
      children: [
        ...?files?.map((file) {
          IconData iconData = _getFileIcon(file.type);
          return ListTile(
            leading:
            TypeFile.image.name==file.type&&(file.localUrl?.isNotEmpty??false)?
            Image.file(
              File(
                file.localUrl!,
              ),
              fit: BoxFit.cover,
            )
            :Icon(iconData, size: 40.sp),
            title: Text(file.name ?? "Unnamed File",
                style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(_formatFileSize(file.size)),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: ColorManager.errorColor),
              onPressed: () => onDelete?.call(file),
            ),
          );
        }).toList(),
      ],
    );
  }

  IconData _getFileIcon(String? type) {
    switch (TypeFile.values.where((element) => element.name == type).firstOrNull) {
      case TypeFile.image:
        return Icons.image;
      case TypeFile.audio:
        return Icons.audiotrack;
      case TypeFile.file:
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int? size) {
    if (size == null) return "Undefined";
    if (size < 1024) return "$size Byte";
    if (size < 1024 * 1024) return "${(size / 1024).toStringAsFixed(2)} KB";
    if (size < 1024 * 1024 * 1024) return "${(size / (1024 * 1024)).toStringAsFixed(2)} MB";
    return "${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB";
  }
}
