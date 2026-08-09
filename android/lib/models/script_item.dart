import 'dart:convert';

class ScriptItem {
  final String id;
  final String title;
  final String sceneName;
  final String description;
  final String contentText;
  final String fileUrl; // URL or path for PDF/Script file
  final int pageCount;
  final String addedDate;
  final String author;

  ScriptItem({
    required this.id,
    required this.title,
    required this.sceneName,
    required this.description,
    required this.contentText,
    required this.fileUrl,
    required this.pageCount,
    required this.addedDate,
    required this.author,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'sceneName': sceneName,
      'description': description,
      'contentText': contentText,
      'fileUrl': fileUrl,
      'pageCount': pageCount,
      'addedDate': addedDate,
      'author': author,
    };
  }

  factory ScriptItem.fromMap(Map<String, dynamic> map) {
    return ScriptItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      sceneName: map['sceneName'] ?? '',
      description: map['description'] ?? '',
      contentText: map['contentText'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      pageCount: map['pageCount']?.toInt() ?? 1,
      addedDate: map['addedDate'] ?? '',
      author: map['author'] ?? 'المشرف',
    );
  }

  String toJson() => json.encode(toMap());

  factory ScriptItem.fromJson(String source) => ScriptItem.fromMap(json.decode(source));
}
