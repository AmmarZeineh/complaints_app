import 'package:complaints_app/core/utils/app_font_styles.dart';
import 'package:complaints_app/feature/complaint_view/domain/entities/complaint_entity.dart';
import 'package:complaints_app/feature/complaint_view/presentation/views/complaint_details_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ComplaintCard extends StatelessWidget {
  const ComplaintCard({super.key, required this.complaintEntity});
  final ComplaintEntity complaintEntity;

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'NEW':
        return Colors.orange;
      case 'INPROCESS':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
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
    final hasDocuments = complaintEntity.documents.isNotEmpty;
    final hasImages = complaintEntity.images.isNotEmpty;
    final hasInteractions = complaintEntity.interactions.isNotEmpty;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        ComplaintDetailsView.routeName,
        arguments: complaintEntity,
      ),
      child: Card(
        color: Colors.white,
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
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),

              SizedBox(height: 12),

              // الوصف
              if (complaintEntity.description.isNotEmpty) ...[
                Text(
                  complaintEntity.description,
                  style: AppTextStyles.w600_14.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
              ],

              // حالة الشكوى + المستندات المطلوبة
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        complaintEntity.status,
                      ).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      complaintEntity.status,
                      style: AppTextStyles.w600_14.copyWith(
                        color: _getStatusColor(complaintEntity.status),
                      ),
                    ),
                  ),
                  Spacer(),
                  // عرض تحذير المستندات فقط إذا لم يكن هناك مستندات
                  if (complaintEntity.interactions.isNotEmpty &&
                      complaintEntity.interactions.last.type == 'REQUEST_INFO')
                    Row(
                      children: [
                        Text(
                          'مطلوب مستندات',
                          style: AppTextStyles.w600_14.copyWith(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.warning,
                          size: 20,
                          color: Colors.yellowAccent.shade700,
                        ),
                      ],
                    ),
                ],
              ),

              SizedBox(height: 12),

              // المرفقات (الصور والمستندات)
              if (hasImages || hasDocuments) ...[
                Row(
                  children: [
                    if (hasImages)
                      Row(
                        children: [
                          Icon(Icons.image, size: 18, color: Colors.blue),
                          SizedBox(width: 4),
                          Text(
                            '${complaintEntity.images.length} صور',
                            style: AppTextStyles.w600_14.copyWith(
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(width: 12),
                        ],
                      ),
                    if (hasDocuments)
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            size: 18,
                            color: Colors.green,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${complaintEntity.documents.length} مستندات',
                            style: AppTextStyles.w600_14.copyWith(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 12),
              ],

              Divider(height: 1, thickness: 1, color: Colors.grey.shade300),

              SizedBox(height: 12),

              // الموقع
              Row(
                children: [
                  Icon(Icons.location_on, size: 20, color: Colors.red.shade400),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      complaintEntity.location,
                      style: AppTextStyles.w600_14.copyWith(
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

              // الجهة الحكومية
              Row(
                children: [
                  Icon(Icons.business, size: 20, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      complaintEntity.government.name,
                      style: AppTextStyles.w600_14.copyWith(
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

              // التاريخ + التفاعلات
              Row(
                children: [
                  Icon(Icons.calendar_month, size: 20, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    _formatDate(complaintEntity.createdAt),
                    style: AppTextStyles.w600_14.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Spacer(),
                  if (hasInteractions)
                    Row(
                      children: [
                        Icon(Icons.comment, size: 18, color: Colors.blue),
                        SizedBox(width: 4),
                        Text(
                          '${complaintEntity.interactions.length}',
                          style: AppTextStyles.w600_14.copyWith(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              // عرض آخر تحديث إذا كان موجود
              if (complaintEntity.updatedAt != null) ...[
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.update, size: 18, color: Colors.grey.shade500),
                    SizedBox(width: 8),
                    Text(
                      'آخر تحديث: ${_formatDate(complaintEntity.updatedAt!)}',
                      style: AppTextStyles.w600_14.copyWith(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
