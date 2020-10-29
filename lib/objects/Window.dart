import 'Factor.dart';

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

  Map<Factor, double> tagList;

  Window({this.price, this.duration, this.name, this.image}) {
    this.count = 0.0;
  }

  incrementTag(Factor factor) {
    tagList.containsKey(factor)
        ? tagList.update(factor, (value) => value + 1)
        : tagList.putIfAbsent(factor, () => 1);
        
    print(name +
        ' now has ' +
        '${tagList[factor]} ' +
        factor.getName() +
        ' factors');
  }

  // TODO: Logic for negative count
  decrementTag(Factor factor) {
    tagList.containsKey(factor)
        ? tagList.update(factor, (value) => value - 1)
        : tagList.putIfAbsent(factor, () => 0);
        
    print(name +
        ' now has ' +
        '${tagList[factor]} ' +
        factor.getName() +
        ' factors');
  }

  getTagCount(Factor factor) {
    return tagList[factor];
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
  // iterate through each tag, the performance of the app will improve.

  getTotal() {
    var standardTotal = (this.getPrice() * this.getCount());
    return standardTotal;
  }

  getDuration() {
    return duration != null ? duration : _mDURATION;
  }

  getTotalDuration() {
    return this.getDuration() * count;
  }

  getPicture() {
    return this.image != null
        ? this.image
        : Image.asset('assets/images/standard_window.png');
  }

  /*
   * Indicate what tag if any is also being added
   */
  setCount({double count, String tagName}) {
    // Keep window count updating here
    this.count = count;
  }

  getCount() {
    return this.count != null ? this.count : 0.0;
  }
}
