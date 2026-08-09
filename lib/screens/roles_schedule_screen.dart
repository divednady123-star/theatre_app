import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../core/constants/app_constants.dart';
import '../core/services/auth_service.dart';
import '../core/services/data_service.dart';
import '../models/role_schedule_item.dart';

class RolesScheduleScreen extends StatefulWidget {
  const RolesScheduleScreen({Key? key}) : super(key: key);

  @override
  State<RolesScheduleScreen> createState() => _RolesScheduleScreenState();
}

class _RolesScheduleScreenState extends State<RolesScheduleScreen> {
  String _selectedFilter = 'الكل';

  Color _getStatusColor(String status) {
    switch (status) {
      case 'جاهز للمسرح':
        return Colors.green.shade700;
      case 'قيد البروزة':
        return Colors.orange.shade800;
      case 'تم الحفظ':
        return AppConstants.royalBluePrimary;
      default:
        return AppConstants.textMuted;
    }
  }

  void _openPdfViewer(BuildContext context, String filePath, String title) {
    if (filePath.isEmpty || !File(filePath).existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('عفواً، لا يوجد ملف PDF مرفق أو الملف غير متوفر محلياً.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppConstants.bgPureWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.royalBlueDark),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SfPdfViewer.file(File(filePath)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddOrEditRoleDialog(BuildContext context, {RoleScheduleItem? itemToEdit}) {
    final sceneController = TextEditingController(text: itemToEdit?.sceneName ?? '');
    final charController = TextEditingController(text: itemToEdit?.characterName ?? '');
    final actorController = TextEditingController(text: itemToEdit?.actorName ?? '');
    final timeController = TextEditingController(text: itemToEdit?.rehearsalTime ?? '');
    final locationController = TextEditingController(text: itemToEdit?.location ?? 'قاعة المسرح الكبير');
    final notesController = TextEditingController(text: itemToEdit?.notes ?? '');
    String status = itemToEdit?.status ?? 'قيد البروزة';
    PlatformFile? pickedPdfFile;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.recent_actors, color: AppConstants.softGoldPrimary),
                  const SizedBox(width: 8),
                  Text(itemToEdit == null ? 'إضافة دور / موعد جديد' : 'تعديل بيانات الدور'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: sceneController,
                      decoration: const InputDecoration(labelText: 'اسم المشهد'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: charController,
                      decoration: const InputDecoration(labelText: 'اسم الشخصية المسرحية'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: actorController,
                      decoration: const InputDecoration(labelText: 'اسم الممثل / العضو'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: timeController,
                      decoration: const InputDecoration(labelText: 'موعد البروفة (مثال: الجمعة 6 مساءً)'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(labelText: 'المكان'),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: const InputDecoration(labelText: 'حالة الجاهزية'),
                      items: const [
                        DropdownMenuItem(value: 'قيد البروزة', child: Text('قيد البروزة')),
                        DropdownMenuItem(value: 'تم الحفظ', child: Text('تم الحفظ')),
                        DropdownMenuItem(value: 'جاهز للمسرح', child: Text('جاهز للمسرح')),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => status = val);
                      },
                    ),
                    const SizedBox(height: 10),
                    
                    // زرار مرفق PDF للتقسيمة
                    OutlinedButton.icon(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null && result.files.isNotEmpty) {
                          setDialogState(() {
                            pickedPdfFile = result.files.first;
                          });
                        }
                      },
                      icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                      label: Text(
                        pickedPdfFile == null
                            ? 'إرفاق ملف PDF للتقسيمة (اختياري)'
                            : 'تم اختيار: ${pickedPdfFile!.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 42),
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(labelText: 'ملاحظات وتوجيهات الإخراج'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (sceneController.text.trim().isEmpty || charController.text.trim().isEmpty) return;

                    final dataService = Provider.of<DataService>(context, listen: false);

                    final roleItem = RoleScheduleItem(
                      id: itemToEdit?.id ?? const Uuid().v4(),
                      sceneName: sceneController.text.trim(),
                      characterName: charController.text.trim(),
                      actorName: actorController.text.trim().isEmpty ? 'لم يحدد' : actorController.text.trim(),
                      rehearsalTime: timeController.text.trim().isEmpty ? 'قريباً' : timeController.text.trim(),
                      location: locationController.text.trim(),
                      status: status,
                      notes: notesController.text.trim(),
                    );

                    if (itemToEdit == null) {
                      await dataService.addRole(roleItem);
                    } else {
                      await dataService.updateRole(roleItem);
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(itemToEdit == null ? 'تمت إضافة الدور بنجاح!' : 'تم تحديث بيانات الدور!')),
                      );
                    }
                  },
                  child: Text(itemToEdit == null ? 'إضافة' : 'تحديث'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<AuthService>(context).isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('جدول التقسيمة والأدوار'),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _showAddOrEditRoleDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('إضافة دور جديد'),
            )
          : null,
      body: Consumer<DataService>(
        builder: (context, dataService, child) {
          var roles = dataService.roles;

          if (_selectedFilter != 'الكل') {
            roles = roles.where((r) => r.status == _selectedFilter).toList();
          }

          return Column(
            children: [
              // Filter Chips Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: AppConstants.bgOffWhite,
                child: Row(
                  children: [
                    const Text('تصفية: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['الكل', 'قيد البروزة', 'تم الحفظ', 'جاهز للمسرح'].map((filter) {
                            final isSelected = _selectedFilter == filter;
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: ChoiceChip(
                                label: Text(filter),
                                selected: isSelected,
                                selectedColor: AppConstants.softGoldPrimary,
                                labelStyle: TextStyle(
                                  color: isSelected ? AppConstants.royalBlueDark : AppConstants.textDark,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                                onSelected: (val) {
                                  if (val) setState(() => _selectedFilter = filter);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: roles.isEmpty
                    ? const Center(child: Text('لا توجد أدوار متوافقة مع التصفية', style: TextStyle(color: AppConstants.textMuted)))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: roles.length,
                        itemBuilder: (context, index) {
                          final role = roles[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 14),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            const Icon(Icons.theater_comedy, color: AppConstants.royalBluePrimary),
                                            const SizedBox(width: 8),
                                            Text(
                                              role.characterName,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppConstants.royalBlueDark,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(role.status).withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: _getStatusColor(role.status)),
                                        ),
                                        child: Text(
                                          role.status,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: _getStatusColor(role.status),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 18),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('المشهد: ${role.sceneName}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                            const SizedBox(height: 4),
                                            Text('الممثل: ${role.actorName}', style: const TextStyle(color: AppConstants.royalBluePrimary, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('البروفة: ${role.rehearsalTime}', style: const TextStyle(fontSize: 13)),
                                            const SizedBox(height: 4),
                                            Text('المكان: ${role.location}', style: const TextStyle(fontSize: 12, color: AppConstants.textMuted)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (role.notes.isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppConstants.bgOffWhite,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'توجيهات: ${role.notes}',
                                        style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ],
                                  if (isAdmin) ...[
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () => _showAddOrEditRoleDialog(context, itemToEdit: role),
                                          icon: const Icon(Icons.edit, size: 16),
                                          label: const Text('تعديل'),
                                        ),
                                        TextButton.icon(
                                          onPressed: () async {
                                            await dataService.deleteRole(role.id);
                                          },
                                          icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                                          label: const Text('حذف', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
