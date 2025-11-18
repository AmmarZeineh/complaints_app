import 'package:complaints_app/core/widgets/custom_elevated_button.dart';
import 'package:complaints_app/core/widgets/custom_text_form_field.dart';
import 'package:complaints_app/feature/complaint/domain/entities/government_entity.dart';
import 'package:complaints_app/feature/complaint/presentation/cubits/create_complaint_cubit/create_complaint_cubit.dart';
import 'package:complaints_app/feature/complaint/presentation/cubits/get_government_cubit/get_government_cubit.dart';
import 'package:complaints_app/feature/complaint/presentation/views/widgets/drop_down.dart';
import 'package:complaints_app/feature/complaint/presentation/views/widgets/image_picker_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  String? type, des;
  String imagePath = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomFormTextField(
                title: "نوع الشكوى",
                textInputType: TextInputType.text,
                onSaved: (value) => type = value,
              ),
              SizedBox(height: 20),

              CustomFormTextField(
                title: "الوصف",
                textInputType: TextInputType.text,
                onSaved: (value) => des = value,
              ),
              // SizedBox(height: 20),
              // CustomFormTextField(
              //   title: "الموقع",
              //   textInputType: TextInputType.text,
              // ),
              SizedBox(height: 20),
              GovernmentDropdown(
                onSelect: (id) {
                  setState(() {
                    selectedGovernmentId = id;
                  });
                },
              ),
              SizedBox(height: 20),

              ImagePickerContainer(
                onChanged: (value) {
                  setState(() {
                    imagePath = value!;
                  });
                },
              ),
              SizedBox(height: 30),

              CustomElevatedButton(
                title: "ارسال",
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    if (context.mounted) {
                      await context
                          .read<CreateComplaintCubit>()
                          .createComplaint(
                            type: type!,
                            description: des!,

                            governmentId: selectedGovernmentId!,
                            imagePath: imagePath,
                          );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
