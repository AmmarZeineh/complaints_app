import 'dart:io';
import 'dart:convert';
import 'package:complaints_app/core/utils/app_font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerContainer extends StatefulWidget {
  const ImagePickerContainer({super.key, required this.onChanged});
  final ValueChanged<String?> onChanged;

  @override
  State<ImagePickerContainer> createState() => _ImagePickerContainerState();
}

class _ImagePickerContainerState extends State<ImagePickerContainer> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();

        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );

        if (image != null) {
          imageFile = File(image.path);

          // تحويل الصورة إلى base64
          final bytes = await imageFile!.readAsBytes();
          final base64Image = base64Encode(bytes);

          // تمرير القيمة للواجهة الأم
          widget.onChanged(base64Image);

          setState(() {});
        }
      },
      child: Container(
        height: 180.h,
        width: double.infinity,
        decoration: const BoxDecoration(),
        child: imageFile == null
            ? Center(
                child: Text('انقر لرفع صورة', style: AppTextStyles.w400_16),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.file(imageFile!, fit: BoxFit.fill),
              ),
      ),
    );
  }
}
