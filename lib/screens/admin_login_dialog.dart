import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_constants.dart';
import '../core/services/auth_service.dart';

class AdminLoginDialog extends StatefulWidget {
  const AdminLoginDialog({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AdminLoginDialog(),
    );
  }

  @override
  State<AdminLoginDialog> createState() => _AdminLoginDialogState();
}

class _AdminLoginDialogState extends State<AdminLoginDialog> {
  final _passwordController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final password = _passwordController.text.trim();
    if (password.isEmpty) {
      setState(() => _errorMessage = 'رجاءً أدخل كلمة السر الخاصة بالمشرف');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    final success = await authService.loginAsAdmin(password);

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تسجيل الدخول بصلاحيات المشرف بنجاح!'),
            backgroundColor: AppConstants.royalBluePrimary,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        setState(() => _errorMessage = 'كلمة السر غير صحيحة، حاول مرة أخرى');
      }
    }
  }

  void _showChangePasswordDialog(BuildContext context) {
    _oldPasswordController.clear();
    _newPasswordController.clear();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تغيير كلمة السر'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة السر القديمة',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة السر الجديدة',
                prefixIcon: Icon(Icons.key),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              final oldPass = _oldPasswordController.text.trim();
              final newPass = _newPasswordController.text.trim();

              if (oldPass.isEmpty || newPass.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('يرجى ملء جميع الحقول')),
                );
                return;
              }

              final authService = Provider.of<AuthService>(context, listen: false);
              final success = await authService.changeAdminPassword(oldPass, newPass);

              if (context.mounted) {
                Navigator.pop(dialogContext);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تغيير كلمة السر بنجاح!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('كلمة السر القديمة غير صحيحة'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
            child: const Text('حفظ التغيير'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    if (authService.isAdmin) {
      return AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.admin_panel_settings, color: AppConstants.softGoldPrimary),
            SizedBox(width: 8),
            Text('حساب المشرف مفعّل'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('أنت حالياً تتصفح التطبيق بصلاحيات المشرف (Admin Mode). يمكنك الإضافة والتعديل في كافة الأقسام.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _showChangePasswordDialog(context),
            child: const Text('تغيير كلمة السر', style: TextStyle(color: AppConstants.royalBluePrimary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              await authService.logoutAdmin();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم الخروج من وضع المشرف')),
                );
              }
            },
            child: const Text('تسجيل الخروج'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.lock_outline, color: AppConstants.softGoldPrimary),
          SizedBox(width: 8),
          Text('تسجيل دخول المشرف'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'يرجى إدخال كلمة السر السرية الخاصة بمشرف فريق المسرح للوصول إلى صلاحيات الإضافة والتعديل:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'كلمة السر',
                hintText: 'أدخل كلمة السر هنا...',
                prefixIcon: const Icon(Icons.key, color: AppConstants.royalBluePrimary),
                errorText: _errorMessage,
              ),
              onSubmitted: (_) => _handleLogin(),
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
          onPressed: _isLoading ? null : _handleLogin,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('تسجيل الدخول'),
        ),
      ],
    );
  }
}
