import 'package:complaints_app/core/utils/app_colors.dart';
import 'package:complaints_app/feature/complaint/presentation/views/create_complaint_view.dart';
import 'package:complaints_app/feature/complaint_view/presentation/cubits/get_complaint_cubit/get_complaints_cubit.dart';
import 'package:complaints_app/feature/complaint_view/presentation/views/widgets/complaints_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplaintsViewBody extends StatelessWidget {
  const ComplaintsViewBody({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    context.read<GetComplaintsCubit>().getComplaints(
      skip: 0,
      limit: 20,
    );
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocBuilder<GetComplaintsCubit, GetComplaintsState>(
                builder: (context, state) {
                  if (state is GetComplaintsSuccess) {
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => _onRefresh(context),
                        child: ComplaintsCardListView(
                          complaints: state.complaints,
                        ),
                      ),
                    );
                  } else if (state is GetComplaintsError) {
                    return Center(
                      child: Text(
                        state.errMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),

        // زر الإضافة (أسفل يمين)
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, CreateComplaintView.routeName);
            },
            backgroundColor: AppColors.primaryColor,
            elevation: 4,
            child: const Icon(Icons.add, size: 30, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
