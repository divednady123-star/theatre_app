import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../core/constants/app_constants.dart';
import '../core/services/auth_service.dart';
import '../core/services/data_service.dart';

class RolesScheduleScreen extends StatefulWidget {
  const RolesScheduleScreen({Key? key}) : super(key: key);

  @override
  State<RolesScheduleScreen> createState() => _RolesScheduleScreenState();
}

class _RolesScheduleScreenState extends State<RolesScheduleScreen> {
  void _pickAndSaveSchedulePdf(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      final path = result.files.first.path;
      if (path != null) {
        final dataService = Provider.of<DataService>(context, listen: false);
        await dataService.setSchedulePdf(path);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تمت إضافة وتحديث ملف PDF التقسيمة بنجاح!')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<AuthService>(context).isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('جدول التقسيمة'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.upload_file),
              tooltip: 'تحديث ملف PDF التقسيمة',
              onPressed: () => _pickAndSaveSchedulePdf(context),
            ),
        ],
      ),
      body: Consumer<DataService>(
        builder: (context, dataService, child) {
          final schedulePath = dataService.schedulePdfPath;

          if (schedulePath == null || schedulePath.isEmpty || !File(schedulePath).existsSync()) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.table_chart_outlined, size: 80, color: AppConstants.textMuted),
                    const SizedBox(height: 16),
                    const Text(
                      'لم يتم إرفاق ملف PDF للتقسيمة حتى الآن',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.royalBlueDark),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'يقوم المشرف برفع ملف تقسيم الأدوار والمهام بصيغة PDF من الأعلى.',
                      style: TextStyle(color: AppConstants.textMuted),
                      textAlign: TextAlign.center,
                    ),
                    if (isAdmin) ...[
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => _pickAndSaveSchedulePdf(context),
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('إرفاق ملف PDF للتقسيمة'),
                      ),
                    ]
                  ],
                ),
              ),
            );
          }

          return SfPdfViewer.file(
            File(schedulePath),
            canShowScrollHead: true,
            canShowScrollStatus: true,
          );
        },
      ),
    );
  }
}
