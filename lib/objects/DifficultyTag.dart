import './Tag.dart';

class DifficultyTag extends Tag {        
  static const String mName = 'Difficult';
  static const double mPriceMultiplier = 1.25;
  static const Duration mDuration = Duration(minutes: 10);

  DifficultyTag(double price) : super(mName, mPriceMultiplier, mDuration, price);
}