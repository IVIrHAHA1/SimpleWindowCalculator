import 'dart:convert';
import 'dart:io';

import 'package:SimpleWindowCalculator/Tools/Calculator.dart';
import 'package:SimpleWindowCalculator/Tools/DatabaseProvider.dart';
import 'package:SimpleWindowCalculator/Util/ItemsManager.dart';

import '../objects/Factor.dart';
import '../objects/OManager.dart';

class Window with Calculatable, Item {
  // Default Values
  static const double _mPRICE = 12;
  static const String _mNAME = 'unnamed';
  static const Duration _mDURATION = Duration(minutes: 10);

  String name;
  File image;

  /// Set at runtime
  Map<Factors, Factor> factorList = Map();

  Window({double price = 0.0, Duration duration, this.name, this.image}) {
    this.quantity = 0.0;
    this.price = price ?? _mPRICE;
    this.duration = duration ?? _mDURATION;

    this.totalPrice = 0.0;
    this.totalDuration = Duration();
    _initFactors();
  }

  /// Keys to be used with json
  static String _nameKey = 'NameKey';
  static String _priceKey = 'PriceKey';
  static String _durationKey = 'DurationKey';
  static String _imageFilePath = 'ImageKey';

  Map<String, dynamic> toJson() {
    return {
      _priceKey: price,
      _nameKey: name,
      _durationKey: duration.inSeconds,
      _imageFilePath: image.path,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      WINDOW_NAME_ID: this.name,
      WINDOW_OBJECT: jsonEncode(this),
    };
  }

  Window.fromMap(Map jsonMap) {
    this.price = jsonMap[_priceKey];
    this.name = jsonMap[_nameKey];
    this.duration = Duration(seconds: jsonMap[_durationKey]);
    this.image = File(jsonMap[_imageFilePath]);

    this.quantity = 0.0;
    this.totalPrice = 0.0;
    this.totalDuration = Duration();
    _initFactors();
  }

  @override
  get itemId => this.name.toLowerCase().hashCode;

/*
 * This update method syncs and calculates this window object
 * to reflect correct pricing, quantaties and durations when   
 * all factors are taken into account.   
 */
  @override
  void update() {
    var granPrice = 0.0;
    var totalTime = Duration();

    factorList.forEach((factorKey, factor) {
      // Step 1: Ensure accurate factor quantaties
      if (factor.getCount() > this.quantity) {
        factor.setCount(this.quantity);
      }

      // Step 2: Calculate Factor price modifier
      granPrice += factor.calculatePrice(this.price);
      totalTime += factor.calculateDuration(this.duration);
    });

    // Step 3: Add total standard price
    granPrice += this.price * this.quantity;
    totalTime += this.duration * this.quantity;
    this.totalPrice = granPrice;
    this.totalDuration = totalTime;
  }

  /*
   * This method has been replaced by amendcount().
   * Sets window count to passed var
   */
  setCount({double count}) {
    // Keep window count updating here
    this.quantity = count;
    if (this.quantity < 0) this.quantity = 0;
  }

  /*
   *  Adds 'count' to existing count qty
   */
  amendCount(double count) {
    this.quantity = this.quantity + count;
    // Do not count below zero
    if (this.quantity < 0) this.quantity = 0.0;

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
  setName(String name) {
    this.name = name;
  }

  setImage(File image) {
    this.image = image;
  }

  getName() {
    return name != null ? name : _mNAME;
  }

  /// Returns a file of the image, use [ImageLoader.fromFile] to load this
  /// approriately.
  getImage() {
    return this.image;
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
    if (factor.getCount() < this.quantity && factorKey != Factors.sided)
      factor.setCount(factor.getCount() + .5);
    else if (factor.getCount() < this.quantity && factorKey == Factors.sided)
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
