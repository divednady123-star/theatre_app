import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_constants.dart';
import '../core/services/auth_service.dart';
import 'admin_login_dialog.dart';
import 'live_theatre_2026_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _showAboutTeamDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.church, color: AppConstants.softGoldPrimary),
            SizedBox(width: 8),
            Text('عن فريق المسرح الكنسي'),
          ],
        ),
        content: const Text(
          'فريق المسرح الكنسي يهدف إلى تقديم الأعمال الدرامية والمسرحية الراقية ذات الرسالة الروحية والإنسانية، بأسلوب احترافي وعصري يجمع بين النص المتقن والموسيقى المعبرة والأداء المتميز.',
          style: TextStyle(height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            tooltip: authService.isAdmin ? 'حساب المشرف مفعّل' : 'تسجيل دخول المشرف',
            icon: Icon(
              authService.isAdmin ? Icons.admin_panel_settings : Icons.lock_outline,
              color: authService.isAdmin ? AppConstants.softGoldPrimary : Colors.white70,
            ),
            onPressed: () => AdminLoginDialog.show(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  children: [
                    // --- HEADER SECTION ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppConstants.royalBlueDark, AppConstants.royalBluePrimary],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppConstants.softGoldPrimary, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.royalBlueDark.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Team Logo Container
                          Container(
                            width: 86,
                            height: 86,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppConstants.bgPureWhite,
                              border: Border.all(color: AppConstants.softGoldPrimary, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: AppConstants.softGoldPrimary.withOpacity(0.3),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: AppConstants.royalBlueDark,
                              child: Stack(
                                alignment: Alignment.center,
                                children: const [
                                  Icon(Icons.theater_comedy, size: 42, color: AppConstants.softGoldPrimary),
                                  Positioned(
                                    top: 10,
                                    child: Icon(Icons.church, size: 16, color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Title
                          const Text(
                            AppConstants.appName,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.softGoldPrimary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Welcome Message
                          const Text(
                            'أهلاً بكم في منصة متابعة وإدارة أعمال وفنون المسرح الكنسي',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                          if (authService.isAdmin) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppConstants.softGoldPrimary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'وضع المشرف (Admin Mode)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.royalBlueDark,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // --- MAIN MENU CARDS ---
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'القائمة الرئيسية:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.royalBlueDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 1 (PRIMARY): مسرح حي 2026
                    Card(
                      elevation: 6,
                      shadowColor: AppConstants.softGoldPrimary.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: AppConstants.softGoldPrimary, width: 2),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LiveTheatre2026Screen()),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppConstants.royalBlueDark,
                                AppConstants.royalBluePrimary.withOpacity(0.95),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppConstants.softGoldPrimary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppConstants.softGoldPrimary.withOpacity(0.4),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.star_rounded,
                                  color: AppConstants.royalBlueDark,
                                  size: 36,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      AppConstants.liveTheatre2026Title,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppConstants.softGoldPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'الاسكربيتات • التقسيمة • التراكات الموسيقية',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: AppConstants.softGoldPrimary,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 2: Admin Panel / Login Quick Card
                    Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: AppConstants.softGoldPrimary.withOpacity(0.2),
                          child: Icon(
                            authService.isAdmin ? Icons.admin_panel_settings : Icons.lock_outline,
                            color: AppConstants.royalBlueDark,
                          ),
                        ),
                        title: Text(
                          authService.isAdmin ? 'لوحة تحكم المشرف (مفعّلة)' : 'تسجيل دخول المشرف (Admin Login)',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          authService.isAdmin
                              ? 'يمكنك إضافة وتعديل كافة البيانات'
                              : 'اضغط لإدخال كلمة السر والحصول على صلاحيات الإضافة والتعديل',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: const Icon(Icons.chevron_left, color: AppConstants.softGoldPrimary),
                        onTap: () => AdminLoginDialog.show(context),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Card 3: About Team Card
                    Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: AppConstants.royalBluePrimary.withOpacity(0.1),
                          child: const Icon(Icons.info_outline, color: AppConstants.royalBluePrimary),
                        ),
                        title: const Text('عن فريق المسرح الكنسي', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('رؤية وفلسفة العمل المسرحي الكنسي', style: TextStyle(fontSize: 12)),
                        trailing: const Icon(Icons.chevron_left, color: AppConstants.softGoldPrimary),
                        onTap: () => _showAboutTeamDialog(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- MANDATORY FOOTER SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                children: [
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppConstants.softGoldPrimary.withOpacity(0.4),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    AppConstants.footerSignature,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.royalBlueDark,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
