import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/script_item.dart';
import '../../models/role_schedule_item.dart';
import '../../models/music_track.dart';

class DataService extends ChangeNotifier {
  List<ScriptItem> _scripts = [];
  List<RoleScheduleItem> _roles = [];
  List<MusicTrack> _tracks = [];

  List<ScriptItem> get scripts => List.unmodifiable(_scripts);
  List<RoleScheduleItem> get roles => List.unmodifiable(_roles);
  List<MusicTrack> get tracks => List.unmodifiable(_tracks);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    final scriptsJson = prefs.getString('scripts_data');
    if (scriptsJson != null) {
      final List decoded = json.decode(scriptsJson);
      _scripts = decoded.map((e) => ScriptItem.fromMap(e)).toList();
    } else {
      _scripts = _getDefaultScripts();
      await saveScripts();
    }

    final rolesJson = prefs.getString('roles_data');
    if (rolesJson != null) {
      final List decoded = json.decode(rolesJson);
      _roles = decoded.map((e) => RoleScheduleItem.fromMap(e)).toList();
    } else {
      _roles = _getDefaultRoles();
      await saveRoles();
    }

    final tracksJson = prefs.getString('tracks_data');
    if (tracksJson != null) {
      final List decoded = json.decode(tracksJson);
      _tracks = decoded.map((e) => MusicTrack.fromMap(e)).toList();
    } else {
      _tracks = _getDefaultTracks();
      await saveTracks();
    }

