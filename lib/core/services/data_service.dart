import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// موديل مخصص لعناصر الموسيقى والفيديوهات
class MediaItem {
  final String id;
  final String title;
  final String path;
  final String type; // 'audio' (MP3) أو 'video' (MP4)

  MediaItem({
    required this.id,
    required this.title,
    required this.path,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'path': path,
        'type': type,
      };

  factory MediaItem.fromJson(Map<String, dynamic> json) => MediaItem(
        id: json['id'],
        title: json['title'],
        path: json['path'],
        type: json['type'],
      );
}

class DataService extends ChangeNotifier {
  String? _mainScriptPdfPath;
  String? _schedulePdfPath;
  List<MediaItem> _mediaList = [];

  // Getters
  String? get mainScriptPdfPath => _mainScriptPdfPath;
  String? get schedulePdfPath => _schedulePdfPath;
  List<MediaItem> get mediaList => _mediaList;

  DataService() {
    _loadData();
  }

  // تحميل البيانات المحفوظة محلياً عند فتح التطبيق
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _mainScriptPdfPath = prefs.getString('main_script_pdf_path');
    _schedulePdfPath = prefs.getString('schedule_pdf_path');

    final String? mediaJson = prefs.getString('media_list');
    if (mediaJson != null) {
      final List<dynamic> decoded = jsonDecode(mediaJson);
      _mediaList = decoded.map((item) => MediaItem.fromJson(item)).toList();
    }
    notifyListeners();
  }

  // 1. حفظ وتحديث PDF السكريبت
  Future<void> setMainScriptPdf(String path) async {
    _mainScriptPdfPath = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('main_script_pdf_path', path);
    notifyListeners();
  }

  // 2. حفظ وتحديث PDF التقسيمة
  Future<void> setSchedulePdf(String path) async {
    _schedulePdfPath = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('schedule_pdf_path', path);
    notifyListeners();
  }

  // 3. إضافة ملف موسيقى أو فيديو جديد
  Future<void> addMediaItem(MediaItem item) async {
    _mediaList.add(item);
    await _saveMediaList();
    notifyListeners();
  }

  // حذف ملف ميديا
  Future<void> removeMediaItem(String id) async {
    _mediaList.removeWhere((item) => item.id == id);
    await _saveMediaList();
    notifyListeners();
  }

  // حفظ قائمة الميديا
  Future<void> _saveMediaList() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_mediaList.map((item) => item.toJson()).toList());
    await prefs.setString('media_list', encoded);
  }
}
