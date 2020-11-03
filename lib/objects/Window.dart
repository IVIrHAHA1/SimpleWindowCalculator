import '../objects/Factor.dart';
import '../objects/OManager.dart';

import 'package:flutter/material.dart';

class Window {
  // TODO: add an 'image not found' image

  // Default Values
  static const double _mPRICE = 12;
  static const String _mNAME = 'Standard Window';
  static const Duration _mDURATION = Duration(minutes: 10);

  final double price;
  final String name;
  final Duration duration;
  final Image image;

  double count;

  Map<Factors, Factor> factorList = Map();

  Window({this.price, this.duration, this.name, this.image}) {
    this.count = 0.0;
    _initFactors();
  }

  _initFactors() {
    for (Factors value in Factors.values) {
      addFactor(value);
    }
  }

  /*
   * Quick-Action - increment factor count
   */
  incrementFactor(Factors factorKey) {
    Factor factor = factorList[factorKey];

    // Only increment if factor count is less than the number of windows.
    if (factor.getCount() < this.getCount() && factorKey != Factors.sided)
      factor.setCount(factor.getCount() + .5);
    else if (factor.getCount() < this.getCount() && factorKey == Factors.sided)
      factor.setCount(factor.getCount() + 1);
  }

  /*
   * Quick-Action - decrement factor count
   */
  decrementFactor(Factors factorKey) {
    Factor factor = factorList[factorKey];

    // Only decrement if factor count is greater than 0
    if (factor.getCount() > 0 && factorKey != Factors.sided)
      factor.setCount(factor.getCount() - .5);
    else if (factor.getCount() > 0 && factorKey == Factors.sided)
      factor.setCount(factor.getCount() - 1);
  }

  /*
   * affix Factor allows the factor to count along with the window count.
   */
  affixFactor(Factors factorKey, bool affix) {
    factorList[factorKey].affix(affix);
  }

  addFactor(Factors factorKey) {
    factorList.putIfAbsent(
        factorKey, () => OManager.getFactorInstance(factorKey));
  }

  Factor getFactor(Factors factorKey) {
    return factorList[factorKey];
  }

  getName() {
    return name != null ? name : _mNAME;
  }

  getPrice() {
    return price != null ? price : _mPRICE;
  }

  // TODO: In the interest of performance look into making an update() method.
  // Currently, when getTotal is called the process is fairly extensive.
  // Therefore, if there is a way to determine the total without having to
  // iterate through each factor, the performance of the app will improve.

  void update() {
    var factorPriceHolder;
    var totalPrice = 0.0;
    var totalTime = Duration();

    factorList.forEach((factorKey, factor) {
      // Step 1: Ensure accurate factor quantaties
      if (factor.getCount() > this.getCount()) {
        factor.setCount(this.getCount());
      }

      // Step 2: Calculate Factor price modifier
      totalPrice += factor.getUpdatedPrice(this.getPrice());
    });

    // Step 3: Add total price
    totalPrice += this.getPrice() * this.getCount();
    print('This is the total price: ' + '$totalPrice');
  }

  getTotal() {
    var standardWindowCount = this.getCount();
    var totalPrice = 0.0;

    totalPrice += standardWindowCount * this.getPrice();

    return totalPrice;
  }

  getDuration() {
    return duration != null ? duration : _mDURATION;
  }

  getTotalDuration() {
    var standardWindowCount = this.getCount();
    var totalTime = Duration(minutes: 0);

    // Take remaining window count and charge at standard rate
    totalTime += this.getDuration() * standardWindowCount;

    return totalTime;
  }

  getPicture() {
    return this.image != null
        ? this.image
        : Image.asset('assets/images/standard_window.png');
  }

  /*
   * Indicate what tag if any is also being added
   */
  setCount({double count}) {
    // Keep window count updating here
    this.count = count;
    if (this.count < 0) this.count = 0;
  }

  amendCount(double count) {
    this.count = this.getCount() + count;
    if (this.count < 0) this.count = 0;

    bool countingExt = false;

    factorList.forEach((factorKey, factor) {
      // When sided is affixed all factors will count by .5 as
      // any other factor should only apply to one side of the window
      // and not the whole window.
      // ** The only exception to this is when the Sided Factor itself
      //    is being counted.
      countingExt = factorList[Factors.sided].isAffixed();

      if (factor.isAffixed() && !countingExt ||
          factor.isAffixed() && factor == factorList[Factors.sided])
        factor.setCount(factor.getCount() + count);
      else if (factor.isAffixed() && !countingExt)
        factor.setCount(factor.getCount() + (count / 2));
    });
  }

  getCount() {
    return this.count != null ? this.count : 0.0;
  }
}
