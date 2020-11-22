import 'package:SimpleWindowCalculator/widgets/FactorCoin.dart';

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
  var _grandTotal;
  var _grandDuration;

  Map<Factors, Factor> factorList = Map();

  Window({this.price = 0.0, this.duration, this.name, this.image}) {
    this._grandTotal = 0.0;
    this._grandDuration = Duration();
    _initFactors();
  }

/*
 * This update method syncs and calculates this window object
 * to reflect correct pricing, quantaties and durations when   
 * all factors are taken into account.   
 */
  void update() {
    var totalPrice = 0.0;
    var totalTime = Duration();

    factorList.forEach((factorKey, factor) {
      // Step 1: Ensure accurate factor quantaties
      if (factor.getCount() > this.getCount()) {
        factor.setCount(this.getCount());
      }

      // Step 2: Calculate Factor price modifier
      totalPrice += factor.calculatePrice(this.getPrice());
      totalTime += factor.calculateDuration(this.getDuration());
    });

    // Step 3: Add total standard price
    totalPrice += this.getPrice() * this.getCount();
    totalTime += this.getDuration() * this.getCount();
    _grandTotal = totalPrice;
    _grandDuration = totalTime;
  }

  /*
   * This method has been replaced by amendcount().
   * Sets window count to passed var
   */
  @deprecated
  setCount({double count}) {
    // Keep window count updating here
    this.count = count;
    if (this.count < 0) this.count = 0;
  }

  /*
   *  Adds 'count' to existing count qty
   */
  amendCount(double count) {
    this.count = this.getCount() + count;
    // Do not count below zero
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
      else if (factor.isAffixed() && countingExt)
        factor.setCount(factor.getCount() + (count / 2));
    });
  }

  /*  -----------------------------------------------------------------------
   *                              GETTER METHODS
   *  -------------------------------------------------------------------- */
  getName() {
    return name != null ? name : _mNAME;
  }

  getCount() {
    return this.count != null ? this.count : 0.0;
  }

  getPrice() {
    return price != null ? price : _mPRICE;
  }

  getPicture() {
    return this.image != null
        ? this.image
        : Image.asset('assets/images/standard_window.png');
  }

  getDuration() {
    return duration != null ? duration : _mDURATION;
  }

  grandTotal() {
    return _grandTotal;
  }

  getTotalDuration() {
    return _grandDuration;
  }

  /*  -----------------------------------------------------------------------
   *                              FACTOR METHODS
   *  -------------------------------------------------------------------- */
  Factor getFactor(Factors factorKey) {
    return factorList[factorKey];
  }

  _initFactors() {
    for (Factors value in Factors.values) {
      _addFactor(value);
    }
  }

  /*
   * affixFactor allows the factor to count along with the window count.
   */
  affixFactor(Factors factorKey, bool affix) {
    factorList[factorKey].affix(affix);
  }

  _addFactor(Factors factorKey) {
    factorList.putIfAbsent(
        factorKey, () => OManager.getFactorInstance(factorKey));
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

  resetFactors() {
    for (Factors factorKey in Factors.values) {
      factorList[factorKey].setCount(0);
      factorList[factorKey].affix(false);
      factorModeList[factorKey](true);
    }
  }

  Map<Factors, Function> factorModeList = Map();

  // Registers a quick-action listener. Useful for reseting factor list.
  registerFactorQAListener(Factors key, Function setMode) {
    factorModeList.containsKey(key)
        ? factorModeList[key] = setMode
        : factorModeList.putIfAbsent(key, () => setMode);
  }
}
