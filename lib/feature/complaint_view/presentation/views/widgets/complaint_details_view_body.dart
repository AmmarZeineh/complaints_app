import 'package:complaints_app/core/helper_functions/snack_bars.dart';
import 'package:complaints_app/core/utils/app_font_styles.dart';
import 'package:complaints_app/core/widgets/custom_elevated_button.dart';
import 'package:complaints_app/feature/complaint/presentation/views/widgets/file_picker_container.dart';
import 'package:complaints_app/feature/complaint/presentation/views/widgets/image_picker_container.dart';
import 'package:complaints_app/feature/complaint_view/domain/entities/complaint_entity.dart';
import 'package:complaints_app/feature/complaint_view/presentation/cubits/send_interaction_cubit/send_interaction_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ComplaintDetailsViewBody extends StatefulWidget {
  const ComplaintDetailsViewBody({super.key, required this.complaint});

  final ComplaintEntity complaint;

  @override
  State<ComplaintDetailsViewBody> createState() =>
      _ComplaintDetailsViewBodyState();
}

class _ComplaintDetailsViewBodyState extends State<ComplaintDetailsViewBody> {
  List<XFile> imageFiles = [];
  List<XFile> attachmentFiles = [];
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy - HH:mm').format(date);
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
    return Icons.report_problem;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.complaint.interactions.isNotEmpty &&
              widget.complaint.interactions.last.type == 'REQUEST_INFO')
            _buildInteraction(),

          // بطاقة معلومات الشكوى الأساسية
          _buildMainInfoCard(),

          SizedBox(height: 16),

          // الوصف التفصيلي
          _buildDescriptionCard(),

          SizedBox(height: 16),

          // الصور المرفقة
          if (widget.complaint.images.isNotEmpty) ...[
            _buildImagesSection(),
            SizedBox(height: 16),
          ],

          // المستندات المرفقة
          if (widget.complaint.documents.isNotEmpty) ...[
            _buildDocumentsSection(),
            SizedBox(height: 16),
          ],

          // التفاعلات والتعليقات
          if (widget.complaint.interactions.isNotEmpty) ...[
            _buildInteractionsSection(),
            SizedBox(height: 16),
          ],

          // معلومات إضافية
          _buildAdditionalInfoCard(),
        ],
      ),
    );
  }

  Widget _buildInteraction() {
    return Card(
      color: Colors.redAccent[100],
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.yellowAccent, size: 24),
                SizedBox(width: 8),
                Text(
                  'ملفات مطلوبة',
                  style: AppTextStyles.w600_18.copyWith(color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              widget.complaint.interactions.last.message,
              style: AppTextStyles.w600_14.copyWith(
                color: Colors.black,
                height: 1.5,
              ),
            ),
            SizedBox(height: 12),
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
            SizedBox(height: 5),

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
            SizedBox(height: 12),

            BlocConsumer<SendInteractionCubit, SendInteractionState>(
              listener: (context, state) {
                if (state is SendInteractionSuccess) {
                  Navigator.pop(context);
                  showSuccessMessage('تم إرسال التفاعل بنجاح', context);
                } else if (state is SendInteractionFailure) {
                  showErrorMessage(state.message, context);
                }
              },
              builder: (context, state) {
                return CustomElevatedButton(
                  title: state is SendInteractionLoading
                      ? 'جاري الإرسال...'
                      : 'إضافة',
                  onPressed: () {
                    context.read<SendInteractionCubit>().sendInteraction(
                      id: widget.complaint.id,
                      reciverId: widget
                          .complaint
                          .interactions
                          .last
                          .senderId, // أو الشخص المستلم
                      images: imageFiles, // List<XFile>
                      files: attachmentFiles, // List<XFile>
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
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

  // بطاقة المعلومات الرئيسية
  Widget _buildMainInfoCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getComplaintIcon(widget.complaint.type),
                    color: Colors.blueGrey,
                    size: 32,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.complaint.type,
                        style: AppTextStyles.w600_18.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'رقم الشكوى: #${widget.complaint.id}',
                        style: AppTextStyles.w600_14.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // حالة الشكوى
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _getStatusColor(
                  widget.complaint.status,
                ).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getStatusColor(
                    widget.complaint.status,
                  ).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: _getStatusColor(widget.complaint.status),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'الحالة: ${widget.complaint.status}',
                    style: AppTextStyles.w600_14.copyWith(
                      color: _getStatusColor(widget.complaint.status),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // بطاقة الوصف
  Widget _buildDescriptionCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: Colors.blueGrey, size: 24),
                SizedBox(width: 8),
                Text(
                  'وصف الشكوى',
                  style: AppTextStyles.w600_18.copyWith(color: Colors.black87),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              widget.complaint.description,
              style: AppTextStyles.w600_14.copyWith(
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // قسم الصور
  Widget _buildImagesSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.photo_library, color: Colors.blue, size: 24),
                SizedBox(width: 8),
                Text(
                  'الصور المرفقة (${widget.complaint.images.length})',
                  style: AppTextStyles.w600_18.copyWith(color: Colors.black87),
                ),
              ],
            ),
            SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: widget.complaint.images.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                    image: DecorationImage(
                      image: NetworkImage(widget.complaint.images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // قسم المستندات
  Widget _buildDocumentsSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.attach_file, color: Colors.green, size: 24),
                SizedBox(width: 8),
                Text(
                  'المستندات المرفقة (${widget.complaint.documents.length})',
                  style: AppTextStyles.w600_18.copyWith(color: Colors.black87),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...widget.complaint.documents.map((doc) {
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.description, color: Colors.green, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        doc.toString(),
                        style: AppTextStyles.w600_14.copyWith(
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // قسم التفاعلات
  Widget _buildInteractionsSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.comment, color: Colors.blue, size: 24),
                SizedBox(width: 8),
                Text(
                  'التفاعلات (${widget.complaint.interactions.length})',
                  style: AppTextStyles.w600_18.copyWith(color: Colors.black87),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...widget.complaint.interactions.map((interaction) {
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            interaction.message,
                            style: AppTextStyles.w600_14.copyWith(
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // بطاقة المعلومات الإضافية
  Widget _buildAdditionalInfoCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات إضافية',
              style: AppTextStyles.w600_18.copyWith(color: Colors.black87),
            ),
            SizedBox(height: 16),

            // الموقع
            _buildInfoRow(
              icon: Icons.location_on,
              iconColor: Colors.red.shade400,
              title: 'الموقع',
              value: widget.complaint.location,
            ),

            SizedBox(height: 12),

            // الجهة الحكومية
            _buildInfoRow(
              icon: Icons.business,
              iconColor: Colors.purple,
              title: 'الجهة الحكومية',
              value: widget.complaint.government.name,
            ),

            SizedBox(height: 12),

            // تاريخ الإنشاء
            _buildInfoRow(
              icon: Icons.calendar_today,
              iconColor: Colors.blue,
              title: 'تاريخ الإنشاء',
              value: _formatDate(widget.complaint.createdAt),
            ),

            if (widget.complaint.updatedAt != null) ...[
              SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.update,
                iconColor: Colors.orange,
                title: 'آخر تحديث',
                value: _formatDate(widget.complaint.updatedAt!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.w600_14.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.w600_14.copyWith(
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
