import 'dart:convert';

class RoleScheduleItem {
  final String id;
  final String sceneName;
  final String characterName;
  final String actorName;
  final String rehearsalTime;
  final String location;
  final String status; // "جاهز للمسرح", "قيد البروزة", "تم الحفظ"
  final String notes;

  RoleScheduleItem({
    required this.id,
    required this.sceneName,
    required this.characterName,
    required this.actorName,
    required this.rehearsalTime,
    required this.location,
    required this.status,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sceneName': sceneName,
      'characterName': characterName,
      'actorName': actorName,
      'rehearsalTime': rehearsalTime,
      'location': location,
      'status': status,
      'notes': notes,
    };
  }

  factory RoleScheduleItem.fromMap(Map<String, dynamic> map) {
    return RoleScheduleItem(
      id: map['id'] ?? '',
      sceneName: map['sceneName'] ?? '',
      characterName: map['characterName'] ?? '',
      actorName: map['actorName'] ?? '',
      rehearsalTime: map['rehearsalTime'] ?? '',
      location: map['location'] ?? 'مسرح الكنيسة',
      status: map['status'] ?? 'قيد البروزة',
      notes: map['notes'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RoleScheduleItem.fromJson(String source) => RoleScheduleItem.fromMap(json.decode(source));
}
