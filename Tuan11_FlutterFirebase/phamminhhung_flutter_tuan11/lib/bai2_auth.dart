import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class UploadItem {
  final String name;
  final String extension;
  final String sizeText;
  final UploadTask task;
  StreamSubscription<TaskSnapshot>? subscription;
  double progress;
  TaskState state;
  String? downloadUrl;

  UploadItem({
    required this.name,
    required this.extension,
    required this.sizeText,
    required this.task,
    this.progress = 0.0,
    this.state = TaskState.running,
    this.downloadUrl,
  });
}

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final List<UploadItem> _uploadItems = [];
  bool _isEditing = false;

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  Future<void> _pickAndUploadFiles() async {
    final List<XFile> pickedFiles = await _picker.pickMultipleMedia();
    if (pickedFiles.isEmpty) return;

    for (final xFile in pickedFiles) {
      final file = File(xFile.path);
      final fileName = xFile.name;
      final ext = path.extension(fileName).replaceAll('.', '').toUpperCase();
      final sizeBytes = await file.length();
      final sizeText = _formatBytes(sizeBytes);

      final storageRef = _storage
          .ref()
          .child('uploads/${DateTime.now().millisecondsSinceEpoch}_$fileName');
      final uploadTask = storageRef.putFile(file);

      final item = UploadItem(
        name: fileName,
        extension: ext.isEmpty ? 'FILE' : ext,
        sizeText: sizeText,
        task: uploadTask,
      );

      item.subscription = uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) async {
          if (!mounted) return;
          setState(() {
            item.state = snapshot.state;
            if (snapshot.totalBytes > 0) {
              item.progress = snapshot.bytesTransferred / snapshot.totalBytes;
            }
          });
          if (snapshot.state == TaskState.success) {
            final url = await snapshot.ref.getDownloadURL();
            if (!mounted) return;
            setState(() {
              item.downloadUrl = url;
              item.progress = 1.0;
            });
          }
        },
        onError: (_) {
          if (!mounted) return;
          setState(() {
            item.state = TaskState.error;
          });
        },
      );

      setState(() {
        _uploadItems.insert(0, item);
      });
    }
  }

  Color _getBadgeColor(String ext) {
    switch (ext) {
      case 'JPG':
      case 'JPEG':
      case 'PNG':
        return const Color(0xFF9C88FF);
      case 'MP4':
      case 'MOV':
        return const Color(0xFF487EB0);
      default:
        return const Color(0xFF29B6F6);
    }
  }

  Color _getProgressColor(TaskState state) {
    switch (state) {
      case TaskState.success:
        return const Color(0xFF4CD137);
      case TaskState.paused:
        return const Color(0xFFFBC531);
      case TaskState.running:
        return const Color(0xFF29B6F6);
      default:
        return Colors.redAccent;
    }
  }

  @override
  void dispose() {
    for (final item in _uploadItems) {
      item.subscription?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF29B6F6);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close, color: primaryBlue),
          onPressed: () => Navigator.maybePop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Upload',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          if (_uploadItems.isNotEmpty)
            TextButton(
              onPressed: () => setState(() => _isEditing = !_isEditing),
              child: Text(
                _isEditing ? 'Done' : 'Edit',
                style: const TextStyle(color: primaryBlue, fontSize: 16),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _uploadItems.isEmpty
                ? Center(
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: primaryBlue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cloud_upload_rounded,
                        size: 80,
                        color: primaryBlue,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _uploadItems.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _uploadItems[index];
                      final percent = (item.progress * 100).toInt();

                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 52,
                              decoration: BoxDecoration(
                                color: _getBadgeColor(item.extension),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              alignment: Alignment.bottomCenter,
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                item.extension.length > 3
                                    ? item.extension.substring(0, 3)
                                    : item.extension,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${item.sizeText} ($percent%)',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: item.progress,
                                      minHeight: 4,
                                      backgroundColor: Colors.grey.shade200,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _getProgressColor(item.state),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (_isEditing)
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.red),
                                onPressed: () async {
                                  await item.task.cancel();
                                  await item.subscription?.cancel();
                                  setState(() {
                                    _uploadItems.removeAt(index);
                                  });
                                },
                              )
                            else if (item.state == TaskState.success)
                              const Icon(Icons.check,
                                  color: Color(0xFF4CD137), size: 24)
                            else if (item.state == TaskState.running)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () => item.task.pause(),
                                    child: const Icon(Icons.pause,
                                        color: primaryBlue, size: 24),
                                  ),
                                  const SizedBox(width: 6),
                                  InkWell(
                                    onTap: () => item.task.cancel(),
                                    child: const Icon(Icons.stop,
                                        color: Colors.redAccent, size: 24),
                                  ),
                                ],
                              )
                            else if (item.state == TaskState.paused)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () => item.task.resume(),
                                    child: const Icon(Icons.play_arrow,
                                        color: Color(0xFFFBC531), size: 26),
                                  ),
                                  const SizedBox(width: 6),
                                  InkWell(
                                    onTap: () => item.task.cancel(),
                                    child: const Icon(Icons.stop,
                                        color: Colors.redAccent, size: 24),
                                  ),
                                ],
                              )
                            else
                              const Icon(Icons.error_outline,
                                  color: Colors.red, size: 24),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _pickAndUploadFiles,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                elevation: 0,
              ),
              child: const Text(
                'Choose File',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}