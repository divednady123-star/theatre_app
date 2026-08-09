import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../core/constants/app_constants.dart';
import '../core/services/auth_service.dart';
import '../core/services/data_service.dart';
import '../models/script_item.dart';

class ScriptsScreen extends StatelessWidget {
  const ScriptsScreen({Key? key}) : super(key: key);

  void _openScriptReader(BuildContext context, ScriptItem script) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppConstants.bgPureWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            final isLocalFile = script.fileUrl.isNotEmpty && File(script.fileUrl).existsSync();

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppConstants.softGoldPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.description, color: AppConstants.royalBlueDark, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              script.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.royalBlueDark,
                              ),
                            ),
                            Text(
                              'القسم: ${script.sceneName} • ${script.pageCount} صفحة',
                              style: const TextStyle(fontSize: 12, color: AppConstants.textMuted),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: isLocalFile
                          ? SfPdfViewer.file(File(script.fileUrl))
                          : (script.contentText.isNotEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppConstants.bgOffWhite,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppConstants.softGoldPrimary.withOpacity(0.3)),
                                  ),
                                  child: ListView(
                                    controller: scrollController,
                                    children: [
                                      SelectableText(
                                        script.contentText,
                                        style: const TextStyle(fontSize: 16, height: 1.8, color: AppConstants.textDark),
                                      ),
                                    ],
                                  ),
                                )
                              : const Center(
                                  child: Text('عفواً، ملف الـ PDF غير متوفر محللياً على هذا الجهاز.'),
                                )),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddScriptDialog(BuildContext context) {
    final titleController = TextEditingController();
    final sceneController = TextEditingController();
    final descController = TextEditingController();
    final contentController = TextEditingController();
    final pageController = TextEditingController(text: '10');
    
    PlatformFile? pickedPdfFile;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: const [
                  Icon(Icons.note_add, color: AppConstants.softGoldPrimary),
                  SizedBox(width: 8),
                  Text('إضافة إسكريبت جديد (لالمشرف)'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'عنوان الإسكريبت / النص'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: sceneController,
                      decoration: const InputDecoration(labelText: 'اسم المشهد (مثال: المشهد الثالث)'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(labelText: 'وصف مختصر'),
                    ),
                    const SizedBox(height: 12),
                    
                    // زر اختيار ملف PDF
                    OutlinedButton.icon(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null && result.files.isNotEmpty) {
                          setState(() {
                            pickedPdfFile = result.files.first;
                          });
                        }
                      },
                      icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                      label: Text(
                        pickedPdfFile == null
                            ? 'اختيار ملف PDF من الموبايل'
                            : 'تم اختيار: ${pickedPdfFile!.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: contentController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'ملاحظات أو ملخص النص (اختياري)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: pageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'عدد الصفحات (تقديري)'),
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
                    if (titleController.text.trim().isEmpty) return;

                    final filePath = pickedPdfFile?.path ?? '';

                    final newScript = ScriptItem(
                      id: const Uuid().v4(),
                      title: titleController.text.trim(),
                      sceneName: sceneController.text.trim().isEmpty ? 'عام' : sceneController.text.trim(),
                      description: descController.text.trim(),
                      contentText: contentController.text.trim(),
                      fileUrl: filePath,
                      pageCount: int.tryParse(pageController.text) ?? 10,
                      addedDate: DateTime.now().toString().split(' ')[0],
                      author: 'المشرف',
                    );

                    await Provider.of<DataService>(context, listen: false).addScript(newScript);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تمت إضافة الإسكريبت بملف الـ PDF بنجاح!')),
                      );
                    }
                  },
                  child: const Text('حفظ وإضافة'),
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
        title: const Text('قسم الاسكربيتات والـ PDF'),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _showAddScriptDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('إضافة إسكريبت'),
            )
          : null,
      body: Consumer<DataService>(
        builder: (context, dataService, child) {
          final scripts = dataService.scripts;

          if (scripts.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد اسكربيتات مضافة حالياً.',
                style: TextStyle(fontSize: 16, color: AppConstants.textMuted),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: scripts.length,
            itemBuilder: (context, index) {
              final script = scripts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppConstants.royalBluePrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  script.title,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppConstants.royalBlueDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppConstants.softGoldPrimary.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    script.sceneName,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstants.royalBlueDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isAdmin)
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('حذف الإسكريبت'),
                                    content: Text('هل أنت تأكد من حذف "${script.title}"؟'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
                                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف', style: TextStyle(color: Colors.red))),
                                    ],
                                  ),
                                );
                                if (confirm == true && context.mounted) {
                                  await dataService.deleteScript(script.id);
                                }
                              },
                            ),
                        ],
                      ),
                      if (script.description.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          script.description,
                          style: const TextStyle(fontSize: 14, color: AppConstants.textMuted),
                        ),
                      ],
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.menu_book, size: 16, color: AppConstants.textMuted),
                              const SizedBox(width: 4),
                              Text('${script.pageCount} صفحة', style: const TextStyle(fontSize: 12, color: AppConstants.textMuted)),
                              const SizedBox(width: 12),
                              const Icon(Icons.calendar_today, size: 16, color: AppConstants.textMuted),
                              const SizedBox(width: 4),
                              Text(script.addedDate, style: const TextStyle(fontSize: 12, color: AppConstants.textMuted)),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _openScriptReader(context, script),
                            icon: const Icon(Icons.visibility, size: 18),
                            label: const Text('قراءة الإسكريبت'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
