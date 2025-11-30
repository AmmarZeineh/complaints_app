import 'package:complaints_app/core/utils/app_font_styles.dart';
import 'package:complaints_app/feature/complaint_view/domain/entities/complaint_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ComplaintCard extends StatelessWidget {
  const ComplaintCard({super.key, required this.complaintEntity});
  final ComplaintEntity complaintEntity;

  String _formatDate(String dateStr) {
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr; // إذا التاريخ مو بصيغة صحيحة
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'مفتوحة':
        return Colors.orange;
      case 'قيد المراجعة':
        return Colors.blue;
      case 'مغلقة':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getComplaintIcon(String type) {
    if (type.contains("خدمة")) return Icons.miscellaneous_services;
    if (type.contains("نظافة")) return Icons.cleaning_services;
    if (type.contains("مشكلة")) return Icons.warning_amber;
    return Icons.report_problem;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان + الأيقونة
            Row(
              children: [
                Icon(
                  _getComplaintIcon(complaintEntity.type),
                  color: Colors.blueGrey,
                  size: 28,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    complaintEntity.type,
                    style: AppTextStyles.w600_18.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // حالة الشكوى
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      complaintEntity.state,
                    ).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    complaintEntity.state,
                    style: AppTextStyles.w600_14.copyWith(
                      color: _getStatusColor(complaintEntity.state),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            Divider(height: 1, thickness: 1, color: Colors.grey.shade300),

            SizedBox(height: 12),

            // التاريخ
            Row(
              children: [
                Icon(Icons.calendar_month, size: 20, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  _formatDate(complaintEntity.date),
                  style: AppTextStyles.w600_14.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
