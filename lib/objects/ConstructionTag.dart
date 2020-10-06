import './Tag.dart';

class ConstructionTag extends Tag {        
  static const String mName = 'Construction Clean Up';
  static const double mPriceMultiplier = 2;
  static const Duration mDuration = Duration(minutes: 10);

  ConstructionTag(double price) : super(mName, mPriceMultiplier, mDuration, price);
}