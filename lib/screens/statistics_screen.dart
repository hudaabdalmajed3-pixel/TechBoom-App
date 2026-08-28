import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:fl_chart/fl_chart.dart'; // 🌟 مكتبة الرسوم البيانية
import '../providers/game_provider.dart'; 

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return SingleChildScrollView( 
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 60.0, bottom: 150.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                gameProvider.getText('stat_page_title'),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                gameProvider.getText('stat_page_subtitle'),
                style: const TextStyle(fontSize: 16, color: Colors.white54),
              ),
              const SizedBox(height: 30),
              
              // بطاقة رأس المال الأساسية
              _buildStatCard(
                title: gameProvider.getText('stat_capital'),
                value: '${gameProvider.tbCapital.toInt()} TB', 
                icon: Icons.monetization_on_rounded,
                iconColor: const Color(0xFF00E5FF), 
              ),
              const SizedBox(height: 20),

              // 🌟 الرسم البياني المذهل لرأس المال 🌟
              Text(
                gameProvider.getText('stat_chart_title'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
                  boxShadow: [BoxShadow(color: const Color(0xFF00E5FF).withOpacity(0.1), blurRadius: 20)],
                ),
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false), // إخفاء الشبكة لجمال التصميم
                    titlesData: const FlTitlesData(show: false), // إخفاء الأرقام الجانبية
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        // تحويل قائمة التاريخ إلى نقاط للرسم البياني
                        spots: gameProvider.capitalHistory.asMap().entries.map((e) {
                          return FlSpot(e.key.toDouble(), e.value);
                        }).toList(),
                        isCurved: true, // جعل الخط منحنياً وناعماً
                        color: const Color(0xFF00E5FF), // لون نيون سماوي
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false), // إخفاء النقاط
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFF00E5FF).withOpacity(0.2), // توهج سفلي للخط
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // باقي البطاقات
              _buildStatCard(
                title: gameProvider.getText('stat_production'),
                value: '+${gameProvider.productionLevel}%',
                icon: Icons.precision_manufacturing_rounded,
                iconColor: const Color(0xFF00E5FF),
                buttonText: gameProvider.getText('btn_up_prod'),
                onUpgrade: () => gameProvider.upgradeProduction(),
              ),
              const SizedBox(height: 15),
              
              _buildStatCard(
                title: gameProvider.getText('stat_marketing'),
                value: '+${gameProvider.marketingLevel}%',
                icon: Icons.campaign_rounded,
                iconColor: const Color(0xFFFFEA00), 
                buttonText: gameProvider.getText('btn_up_mark'),
                onUpgrade: () => gameProvider.upgradeMarketing(),
              ),
              const SizedBox(height: 15),
              
              _buildStatCard(
                title: gameProvider.getText('stat_rnd'),
                value: '+${gameProvider.rndLevel}%',
                icon: Icons.biotech_rounded,
                iconColor: const Color(0xFFD500F9), 
                buttonText: gameProvider.getText('btn_up_rnd'),
                onUpgrade: () => gameProvider.upgradeRnD(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title, required String value, required IconData icon, required Color iconColor,
    String? buttonText, VoidCallback? onUpgrade,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3), 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: iconColor.withOpacity(0.5), blurRadius: 10)] 
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          if (buttonText != null && onUpgrade != null) ...[
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity, 
              child: ElevatedButton(
                onPressed: onUpgrade,
                style: ElevatedButton.styleFrom(
                  backgroundColor: iconColor.withOpacity(0.8),
                  elevation: 5,
                  shadowColor: iconColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(buttonText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ]
        ],
      ),
    );
  }
}