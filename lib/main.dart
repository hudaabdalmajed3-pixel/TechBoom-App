import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'providers/game_provider.dart';
import 'screens/login_screen.dart'; // 🌟 تأكد من مسار الشاشة الصحيح لديك

void main() async {
  // 🌟 هذا السطر ضروري لتهيئة الفلاتر قبل فايربيس
  WidgetsFlutterBinding.ensureInitialized();
  
  // 🌟 تهيئة فايربيس بناءً على المنصة (أندرويد، آيفون، أو ويب)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: const TechBoomApp(),
    ),
  );
}

class TechBoomApp extends StatelessWidget {
  const TechBoomApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        return MaterialApp(
          title: 'TechBoom Game',
          debugShowCheckedModeBanner: false,
          
          locale: game.isArabic ? const Locale('ar', 'AE') : const Locale('en', 'US'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar', 'AE'),
            Locale('en', 'US'),
          ],

          theme: ThemeData(
            primaryColor: const Color(0xFF007BFF),
            fontFamily: 'Cairo',
            scaffoldBackgroundColor: Colors.white,
          ),
          // 🌟 وضعنا const هنا لتحسين أداء اللعبة 
          home: const LoginScreen(), 
        );
      },
    );
  }
}