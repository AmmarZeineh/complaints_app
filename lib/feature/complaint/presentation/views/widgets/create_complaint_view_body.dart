
import 'package:complaints_app/core/widgets/custom_elevated_button.dart';
import 'package:complaints_app/core/widgets/custom_text_form_field.dart';
import 'package:complaints_app/feature/complaint/presentation/cubits/create_complaint_cubit/create_complaint_cubit.dart';
import 'package:complaints_app/feature/complaint/presentation/views/widgets/drop_down.dart';
import 'package:complaints_app/feature/complaint/presentation/views/widgets/image_picker_container.dart';
import 'package:complaints_app/feature/complaint/presentation/views/widgets/file_picker_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreateComplaintViewBody extends StatefulWidget {
  const CreateComplaintViewBody({super.key});

  @override
  State<CreateComplaintViewBody> createState() =>
      _CreateComplaintViewBodyState();
}

class _CreateComplaintViewBodyState extends State<CreateComplaintViewBody> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  int? selectedGovernmentId;
  String? type, des, location;
  List<XFile> imageFiles = [];
  List<XFile> attachmentFiles = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'إنشاء شكوى جديدة',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

              CustomFormTextField(
                title: "نوع الشكوى",
                textInputType: TextInputType.text,
                onSaved: (value) => type = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال نوع الشكوى';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              CustomFormTextField(
                title: "الوصف",
                textInputType: TextInputType.multiline,
                maxLines: 4,
                onSaved: (value) => des = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال وصف الشكوى';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // الموقع
              CustomFormTextField(
                title: "الموقع",
                textInputType: TextInputType.text,
                onSaved: (value) => location = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الموقع';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // اختيار المحافظة
              GovernmentDropdown(
                onSelect: (id) {
                  setState(() {
                    selectedGovernmentId = id;
                  });
                },
              ),
              SizedBox(height: 30),

              // قسم رفع الصور
              _buildSectionTitle('رفع الصور (حتى 5 صور)'),
              SizedBox(height: 10),
              ImagePickerContainer(
                maxImages: 5,
                selectedImages: imageFiles,
                onChanged: (files) {
                  setState(() {
                    imageFiles = files ?? [];
                  });
                },
              ),
              if (imageFiles.isNotEmpty) ...[
                SizedBox(height: 10),
                _buildSelectedFilesChips(imageFiles, isImage: true),
              ],
              SizedBox(height: 30),

              // قسم رفع الملفات
              _buildSectionTitle('رفع الملفات (PDF, Excel - حتى 5 ملفات)'),
              SizedBox(height: 10),
              FilePickerContainer(
                maxFiles: 5,
                allowedExtensions: ['pdf', 'xlsx', 'xls'],
                selectedFiles: attachmentFiles,
                onChanged: (files) {
                  setState(() {
                    attachmentFiles = files ?? [];
                  });
                },
              ),
              if (attachmentFiles.isNotEmpty) ...[
                SizedBox(height: 10),
                _buildSelectedFilesChips(attachmentFiles, isImage: false),
              ],
              SizedBox(height: 40),

              // زر الإرسال
              BlocConsumer<CreateComplaintCubit, CreateComplaintState>(
                listener: (context, state) {
                  if (state is CreateComplaintSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم إرسال الشكوى بنجاح'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    formKey.currentState?.reset();
                    setState(() {
                      imageFiles.clear();
                      attachmentFiles.clear();
                      selectedGovernmentId = null;
                      autovalidateMode = AutovalidateMode.disabled;
                    });
                  } else if (state is CreateComplaintFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'فشل إرسال الشكوى: ${state.errorMessage}',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is CreateComplaintLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return CustomElevatedButton(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    title: "إرسال الشكوى",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (selectedGovernmentId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('يرجى اختيار المحافظة'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        formKey.currentState!.save();

                        if (context.mounted) {
                          await context
                              .read<CreateComplaintCubit>()
                              .createComplaint(
                                context: context,
                                type: type!,
                                description: des!,
                                governmentId: selectedGovernmentId!,
                                imageFiles: imageFiles,
                                attachmentFiles: attachmentFiles,
                                location: location!,
                              );
                        }
                      } else {
                        setState(() {
                          autovalidateMode = AutovalidateMode.always;
                        });
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Icon(
          title.contains('صور') ? Icons.image : Icons.attach_file,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedFilesChips(List<XFile> files, {required bool isImage}) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: files.map((file) {
        final fileName = file.name;
        return Chip(
          avatar: Icon(isImage ? Icons.image : Icons.description, size: 18),
          label: Text(
            fileName.length > 20 ? '${fileName.substring(0, 20)}...' : fileName,
            style: TextStyle(fontSize: 12),
          ),
          deleteIcon: Icon(Icons.close, size: 18),
          onDeleted: () {
            setState(() {
              if (isImage) {
                imageFiles.remove(file);
              } else {
                attachmentFiles.remove(file);
              }
            });
          },
        );
      }).toList(),
    );
  }
}
