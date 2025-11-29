import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImagePickerContainer extends StatelessWidget {
  final int maxImages;
  final List<XFile> selectedImages;
  final Function(List<XFile>?)? onChanged;

  const ImagePickerContainer({
    super.key,
    this.maxImages = 5,
    this.selectedImages = const [],
    this.onChanged,
  });

  Future<void> _pickImages(BuildContext context, ImageSource source) async {
    try {
      if (selectedImages.length >= maxImages) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('لا يمكن رفع أكثر من $maxImages صور'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final ImagePicker picker = ImagePicker();

      if (source == ImageSource.gallery) {
        final List<XFile> images = await picker.pickMultiImage();

        if (images.isNotEmpty) {
          int remainingSlots = maxImages - selectedImages.length;
          List<XFile> newImages = images;

          if (newImages.length > remainingSlots) {
            newImages = newImages.take(remainingSlots).toList();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم اختيار $remainingSlots صورة فقط (الحد الأقصى $maxImages)',
                ),
                backgroundColor: Colors.orange,
              ),
            );
          }

          List<XFile> updatedImages = [...selectedImages, ...newImages];
          onChanged?.call(updatedImages);
        }
      } else {
        final XFile? image = await picker.pickImage(source: source);

        if (image != null) {
          List<XFile> updatedImages = [...selectedImages, image];
          onChanged?.call(updatedImages);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء اختيار الصور'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'اختر مصدر الصورة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(
                    Icons.photo_library,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text('المعرض'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImages(context, ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text('الكاميرا'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImages(context, ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showImageSourceDialog(context),
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
              Icons.add_photo_alternate,
              size: 50,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 15),
            Text(
              'اضغط لإضافة صور',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'من الكاميرا أو المعرض (حتى $maxImages صور)',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            if (selectedImages.isNotEmpty) ...[
              SizedBox(height: 10),
              Text(
                '${selectedImages.length} / $maxImages',
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
