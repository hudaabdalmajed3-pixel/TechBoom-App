import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // 🌟 استدعاء مكتبة الصوتيات

class GameProvider with ChangeNotifier {
  // ==========================================
  // 🌟 إعداد مشغل الصوت الأساسي (باحترافية)
  // ==========================================
  
  // 🌟 دالة لتشغيل الصوت تدعم "التداخل" (Overlapping) لعدم انقطاع الصوت عند الضغط السريع
  void playSound(String fileName) async {
    if (isSoundEnabled) {
      try {
        final AudioPlayer localPlayer = AudioPlayer();
        await localPlayer.play(AssetSource('sounds/$fileName'));
        
        // إغلاق المشغل بعد انتهاء الصوت لتوفير الذاكرة
        localPlayer.onPlayerComplete.listen((event) {
          localPlayer.dispose();
        });
      } catch (e) {
        print("❌ خطأ في تشغيل الصوت ($fileName): $e");
      }
    }
  }

  // ==========================================
  // 1. المتغيرات المالية الأساسية
  // ==========================================
  double capital = 10000.0; 
  double get tbCapital => capital; 
  
  double totalCosts = 0.0;  
  double exportProfits = 0.0; 
  double operationProfits = 0.0; 
  double auctionBalance = 200.0; 

  // ==========================================
  // 2. سجل رأس المال (للرسم البياني)
  // ==========================================
  List<double> capitalHistory = [10000.0]; 

  // ==========================================
  // 3. مستويات التطوير
  // ==========================================
  double productionLevel = 0.0;
  double marketingLevel = 0.0;
  double rndLevel = 0.0;

  // ==========================================
  // 🌟 4. متغيرات قدرات المزاد (AuctionScreen)
  // ==========================================
  bool isRevealUsed = false;
  bool isDisableUsed = false;
  bool isWithdrawUsed = false;

  // ==========================================
  // 🌟 5. متغيرات قدرات إدارة المشروع (ProjectManagementScreen)
  // ==========================================
  bool usedReduceCost = false;
  bool usedBoostDev = false;
  bool usedProtectExport = false;
  bool usedExcludeEvent = false;

  // ==========================================
  // 🌟 6. إعدادات الصوت والإشعارات
  // ==========================================
  bool isSoundEnabled = true;
  bool isNotificationsEnabled = true;

  void toggleSound(bool value) {
    isSoundEnabled = value;
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    isNotificationsEnabled = value;
    notifyListeners();
  }

  // ==========================================
  // 7. نظام اللغة والترجمة الشامل (تلقائي الاتجاه)
  // ==========================================
  bool isArabic = true;
  
  Locale get locale => isArabic ? const Locale('ar') : const Locale('en');

  void toggleLanguage() {
    isArabic = !isArabic;
    notifyListeners(); 
  }

  // القاموس العربي
  final Map<String, String> _textsAr = {
    'nav_home': 'الإدارة',
    'nav_auction': 'المزاد',
    'nav_events': 'الأحداث',
    'nav_stats': 'النتائج', 
    'nav_prefs': 'الإعدادات',
    'pref_title': 'الإعدادات',
    'pref_sound': 'المؤثرات الصوتية',
    'pref_notif': 'الإشعارات',
    'pref_lang': 'لغة اللعبة',
    'pref_current_lang': 'العربية',
    'btn_logout': 'تسجيل الخروج',
    'stat_page_title': 'إحصائيات المشروع',
    'stat_page_subtitle': 'راقب نمو استثماراتك',
    'stat_capital': 'إجمالي رأس المال',
    'stat_chart_title': 'النمو المالي (TB)',
    'stat_production': 'مستوى الإنتاج',
    'stat_marketing': 'مستوى التسويق',
    'stat_rnd': 'البحث والتطوير',
    'btn_up_prod': 'ترقية الإنتاج',
    'btn_up_mark': 'ترقية التسويق',
    'btn_up_rnd': 'ترقية البحث',
    'auction_title': 'أزرار المزاد (TB Actions)',
    'auction_subtitle': 'استخدم الـ TB للحصول على ميزة تنافسية',
    'ab_reveal_title': 'كشف المعلومات',
    'ab_reveal_desc': 'عرض بيانات مخفية عن المشروع (50 TB)',
    'ab_disable_title': 'تعطيل لاعب',
    'ab_disable_desc': 'إيقاف لاعب مؤقتاً عن المزايدة (100 TB)',
    'ab_withdraw_title': 'انسحاب',
    'ab_withdraw_desc': 'الانسحاب من المزاد وتحويل المتبقي لرأس المال',
    'events_title': 'إدخال بطاقات الأحداث',
    'events_subtitle': 'أدخل النسبة لتحديث رأس المال تلقائياً',
    'btn_activate': 'تفعيل',
    'btn_used': 'مُستخدم',
    'msg_success': 'تم تفعيل',
    'msg_insufficient_tb': 'رصيد المزاد غير كافٍ!',
    'investor_name': 'المستثمر الذكي',
  };

