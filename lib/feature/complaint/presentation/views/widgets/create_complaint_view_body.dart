import 'package:complaints_app/core/widgets/custom_elevated_button.dart';
import 'package:complaints_app/core/widgets/custom_text_form_field.dart';
import 'package:complaints_app/feature/complaint/presentation/cubits/create_complaint_cubit/create_complaint_cubit.dart';
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
  String? type, des, location;
  String imagePath = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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

              SizedBox(height: 20),
              CustomFormTextField(
                title: "الموقع",
                textInputType: TextInputType.text,
                onSaved: (value) => location = value,
              ),
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

              BlocBuilder<CreateComplaintCubit, CreateComplaintState>(
                builder: (context, state) {
                  if (state is CreateComplaintLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return CustomElevatedButton(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 50,
                      vertical: 8,
                    ),
                    title: "ارسال",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        if (context.mounted) {
                          await context
                              .read<CreateComplaintCubit>()
                              .createComplaint(
                                context: context,
                                type: type!,
                                description: des!,
                                governmentId: selectedGovernmentId!,
                                imagePath: imagePath,
                                location: location!,
                              );
                        }
                        autovalidateMode = .always;
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
