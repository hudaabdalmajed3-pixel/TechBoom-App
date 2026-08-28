import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class AuctionScreen extends StatelessWidget {
  const AuctionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // 🌟 شريط الرصيد
              Container(
                height: 65,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF007BFF), Color(0xFF00C3FF)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF007BFF).withOpacity(0.3), 
                      blurRadius: 15, 
                      offset: const Offset(0, 5)
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2), 
                            shape: BoxShape.circle
                          ),
                          child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          game.isArabic ? 'رصيد المزاد' : 'Auction Balance',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      '${game.auctionBalance.toInt()} TB',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // 🌟 العنوان
              Text(
                game.getText('nav_auction'),
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), letterSpacing: 1),
              ),
              const SizedBox(height: 8),
              Text(
                game.getText('auction_subtitle'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 35),
              
              // 🌟 كروت القدرات المربوطة بحالة الاستخدام في المزود
              _buildAbilityCard(
                title: game.getText('ab_reveal_title'), 
                cost: 50, 
                desc: game.getText('ab_reveal_desc'),
                icon: Icons.visibility_rounded, 
                abilityId: 'reveal', 
                isUsed: game.isRevealUsed, 
                game: game, 
                context: context,
              ),
              _buildAbilityCard(
                title: game.getText('ab_disable_title'), 
                cost: 100, 
                desc: game.getText('ab_disable_desc'),
                icon: Icons.do_not_disturb_on_rounded, 
                abilityId: 'disable', 
                isUsed: game.isDisableUsed, 
                game: game, 
                context: context,
              ),
              _buildAbilityCard(
                title: game.getText('ab_withdraw_title'), 
                cost: 200, 
                desc: game.getText('ab_withdraw_desc'),
                icon: Icons.flash_on_rounded, 
                abilityId: 'withdraw', // تم التصحيح ليتطابق مع الـ provider
                isUsed: game.isWithdrawUsed, // تم التصحيح ليتطابق مع الـ provider
                game: game, 
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🌟 دالة بناء كروت المزاد
  Widget _buildAbilityCard({
    required String title, required int cost, required String desc, 
    required IconData icon, required String abilityId, required bool isUsed, 
    required GameProvider game, required BuildContext context
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // تغيير لون الحدود إذا تم الاستخدام
        border: Border.all(color: isUsed ? Colors.grey.shade300 : const Color(0xFF007BFF).withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUsed ? Colors.grey.shade200 : const Color(0xFF007BFF).withOpacity(0.1), 
              shape: BoxShape.circle
            ),
            child: Icon(icon, color: isUsed ? Colors.grey : const Color(0xFF007BFF), size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isUsed ? Colors.grey : const Color(0xFF0F172A))
                ),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            // تعطيل الزر (null) إذا تم الاستخدام مسبقاً
            onPressed: isUsed ? null : () {
              bool success = game.useAbility(abilityId, cost);
              if (!success) {
                // رسالة خطأ إذا كان الرصيد لا يكفي
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(game.isArabic ? 'رصيد المزاد غير كافٍ' : 'Insufficient Auction Balance'), 
                    backgroundColor: Colors.redAccent
                  )
                );
              } else {
                 // رسالة نجاح (اختيارية، بما أن الزر سيتعطل تلقائياً)
                 ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(game.isArabic ? 'تم تفعيل القدرة بنجاح!' : 'Ability activated successfully!'), 
                    backgroundColor: Colors.green
                  )
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isUsed ? Colors.grey.shade400 : const Color(0xFF007BFF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: Text(
              isUsed ? game.getText('btn_used') : '${game.getText('btn_activate')} ($cost)',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}