class PlayerState {
  // الأرصدة الأساسية
  double auctionBalance = 200.0; 
  double investmentCapital = 0.0; 

  // مؤشرات المشروع
  double productionLevel = 0.0;
  double developmentLevel = 0.0;
  double marketingLevel = 0.0;

  // تكاليف القدرات التنافسية
  final double revealInfoCost = 50.0;
  final double disablePlayerCost = 100.0;
  final double instantFundingCost = 200.0;

  // دالة الخصم
  bool useAbility(double cost) {
    if (auctionBalance >= cost) {
      auctionBalance -= cost;
      return true;
    }
    return false;
  }
}