import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🌟 مكتبة فايربيس للمصادقة
import '../providers/game_provider.dart';
import 'main_navigation.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // للتحكم بدائرة التحميل السفلية

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 🌟 دالة تسجيل الدخول الحقيقية عبر Firebase
  Future<void> _loginUser() async {
    final game = Provider.of<GameProvider>(context, listen: false);
    game.playSound('click.mp3'); // صوت الكليك

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // الاتصال بخوادم Firebase للتحقق من صحة الحساب
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // إذا نجح الدخول، انتقل مباشرة لداخل اللعبة
        if (mounted) {
          game.playSound('coin.mp3'); // تشغيل نغمة دخول ناجحة
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation()));
        }
      } on FirebaseAuthException catch (e) {
        // معالجة الأخطاء الذكية وإظهارها للمستخدم
        game.playSound('error.mp3');
        String errorMessage = 'حدث خطأ أثناء تسجيل الدخول';
        
        if (e.code == 'user-not-found' || e.code == 'invalid-email' || e.code == 'invalid-credential') {
          errorMessage = 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'كلمة المرور التي أدخلتها خاطئة.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.redAccent),
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
          Positioned(
            top: -50, right: -50,
            child: Container(
              width: 250, height: 250, 
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                color: const Color(0xFF007BFF).withOpacity(0.05),
                boxShadow: [BoxShadow(color: const Color(0xFF00C3FF).withOpacity(0.1), blurRadius: 100, spreadRadius: 20)]
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/images/logo.jpeg', height: 100, width: 100, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 25),
                      const Text('تسجيل الدخول', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      const SizedBox(height: 30),
                      
                      _buildTextField(Icons.email_outlined, 'البريد الإلكتروني', _emailController),
                      const SizedBox(height: 15),
                      
                      _buildTextField(Icons.lock_outline, 'كلمة المرور', _passwordController, isPassword: true),
                      const SizedBox(height: 30),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _loginUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007BFF), 
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 5,
                            shadowColor: const Color(0xFF00C3FF).withOpacity(0.5),
                          ),
                          child: _isLoading 
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('دخول', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Provider.of<GameProvider>(context, listen: false).playSound('click.mp3');
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegistrationScreen()));
                        },
                        child: const Text('ليس لديك حساب؟ سجل الآن', style: TextStyle(color: Color(0xFF007BFF), fontWeight: FontWeight.w600)),
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

  Widget _buildTextField(IconData icon, String hint, TextEditingController controller, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Color(0xFF0F172A)),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'يرجى إدخال $hint';
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