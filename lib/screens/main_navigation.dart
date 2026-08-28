import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

// 🌟 استدعاء الشاشات الخمسة الأساسية (تأكد من أسماء الملفات عندك)
import 'project_management_screen.dart'; // 0: الإدارة
import 'auction_screen.dart';            // 1: المزاد (بدل القدرات)
import 'events_screen.dart';             // 2: الأحداث (الشاشة اليدوية الجديدة)
import 'statistics_screen.dart';         // 3: الإحصائيات
import 'preferences_screen.dart';        // 4: الإعدادات

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // 🌟 تحديث القائمة عشان تستخدم الشاشات الجديدة
  final List<Widget> _widgetOptions = const <Widget>[
    ProjectManagementScreen(), 
    AuctionScreen(),         // شاشة المزاد
    EventsScreen(),          // شاشة الأحداث اليدوية
    StatisticsScreen(),        
    PreferencesScreen(),       
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white, // 🌟 خلفية بيضاء للتطبيق
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

// ==============================================================
// 🌟 شريط التنقل السفلي المعدل (أبيض وأزرق)
// ==============================================================
class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({Key? key, required this.selectedIndex, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context); 

    return Container(
      height: 90, 
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white, // شريط سفلي أبيض
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, 
          children: [
            NavBarItem(icon: Icons.business_center_rounded, label: provider.getText('nav_home'), isActive: selectedIndex == 0, onTap: () => onTap(0)),
            NavBarItem(icon: Icons.gavel_rounded, label: provider.getText('nav_auction'), isActive: selectedIndex == 1, onTap: () => onTap(1)),
            NavBarItem(icon: Icons.event_note_rounded, label: provider.getText('nav_events'), isActive: selectedIndex == 2, onTap: () => onTap(2)),
            NavBarItem(icon: Icons.bar_chart_rounded, label: provider.getText('nav_stats'), isActive: selectedIndex == 3, onTap: () => onTap(3)),
            NavBarItem(icon: Icons.settings_rounded, label: provider.getText('nav_prefs'), isActive: selectedIndex == 4, onTap: () => onTap(4)),
          ],
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavBarItem({Key? key, required this.icon, required this.label, required this.onTap, this.isActive = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isActive ? 10.0 : 6.0),
            decoration: isActive ? BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF007BFF).withOpacity(0.1), // خلفية زرقاء شفافة عند التحديد
            ) : null,
            child: Icon(icon, color: isActive ? const Color(0xFF007BFF) : Colors.grey, size: 26), // أيقونة زرقاء أو رمادية
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? const Color(0xFF007BFF) : Colors.grey, // نص أزرق أو رمادي
            ),
          ),
        ],
      ),
    );
  }
}