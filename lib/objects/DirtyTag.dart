import './Tag.dart';

class DirtyTag extends Tag {        
  static const String mName = 'Extra Dirty';
  static const double mPriceMultiplier = 1.5;
  static const Duration mDuration = Duration(minutes: 10);

  DirtyTag(double price) : super(mName, mPriceMultiplier, mDuration, price);
}