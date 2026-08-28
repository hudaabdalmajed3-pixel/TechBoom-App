import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class ProjectManagementScreen extends StatefulWidget {
  const ProjectManagementScreen({Key? key}) : super(key: key);

  @override
  _ProjectManagementScreenState createState() => _ProjectManagementScreenState();
}

class _ProjectManagementScreenState extends State<ProjectManagementScreen> {
  // 🎨 نظام الألوان
  final Color _surfaceColor = Colors.white; 
  final Color _borderColor = Colors.grey.shade300; 
  final Color _primaryBlue = const Color(0xFF007BFF); 

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // خلفية رمادي فاتح جداً لتبرز الكروت البيضاء
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('الإدارة والتطوير', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              const SizedBox(height: 15),

              // السلايدرات (أمثلة)
              // (احتفظ بنفس أكواد السلايدر القديمة الخاصة بك هنا)
              
              const SizedBox(height: 30),
              const Text('نقاط القوة (تستخدم مرة واحدة)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              const SizedBox(height: 15),

              // 🌟 أزرار نقاط القوة الذكية (تم تحويلها لشكل عمودي مع إضاءة)
              Column(
                children: [
                  _buildPowerButton('تخفيض تكلفة الإنتاج', Icons.arrow_downward_rounded, 'reduce_cost', game.usedReduceCost, game),
                  _buildPowerButton('تعزيز التطوير', Icons.auto_awesome_rounded, 'boost_dev', game.usedBoostDev, game),
                  _buildPowerButton('الحماية من الطرد', Icons.shield_rounded, 'protect_export', game.usedProtectExport, game),
                  _buildPowerButton('استبعاد بطاقة الأحداث', Icons.layers_clear_rounded, 'exclude_event', game.usedExcludeEvent, game),
                ],
              ),
              const SizedBox(height: 100), 
            ],
          ),
        ),
      ),
    );
  }

  // 🌟 تصميم الكرت العمودي الجديد
  Widget _buildPowerButton(String title, IconData icon, String powerId, bool isUsed, GameProvider game) {
    return GestureDetector(
      onTap: isUsed ? null : () {
        game.usePower(powerId, context);
        // رسالة تأكيد اختيارية عند الاستخدام
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(game.isArabic ? 'تم تفعيل القدرة: $title' : 'Power activated!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          )
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15), // المسافة العمودية بين الكروت
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isUsed ? Colors.grey.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(15),
          // إطار أزرق خفيف للزر الفعال، ورمادي للمستخدم
          border: Border.all(color: isUsed ? Colors.grey.shade300 : _primaryBlue.withOpacity(0.4)), 
          
          // 🌟 الإضاءة الزرقاء الخفيفة (توهج الشعار)
          boxShadow: isUsed ? [] : [
            BoxShadow(
              color: _primaryBlue.withOpacity(0.15), // لون الشعار بشفافية
              blurRadius: 15, // نعومة التوهج
              spreadRadius: 2, // حجم التوهج
              offset: const Offset(0, 4)
            )
          ],
        ),
        child: Row(
          children: [
            // الأيقونة داخل دائرة
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUsed ? Colors.transparent : _primaryBlue.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isUsed ? Colors.grey : _primaryBlue, size: 28),
            ),
            const SizedBox(width: 15),
            
            // النص
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isUsed ? Colors.grey : const Color(0xFF0F172A), 
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // أيقونة توضح حالة الزر (فعال أم مستخدم)
            if (!isUsed)
               Icon(Icons.check_circle_outline_rounded, color: _primaryBlue, size: 24)
            else
               const Icon(Icons.done_all_rounded, color: Colors.grey, size: 24)
          ],
        ),
      ),
    );
  }
}