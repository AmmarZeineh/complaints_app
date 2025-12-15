import 'package:complaints_app/feature/complaint_view/domain/entities/complaint_entity.dart';
import 'package:complaints_app/feature/complaint_view/presentation/views/widgets/complaint_card.dart';
import 'package:flutter/material.dart';

class ComplaintsCardListView extends StatelessWidget {
  const ComplaintsCardListView({super.key, required this.complaints});
  final List<ComplaintEntity> complaints;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10),
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        return ComplaintCard(complaintEntity: complaints[index]);
      },
    );
  }
}
