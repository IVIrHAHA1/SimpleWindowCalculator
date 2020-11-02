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
    if (factor.getCount() < this.getCount())
      factor.setCount(factor.getCount() + 1);
  }

  /*
   * Quick-Action - decrement factor count
   */
  decrementFactor(Factors factorKey) {
    Factor factor = factorList[factorKey];

    // Only decrement if factor count is greater than 0
    if (factor.getCount() > 0) factor.setCount(factor.getCount() - 1);
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
    var standardWindowCount;
    var totalPrice = 0.0;
    var totalTime = Duration();

    factorList.forEach((key, value) {
      // Step 1: Update to correct numbers
      if (value.getCount() > this.getCount()) {
        value.setCount(this.getCount());
      }
    });
  }

  getTotal() {
    var standardWindowCount = this.getCount();
    var totalPrice = 0.0;

    // Subtract amount of modified windows and replace with modified price
    // factorList.forEach((key, value) {
    //   standardWindowCount -= value.getCount();
    //   totalPrice += value.getUpdatedPrice(this.getPrice());
    // });

    // Take remaining window count and charge at standard rate
    totalPrice += standardWindowCount * this.getPrice();

    return totalPrice;
  }

  getDuration() {
    return duration != null ? duration : _mDURATION;
  }

  getTotalDuration() {
    var standardWindowCount = this.getCount();
    var totalTime = Duration(minutes: 0);

    // Subtract amount of modified windows, and replace with modified price
    // factorList.forEach((key, value) {
    //   standardWindowCount -= value.getCount();
    //   totalTime += value.getDuration(this.getDuration()) * value.getCount();
    // });

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

    factorList.forEach((key, value) {
      if (value.isAffixed()) value.setCount(value.getCount() + count);
    });
  }

  getCount() {
    return this.count != null ? this.count : 0.0;
  }
}
