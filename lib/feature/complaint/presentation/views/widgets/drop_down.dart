
import 'package:complaints_app/feature/complaint/domain/entities/government_entity.dart';
import 'package:complaints_app/feature/complaint/presentation/cubits/get_government_cubit/get_government_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GovernmentDropdown extends StatefulWidget {
  final Function(int id) onSelect;

  const GovernmentDropdown({super.key, required this.onSelect});

  @override
  GovernmentDropdownState createState() => GovernmentDropdownState();
}

class GovernmentDropdownState extends State<GovernmentDropdown> {
  GovernmentEntity? selected;

  @override
  void initState() {
    super.initState();
    context.read<GetGovernmentCubit>().getGovernment();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetGovernmentCubit, GetGovernmentState>(
      builder: (context, state) {
        if (state is GetGovernmentLoading) {
          return const CircularProgressIndicator();
        }

        if (state is GetGovernmentFailure) {
          return Text("Error: ${state.errorMessage}");
        }

        if (state is GetGovernmentSuccess) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: DropdownButton<GovernmentEntity>(
              isExpanded: true,

              /// 👈 مهم جداً لتكبير القائمة
              value: selected,
              underline: const SizedBox(),
              hint: const Text("اختر الجهة الحكومية"),

              items: state.governments.map((gov) {
                return DropdownMenuItem(value: gov, child: Text(gov.name));
              }).toList(),

              onChanged: (value) {
                setState(() => selected = value);
                widget.onSelect(value!.id);

                /// 👈 هنا نرسل ID للأب
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