    notifyListeners();
  }

  // Script Actions
  Future<void> addScript(ScriptItem script) async {
    _scripts.insert(0, script);
    await saveScripts();
    notifyListeners();
  }

  Future<void> deleteScript(String id) async {
    _scripts.removeWhere((item) => item.id == id);
    await saveScripts();
    notifyListeners();
  }

  Future<void> saveScripts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(_scripts.map((e) => e.toMap()).toList());
    await prefs.setString('scripts_data', data);
    _syncToFirebaseCloud('scripts', data);
  }

  // Role Schedule Actions
  Future<void> addRole(RoleScheduleItem role) async {
    _roles.add(role);
    await saveRoles();
    notifyListeners();
  }

  Future<void> updateRole(RoleScheduleItem role) async {
    final index = _roles.indexWhere((r) => r.id == role.id);
    if (index != -1) {
      _roles[index] = role;
      await saveRoles();
      notifyListeners();
    }
  }

  Future<void> deleteRole(String id) async {
    _roles.removeWhere((item) => item.id == id);
    await saveRoles();
    notifyListeners();
  }

  Future<void> saveRoles() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(_roles.map((e) => e.toMap()).toList());
    await prefs.setString('roles_data', data);
    _syncToFirebaseCloud('roles', data);
  }

  // Music Track Actions
  Future<void> addTrack(MusicTrack track) async {
    _tracks.insert(0, track);
    await saveTracks();
    notifyListeners();
  }

  Future<void> deleteTrack(String id) async {
    _tracks.removeWhere((item) => item.id == id);
    await saveTracks();
    notifyListeners();
  }

  Future<void> saveTracks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(_tracks.map((e) => e.toMap()).toList());
    await prefs.setString('tracks_data', data);
    _syncToFirebaseCloud('music_tracks', data);
  }

  // Firebase Cloud Storage / Cloud Firestore Integration Stub
  // This infrastructure allows instant cloud syncing once Firebase credentials are attached
  void _syncToFirebaseCloud(String collectionName, String payloadJson) {
    if (kDebugMode) {
      print('[FirebaseSyncService] Ready to sync $collectionName -> Firebase Cloud Firestore');
    }
  }

  // Initial Mock Data for Live Theatre 2026
  List<ScriptItem> _getDefaultScripts() {
    return [
      ScriptItem(
        id: 'sc-101',
        title: 'إسكريبت المشهد الأول: البداية والنور',
        sceneName: 'المشهد الأول',
        description: 'حوار بين الشخصية الرئيسية والراوي في افتتاحية عرض مسرح حي 2026',
        contentText: '''
[المشهد الأول: إضاءة خافتة على يمين المسرح، موسيقى هادئة]

الراوي: "في كل زمن ومكان، هناك كلمة نادرة تشعل الأمل وتغير مجرى الأحداث..."
الشخصية الرئيسية (يدخل من وسط المسرح): "هل تعتقد أن الرحلة أوشكت على الانتهاء؟ أم أنها البداية الحقيقية؟"
الصديق: "الرجاء لا ينتهي أبداً يا صديقي، كل خطوة نخطوها هنا هي شهادة للمستقبل."

[تتجه الإضاءة نحو المنتصف وتتعالي نغمات الكمان]
''',
        fileUrl: 'assets/scripts/scene_1.pdf',
        pageCount: 12,
        addedDate: '2026-08-01',
        author: 'م/ ديفيد نادي والمشرفين',
      ),
      ScriptItem(
        id: 'sc-102',
        title: 'إسكريبت المشهد الثاني: مواجهة الحقيقة',
        sceneName: 'المشهد الثاني',
        description: 'المواجهة الحادّة في منتصف المسرحية وتوزيع الأدوار الثانوية',
        contentText: '''
[المشهد الثاني: ديكور القرية القديمة، أصوات رياح في الخلفية]

قائد المسرحية: "نقف اليوم هنا لنعلن القرار النهائي، لا تراجع عن المحبة والخدمة."
الفنان الأكبر: "نحن مستعدون دائماً للعمل الجماعي والإبداع المسرحي."
''',
        fileUrl: 'assets/scripts/scene_2.pdf',
        pageCount: 18,
        addedDate: '2026-08-05',
        author: 'جنة الفريق',
      ),
      ScriptItem(
        id: 'sc-103',
        title: 'نص المسرحية المتكامل (النسخة النهائية 2026)',
        sceneName: 'العرض الكامل',
        description: 'الملف الشامل لكافة مشاهد مسرحية مسرح حي 2026 مع توجيهات الديكور والإضاءة',
        contentText: '''
العرض المسرحي السنوي 2026: "رجاء لا يخيب"
فريق المسرح الكنسي.
يتضمن النص 5 مشاهد متكاملة مع جدول الديكور والمؤثرات الصوتية.
''',
        fileUrl: 'assets/scripts/full_play_2026.pdf',
        pageCount: 45,
        addedDate: '2026-08-08',
        author: 'م/ ديفيد نادي',
      ),
    ];
  }

  List<RoleScheduleItem> _getDefaultRoles() {
    return [
      RoleScheduleItem(
        id: 'rl-1',
        sceneName: 'المشهد الأول',
        characterName: 'الراوي الرئيسي',
        actorName: 'م/ ديفيد نادي',
        rehearsalTime: 'الجمعة 06:00 مساءً',
        location: 'قاعة المسرح الكبير',
        status: 'جاهز للمسرح',
        notes: 'التركيز على مخارج الحروف والإلقاء الصوتي',
      ),
      RoleScheduleItem(
        id: 'rl-2',
        sceneName: 'المشهد الأول',
        characterName: 'الشخصية الرئيسية (ستيفن)',
        actorName: 'بيتر يوسف',
        rehearsalTime: 'الجمعة 06:30 مساءً',
        location: 'قاعة المسرح الكبير',
        status: 'قيد البروزة',
        notes: 'حفظ الحوار الأخير وتنسيق الحركة مع الإضاءة',
      ),
      RoleScheduleItem(
        id: 'rl-3',
        sceneName: 'المشهد الثاني',
        characterName: 'صديق ستيفن (مينا)',
        actorName: 'جون سامي',
        rehearsalTime: 'الأحد 07:00 مساءً',
        location: 'غرفة البروفات',
        status: 'تم الحفظ',
        notes: 'تناسق الملابس الكنسية مع ديكور القرية',
      ),
      RoleScheduleItem(
        id: 'rl-4',
        sceneName: 'المشهد الختامي',
        characterName: 'الكورال والشعب',
        actorName: 'مجموعة الممثلين الكنسية',
        rehearsalTime: 'الثلاثاء 08:00 مساءً',
        location: 'المسرح الرئيسي',
        status: 'جاهز للمسرح',
        notes: 'البروفة العامة الكاملة بالأزياء والأنوار',
      ),
    ];
  }

  List<MusicTrack> _getDefaultTracks() {
    return [
      MusicTrack(
        id: 'm-1',
        title: 'موسيقى افتتاحية - نور الرجاء',
        category: 'موسيقى تصويرية',
        duration: '04:15',
        audioUrl: 'assets/audio/opening_light.mp3',
        composer: 'موسيقى المسرح الكنسي',
      ),
      MusicTrack(
        id: 'm-2',
        title: 'مؤثر صوتي - رياح وعاصفة هادئة',
        category: 'مؤثرات صوتية',
        duration: '01:30',
        audioUrl: 'assets/audio/wind_effect.mp3',
        composer: 'مؤثرات حية',
      ),
      MusicTrack(
        id: 'm-3',
        title: 'لحن الختام - مسرح حي 2026',
        category: 'ترانيم وألحان',
        duration: '05:00',
        audioUrl: 'assets/audio/finale_hymn.mp3',
        composer: 'كورال المسرح الكنسي',
      ),
    ];
  }
}
