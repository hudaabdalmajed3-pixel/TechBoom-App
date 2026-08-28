import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🌟 مكتبة المصادقة
import 'package:cloud_firestore/cloud_firestore.dart'; // 🌟 مكتبة قاعدة البيانات لحفظ الاسم والدولة
import '../providers/game_provider.dart';
import 'login_screen.dart'; 
import 'main_navigation.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // 🌟 إنشاء المتحكمات لقراءة النصوص المكتوبة بشكل صحيح
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // لدائرة التحميل

  final List<String> _countries = [
    'سلطنة عمان', 'المملكة العربية السعودية', 'الإمارات العربية المتحدة', 
    'قطر', 'البحرين', 'الكويت', 'مصر', 'الأردن', 'أخرى'
  ];
  String? _selectedCountry;

  @override
  void dispose() {
    // إغلاق المتحكمات لتوفير ذاكرة الهاتف
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 🌟 دالة إنشاء الحساب والربط بـ Firebase و Firestore
  Future<void> _registerUser() async {
    final game = Provider.of<GameProvider>(context, listen: false);
    game.playSound('click.mp3'); // تشغيل صوت النقرة

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // 1. إنشاء الحساب في نظام الحماية (Authentication)
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // 2. إنشاء جدول وحفظ بيانات اللاعب (الاسم والدولة) في قاعدة البيانات (Firestore)
        await FirebaseFirestore.instance.collection('Users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'country': _selectedCountry,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // 3. النجاح والانتقال للعبة
        if (mounted) {
          game.playSound('coin.mp3'); // صوت النجاح الاحتفالي
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation()));
        }
      } on FirebaseAuthException catch (e) {
        game.playSound('error.mp3'); // صوت الخطأ
        String errorMessage = 'حدث خطأ أثناء إنشاء الحساب';
        
        if (e.code == 'weak-password') {
          errorMessage = 'كلمة المرور ضعيفة جداً (يجب أن تكون 6 أحرف على الأقل).';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'هذا البريد الإلكتروني مسجل مسبقاً بحساب آخر.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'صيغة البريد الإلكتروني غير صحيحة.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.redAccent),
        );
      } catch (e) {
        game.playSound('error.mp3');
        // هذا السطر سيعرض لك أي خطأ آخر (مثل انقطاع الإنترنت أو مشكلة في الصلاحيات)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ غير متوقع: $e'), backgroundColor: Colors.redAccent),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // توهج سماوي خلفي احترافي
          Positioned(
            bottom: -50, right: -50,
            child: Container(
              width: 300, height: 300, 
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                color: const Color(0xFF00C3FF).withOpacity(0.1),
                boxShadow: [BoxShadow(color: const Color(0xFF00C3FF).withOpacity(0.2), blurRadius: 100, spreadRadius: 20)]
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 30, offset: const Offset(0, 10))],
                  border: Border.all(color: const Color(0xFF007BFF).withOpacity(0.1)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person_add_alt_1_rounded, size: 70, color: Color(0xFF007BFF)),
                      const SizedBox(height: 15),
                      const Text('إنشاء حساب جديد', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      const SizedBox(height: 25),
                      
                      // ربط الخانات بالمتحكمات الجديدة 🌟
                      _buildTextField(Icons.person_outline, 'الاسم الكامل', _nameController),
                      const SizedBox(height: 15),
                      
                      _buildTextField(Icons.email_outlined, 'البريد الإلكتروني', _emailController, isEmail: true),
                      const SizedBox(height: 15),
                      
                      _buildTextField(Icons.lock_outline, 'كلمة المرور', _passwordController, isPassword: true),
                      const SizedBox(height: 15),

                      // قائمة اختيار الدولة
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.public, color: Color(0xFF007BFF)),
                          hintText: 'اختر الدولة',
                          hintStyle: const TextStyle(color: Colors.black38),
                          filled: true,
                          fillColor: const Color(0xFFF5F7FA),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                        ),
                        value: _selectedCountry,
                        items: _countries.map((country) => DropdownMenuItem(value: country, child: Text(country))).toList(),
                        onChanged: (value) => setState(() => _selectedCountry = value),
                        validator: (value) => value == null ? 'يرجى اختيار الدولة' : null,
                      ),
                      const SizedBox(height: 25),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _registerUser, // تعطيل الزر أثناء التحميل
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007BFF),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 5,
                            shadowColor: const Color(0xFF00C3FF).withOpacity(0.5),
                          ),
                          child: _isLoading 
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('إنشاء الحساب', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Provider.of<GameProvider>(context, listen: false).playSound('click.mp3');
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                        },
                        child: const Text('لديك حساب بالفعل؟ سجل دخولك', style: TextStyle(color: Color(0xFF007BFF), fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🌟 تعديل الدالة لتستقبل الـ Controller وتقوم بالتحقق الاحترافي
  Widget _buildTextField(IconData icon, String hint, TextEditingController controller, {bool isPassword = false, bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      style: const TextStyle(color: Color(0xFF0F172A)),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال $hint';
        }
        if (isEmail && !value.contains('@')) {
          return 'يرجى إدخال بريد إلكتروني صحيح';
        }
        if (isPassword && value.length < 6) {
          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF007BFF)),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38),
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }
}