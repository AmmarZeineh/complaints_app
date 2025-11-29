import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerContainer extends StatelessWidget {
  final int maxFiles;
  final List<String> allowedExtensions;
  final List<XFile> selectedFiles;
  final Function(List<XFile>?)? onChanged;

  const FilePickerContainer({
    super.key,
    this.maxFiles = 5,
    this.allowedExtensions = const ['pdf', 'xlsx', 'xls'],
    this.selectedFiles = const [],
    this.onChanged,
  });

  Future<void> _pickFiles(BuildContext context) async {
    try {
      if (selectedFiles.length >= maxFiles) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('لا يمكن رفع أكثر من $maxFiles ملفات'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        List<XFile> newFiles = result.files
            .where((file) => file.path != null)
            .map((file) => XFile(file.path!))
            .toList();

        int remainingSlots = maxFiles - selectedFiles.length;
        if (newFiles.length > remainingSlots) {
          newFiles = newFiles.take(remainingSlots).toList();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم اختيار $remainingSlots ملف فقط (الحد الأقصى $maxFiles)',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }

        List<XFile> updatedFiles = [...selectedFiles, ...newFiles];
        onChanged?.call(updatedFiles);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء اختيار الملفات'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getFileTypeText() {
    List<String> types = [];
    if (allowedExtensions.contains('pdf')) types.add('PDF');
    if (allowedExtensions.contains('xlsx') ||
        allowedExtensions.contains('xls')) {
      types.add('Excel');
    }
    if (allowedExtensions.contains('doc') ||
        allowedExtensions.contains('docx')) {
      types.add('Word');
    }
    return types.isEmpty ? 'الملفات' : types.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pickFiles(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade400,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.upload_file,
              size: 50,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 15),
            Text(
              'اضغط لرفع الملفات',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 5),
            Text(
              '${_getFileTypeText()} (حتى $maxFiles ملفات)',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            if (selectedFiles.isNotEmpty) ...[
              SizedBox(height: 10),
              Text(
                '${selectedFiles.length} / $maxFiles',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
