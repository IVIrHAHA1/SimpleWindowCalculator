import './Tag.dart';

class OneSideTag extends Tag {        
  static const String mName = 'Exterior Only';
  static const double mPriceMultiplier = .6;
  static const Duration mDuration = Duration(minutes: 10);

  OneSideTag(double price) : super(mName, mPriceMultiplier, mDuration, price);
}
