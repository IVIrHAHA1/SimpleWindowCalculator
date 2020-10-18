import './ConstructionTag.dart';
import './DifficultyTag.dart';
import './DirtyTag.dart';
import './OneSideTag.dart';
import './Tag.dart';

import 'package:flutter/material.dart';

class Window {
  static const String ONESIDE_TAG = OneSideTag.mName;
  static const String DIRTY_TAG = DirtyTag.mName;
  static const String DIFFICULT_TAG = DifficultyTag.mName;
  static const String CONSTRUCTION_TAG = ConstructionTag.mName;
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

  Map<String, Tag> tagList;

  Window({this.price, this.duration, this.name, this.image}) {
    this.count = 0.0;

    this.tagList = {
      ONESIDE_TAG: OneSideTag(this.price),
      DIRTY_TAG: DirtyTag(this.price),
      DIFFICULT_TAG: DifficultyTag(this.price),
      CONSTRUCTION_TAG: ConstructionTag(this.price),
    };
  }

  incrementTag(String tagName) {
    // print('found: ' + (tagList[tagName] != null ? tagList[tagName].getName() : ' element became null'));
    // tagList.update(tagName, (value) => value.setCount(value.getCount() + 1));
  }

  decrementTag(String tagName) {
    tagList.update(tagName, (value) => value.setCount(value.getCount() - 1));
  }

  clearTag(String tagName) {
    tagList.update(tagName, (value) => value.setCount(0));
  }

  getTagCount(String tagName) {
    return tagList[tagName].getCount();
  }

  getName() {
    return name != null ? name : _mNAME;
  }

  getPrice() {
    return price != null ? price : _mPRICE;
  }

  getTotal() {
    var standardTotal = this.getPrice() * this.getCount();
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
    if (tagName != null) {
      tagList.update(tagName, (value) => value.setCount(count));
    }

    // Keep window count updating here
    this.count = count;
  }

  getCount() {
    return this.count != null ? this.count : 0.0;
  }
}
