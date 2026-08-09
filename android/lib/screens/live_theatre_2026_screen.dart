import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_constants.dart';
import '../core/services/data_service.dart';
import 'scripts_screen.dart';
import 'roles_schedule_screen.dart';
import 'music_screen.dart';

class LiveTheatre2026Screen extends StatelessWidget {
  const LiveTheatre2026Screen({Key? key}) : super(key: key);

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required String badgeText,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppConstants.softGoldPrimary, width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: iconBgColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppConstants.softGoldPrimary, width: 1),
                ),
                child: Icon(icon, size: 32, color: iconBgColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.royalBlueDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppConstants.softGoldPrimary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            badgeText,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.royalBlueDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppConstants.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppConstants.softGoldPrimary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('قسم مسرح حي 2026'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppConstants.royalBlueDark, AppConstants.royalBluePrimary],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppConstants.softGoldPrimary, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'عرض "مسرح حي 2026"',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.softGoldPrimary,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'اختر أحد الأقسام التالية للاطلاع على ملفات النصوص والاسكربيتات، جدول التقسيمة والأدوار، والمؤثرات والتراكات الموسيقية الخاصة بالعرض المسرحي.',
                    style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'الأقسام الرئيسية بالعرض:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.royalBlueDark,
              ),
            ),
            const SizedBox(height: 16),

            // Card 1: Scripts
            _buildCategoryCard(
              context: context,
              title: 'الاسكربيتات',
              subtitle: 'نصوص المشاهد واستعراض ملفات الـ PDF والقراءة الفورية للسيناريو',
              icon: Icons.menu_book_rounded,
              iconBgColor: AppConstants.royalBluePrimary,
              badgeText: '${dataService.scripts.length} ملفات',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScriptsScreen()),
                );
              },
            ),

            // Card 2: Roles & Schedule
            _buildCategoryCard(
              context: context,
              title: 'التقسيمة',
              subtitle: 'توزيع الأدوار والشخصيات وتوقيتات البروفات وحالة الجاهزية',
              icon: Icons.recent_actors_rounded,
              iconBgColor: AppConstants.softGoldDark,
              badgeText: '${dataService.roles.length} أدوار',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RolesScheduleScreen()),
                );
              },
            ),

            // Card 3: Music Tracks
            _buildCategoryCard(
              context: context,
              title: 'الموسيقى',
              subtitle: 'المؤثرات الصوتية والترانيم والتراكات الموسيقية مع مشغل صوت مدمج',
              icon: Icons.music_note_rounded,
              iconBgColor: Colors.deepPurple,
              badgeText: '${dataService.tracks.length} تراكات',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MusicScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
