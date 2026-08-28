import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    
    // التحقق مما إذا تم الدخول للشاشة من الهيدر (لعرض زر الرجوع)
    bool canPop = Navigator.canPop(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      // 🌟 إضافة التدرج اللوني الداكن ليتطابق مع باقي شاشات اللعبة
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF0F172A), Color(0xFF2E1437), Color(0xFF130F26)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 150.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // شريط علوي ذكي يحتوي على زر الرجوع والعنوان
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (canPop)
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      )
                    else
                      const SizedBox(width: 48), // للحفاظ على التوسيط إذا لم يكن هناك زر رجوع

                    Text(
                      provider.getText('profile_title'),
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    
                    const SizedBox(width: 48), 
                  ],
                ),
                const SizedBox(height: 30),
                
                // صورة اللاعب
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [Color(0xFF00E5FF), Color(0xFFD500F9)]),
                    boxShadow: [BoxShadow(color: const Color(0xFF00E5FF).withOpacity(0.4), blurRadius: 20)],
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFF0F172A),
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15),
                
                Text(provider.getText('investor_name'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(provider.getText('profile_role'), style: const TextStyle(fontSize: 14, color: Color(0xFF00E5FF))),
                const SizedBox(height: 40),

                // بيانات البروفايل
                _buildInfoRow(Icons.email_rounded, provider.getText('profile_email'), 'investor@techboom.com'),
                const SizedBox(height: 15),
                _buildInfoRow(Icons.public_rounded, provider.getText('profile_country'), 'Oman'),
                const SizedBox(height: 15),
                _buildInfoRow(Icons.star_rounded, provider.getText('profile_level'), 'Level 5'),
                const SizedBox(height: 15),
                _buildInfoRow(Icons.calendar_today_rounded, provider.getText('profile_joined'), '2023 - Nov'),

                const SizedBox(height: 40),
                
                // 🌟 زر التعديل المبرمج
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // إظهار رسالة عند الضغط تتناسب مع لغة اللعبة
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(provider.isArabic ? 'شاشة تعديل البيانات ستتوفر قريباً' : 'Edit profile coming soon'),
                          backgroundColor: Colors.blueAccent,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_rounded, color: Colors.white),
                    label: Text(provider.getText('btn_edit_profile'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.white24)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 20),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}