  // القاموس الإنجليزي
  final Map<String, String> _textsEn = {
    'nav_home': 'Management',
    'nav_auction': 'Auction',
    'nav_events': 'Events',
    'nav_stats': 'Results', 
    'nav_prefs': 'Settings',
    'pref_title': 'Settings',
    'pref_sound': 'Sound Effects',
    'pref_notif': 'Notifications',
    'pref_lang': 'Language',
    'pref_current_lang': 'English',
    'btn_logout': 'Logout',
    'stat_page_title': 'Project Stats',
    'stat_page_subtitle': 'Monitor your investments',
    'stat_capital': 'Total Capital',
    'stat_chart_title': 'Financial Growth (TB)',
    'stat_production': 'Production Level',
    'stat_marketing': 'Marketing Level',
    'stat_rnd': 'R&D Level',
    'btn_up_prod': 'Upgrade Production',
    'btn_up_mark': 'Upgrade Marketing',
    'btn_up_rnd': 'Upgrade R&D',
    'auction_title': 'Auction Actions',
    'auction_subtitle': 'Use TB for a competitive edge',
    'ab_reveal_title': 'Reveal Info',
    'ab_reveal_desc': 'Show hidden project data (50 TB)',
    'ab_disable_title': 'Disable Player',
    'ab_disable_desc': 'Temporarily stop a player (100 TB)',
    'ab_withdraw_title': 'Withdraw',
    'ab_withdraw_desc': 'Withdraw and transfer remaining TB to capital',
    'events_title': 'Event Cards Entry',
    'events_subtitle': 'Enter percentage to update capital instantly',
    'btn_activate': 'Activate',
    'btn_used': 'Used',
    'msg_success': 'Activated',
    'msg_insufficient_tb': 'Insufficient Auction Balance!',
    'investor_name': 'Smart Investor',
  };

  String getText(String key) {
    if (isArabic) {
      return _textsAr[key] ?? key;
    } else {
      return _textsEn[key] ?? key;
    }
  }

  // ==========================================
  // 🌟 8. دوال اللعبة وتوزيع الأصوات عليها
  // ==========================================

  // --- دالة شاشة إدارة المشروع ---
  void usePower(String powerType, BuildContext context) {
    if (powerType == 'reduce_cost' && !usedReduceCost) {
      usedReduceCost = true;
      playSound('power.mp3'); // 🌟 صوت قدرة خاصة
    } else if (powerType == 'boost_dev' && !usedBoostDev) {
      usedBoostDev = true;
      playSound('power.mp3'); 
    } else if (powerType == 'protect_export' && !usedProtectExport) {
      usedProtectExport = true;
      playSound('power.mp3'); 
    } else if (powerType == 'exclude_event' && !usedExcludeEvent) {
      usedExcludeEvent = true;
      playSound('power.mp3'); 
    }
    notifyListeners();
  }

  void applyProjectCost(double cost) {
    if (capital >= cost) {
      capital -= cost;
      totalCosts += cost;
      capitalHistory.add(capital); 
      playSound('pay.mp3'); // 🌟 صوت دفع تكلفة
      notifyListeners(); 
    } else {
      playSound('error.mp3'); // 🌟 صوت خطأ (لا يوجد مال كافٍ)
    }
  }

  void addCapital(double amount) {
    capital += amount;
    capitalHistory.add(capital);
    playSound('coin.mp3'); // 🌟 صوت زيادة المال
    notifyListeners();
  }

  // --- دوال شاشة المزاد (Auction) ---
  bool useAbility(String abilityId, int cost) {
    if (auctionBalance >= cost) {
      if (abilityId == 'reveal' && !isRevealUsed) {
        auctionBalance -= cost;
        isRevealUsed = true;
        playSound('power.mp3'); // 🌟 صوت استخدام قدرة في المزاد
        notifyListeners();
        return true;
      } else if (abilityId == 'disable' && !isDisableUsed) {
        auctionBalance -= cost;
        isDisableUsed = true;
        playSound('power.mp3'); 
        notifyListeners();
        return true;
      } else if (abilityId == 'withdraw' && !isWithdrawUsed) {
        capital += auctionBalance; 
        capitalHistory.add(capital);
        auctionBalance = 0; 
        isWithdrawUsed = true;
        playSound('coin.mp3'); // 🌟 صوت الانسحاب وتحويل الرصيد لمال
        notifyListeners();
        return true;
      }
    } else {
      playSound('error.mp3'); // 🌟 صوت خطأ في حال عدم وجود رصيد مزاد
    }
    return false;
  }

  // --- دالة الأحداث (Events) ---
  void applyEventCard(String category, double percentage, BuildContext context) {
    double amountChange = capital * (percentage / 100);
    capital += amountChange;
    capitalHistory.add(capital); 

    // 🌟 تشغيل صوت مناسب حسب طبيعة الحدث (ربح أم خسارة)
    if (percentage > 0) {
      playSound('coin.mp3'); // حدث إيجابي
    } else {
      playSound('pay.mp3'); // حدث سلبي (خسارة)
    }

    if (category == 'Production' || category == 'الإنتاج') {
      productionLevel += percentage;
    } else if (category == 'R&D' || category == 'التطوير') {
      rndLevel += percentage;
    } else if (category == 'Marketing' || category == 'التسويق') {
      marketingLevel += percentage;
    }
    notifyListeners();

    // 🌟 تطبيق خيار الإشعارات
    if (isNotificationsEnabled) {
      String message = isArabic 
          ? 'تم تعديل رأس المال بمقدار ${amountChange.toInt()} TB'
          : 'Capital adjusted by ${amountChange.toInt()} TB';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: percentage >= 0 ? Colors.green : Colors.redAccent,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // --- دوال الترقية ---
  void upgradeProduction() {
    productionLevel += 5;
    playSound('upgrade.mp3'); // 🌟 صوت الترقية والتطوير
    notifyListeners();
  }

  void upgradeMarketing() {
    marketingLevel += 5;
    playSound('upgrade.mp3'); 
    notifyListeners();
  }

  void upgradeRnD() {
    rndLevel += 5;
    playSound('upgrade.mp3'); 
    notifyListeners();
  }
}