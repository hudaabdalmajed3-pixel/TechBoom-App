import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart'; // 🌟 استدعاء عقل اللعبة
import 'login_screen.dart'; // 🌟 استدعاء شاشة الدخول لزر تسجيل الخروج (تأكد من مسارها)

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 🌟 الاتصال بـ GameProvider لقراءة وتعديل الإعدادات الحقيقية
    final game = Provider.of<GameProvider>(context);

    return Scaffold(
      // 🌟 تم وضع خلفية داكنة أنيقة لكي يظهر التأثير الزجاجي والنص الأبيض بوضوح
      backgroundColor: const Color(0xFF0F172A), 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                game.getText('pref_title'), // 'الإعدادات' من القاموس
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 30),
              
              // 1. زر المؤثرات الصوتية
              _buildGlassSettingTile(
                icon: Icons.volume_up_rounded,
                title: game.getText('pref_sound'),
                trailing: Switch(
                  value: game.isSoundEnabled,
                  activeColor: const Color(0xFF00E5FF),
                  onChanged: (val) {
                    game.toggleSound(val);
                    if (val) game.playSound('click.mp3'); // 🌟 تشغيل صوت كليك عند التفعيل
                  },
                ),
              ),
              const SizedBox(height: 15),
              
              // 2. زر الإشعارات
              _buildGlassSettingTile(
                icon: Icons.notifications_active_rounded,
                title: game.getText('pref_notif'),
                trailing: Switch(
                  value: game.isNotificationsEnabled,
                  activeColor: const Color(0xFFD500F9),
                  onChanged: (val) {
                    game.playSound('click.mp3'); // 🌟 تشغيل صوت كليك
                    game.toggleNotifications(val);
                  },
                ),
              ),
              const SizedBox(height: 15),
              
              // 3. زر اللغة (يمكن الضغط عليه لتغيير اللغة)
              GestureDetector(
                onTap: () {
                  game.playSound('click.mp3'); // 🌟 تشغيل صوت كليك قبل تغيير اللغة
                  game.toggleLanguage();
                },
                child: _buildGlassSettingTile(
                  icon: Icons.language_rounded,
                  title: game.getText('pref_lang'),
                  trailing: Text(
                    game.getText('pref_current_lang'),
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              const SizedBox(height: 15),
              
              // 4. قواعد اللعبة
              GestureDetector(
                onTap: () {
                  game.playSound('click.mp3'); // 🌟 تشغيل صوت كليك
                  // هنا يمكنك لاحقاً إضافة كود لفتح صفحة أو نافذة منبثقة تشرح القواعد
                },
                child: _buildGlassSettingTile(
                  icon: Icons.help_outline_rounded,
                  title: game.isArabic ? 'قواعد اللعبة (TB Rules)' : 'TB Rules',
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                ),
              ),

              const Spacer(), // 🌟 لدفع زر تسجيل الخروج إلى أسفل الشاشة
              
              // 5. زر تسجيل الخروج 🌟
              GestureDetector(
                onTap: () {
                  game.playSound('click.mp3'); // 🌟 تشغيل صوت كليك عند الخروج
                  // العودة إلى شاشة تسجيل الدخول
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()) // تأكد من اسم صفحة الدخول لديك
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout_rounded, color: Colors.redAccent),
                      const SizedBox(width: 10),
                      Text(
                        game.getText('btn_logout'),
                        style: const TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 🌟 تصميم التأثير الزجاجي (Glassmorphism)
  Widget _buildGlassSettingTile({required IconData icon, required String title, required Widget trailing}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: Icon(icon, color: Colors.white, size: 28),
            title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            trailing: trailing,
          ),
        ),
      ),
    );
  }
}