import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  // المتغيرات الخاصة بالعداد والقائمة المنسدلة
  String _selectedCategory = 'Production';
  double _selectedPercentage = 0.0; // النسبة المئوية الحالية للعداد

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);

    // تحديد لون النص الخاص بالنسبة بناءً على القيمة
    Color percentageColor = _selectedPercentage > 0 
        ? Colors.green 
        : (_selectedPercentage < 0 ? Colors.redAccent : const Color(0xFF0F172A));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              
              // أيقونة الشاشة
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF007BFF).withOpacity(0.1), 
                  shape: BoxShape.circle
                ),
                child: const Icon(Icons.speed_rounded, size: 80, color: Color(0xFF007BFF)),
              ),
              const SizedBox(height: 20),
              
              Text(
                game.getText('events_subtitle'), 
                textAlign: TextAlign.center, 
                style: const TextStyle(fontSize: 16, color: Colors.black54)
              ),
              const SizedBox(height: 40),

              // القائمة المنسدلة لاختيار القسم (إنتاج، تطوير، تسويق)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF007BFF)),
                    items: [
                      DropdownMenuItem(value: 'Production', child: Text(game.isArabic ? 'عداد الإنتاج' : 'Production')),
                      DropdownMenuItem(value: 'R&D', child: Text(game.isArabic ? 'عداد التطوير' : 'R&D')),
                      DropdownMenuItem(value: 'Marketing', child: Text(game.isArabic ? 'عداد التسويق' : 'Marketing')),
                    ],
                    onChanged: (val) => setState(() => _selectedCategory = val!),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // عرض النسبة المئوية المختارة بشكل أنيق
              Text(
                '${_selectedPercentage > 0 ? '+' : ''}${_selectedPercentage.toInt()}%',
                style: TextStyle(
                  fontSize: 36, // تم تصغير الخط قليلاً ليتناسب مع الأناقة الجديدة
                  fontWeight: FontWeight.bold, 
                  color: percentageColor,
                ),
              ),
              const SizedBox(height: 10),

              // 🌟 العداد التفاعلي (Slider) بتصميم رفيع وأنيق 🌟
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: percentageColor,
                  inactiveTrackColor: Colors.grey.shade300,
                  thumbColor: percentageColor,
                  overlayColor: percentageColor.withOpacity(0.2),
                  trackHeight: 4.0, // 🌟 تم تقليل السُمك ليكون رفيعاً وأنيقاً
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0), // 🌟 تصغير المقبض ليتناسب مع العداد
                ),
                child: Slider(
                  value: _selectedPercentage,
                  min: -100.0, // أدنى نسبة يمكن اختيارها
                  max: 100.0,  // أقصى نسبة يمكن اختيارها
                  divisions: 200, // عدد الخطوات
                  label: '${_selectedPercentage.toInt()}%',
                  onChanged: (double newValue) {
                    setState(() {
                      _selectedPercentage = newValue;
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 10),
              // علامات توضيحية لأسفل العداد (سالب وموجب)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('-100%', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  Text('0%', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text('+100%', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
              
              const Spacer(),

              // زر التفعيل
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // إذا لم يقم اللاعب بتحريك العداد (القيمة 0)، لن يتم إرسال شيء
                    if (_selectedPercentage != 0) {
                      game.applyEventCard(_selectedCategory, _selectedPercentage, context);
                      
                      // إعادة العداد إلى نقطة الصفر بعد التطبيق
                      setState(() {
                        _selectedPercentage = 0.0;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(game.isArabic ? 'يرجى تحريك العداد لتحديد النسبة أولاً!' : 'Please move the slider first!'),
                          backgroundColor: Colors.orange,
                        )
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007BFF),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    shadowColor: const Color(0xFF00C3FF).withOpacity(0.5),
                  ),
                  child: Text(
                    game.isArabic ? 'تطبيق البطاقة' : 'Apply Event', 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
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
}