import 'package:flutter/material.dart';
import 'dart:ui';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool _soundEnabled = true;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'الإعدادات',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 30),
              _buildGlassSettingTile(
                icon: Icons.volume_up_rounded,
                title: 'المؤثرات الصوتية',
                trailing: Switch(
                  value: _soundEnabled,
                  activeColor: const Color(0xFF00E5FF),
                  onChanged: (val) => setState(() => _soundEnabled = val),
                ),
              ),
              const SizedBox(height: 15),
              _buildGlassSettingTile(
                icon: Icons.notifications_active_rounded,
                title: 'الإشعارات',
                trailing: Switch(
                  value: _notificationsEnabled,
                  activeColor: const Color(0xFFD500F9),
                  onChanged: (val) => setState(() => _notificationsEnabled = val),
                ),
              ),
              const SizedBox(height: 15),
              _buildGlassSettingTile(
                icon: Icons.language_rounded,
                title: 'لغة اللعبة',
                trailing: const Text('العربية', style: TextStyle(color: Colors.white70, fontSize: 16)),
              ),
              const SizedBox(height: 15),
              _buildGlassSettingTile(
                icon: Icons.help_outline_rounded,
                title: 'قواعد اللعبة (TB Rules)',
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

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