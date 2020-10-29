import 'package:flutter/material.dart';

class Factor {
  final String name;
  final double priceMultiplier;
  final double durationMultiplier;

  final Widget image;

  bool active = false;

  double count;

  Factor(
      {@required this.name,
      @required this.priceMultiplier,
      @required this.durationMultiplier,
      this.image});

  String getName() {
    return name;
  }

  double getUpdatedPrice(double windowPrice) {
    return windowPrice * priceMultiplier;
  }

  Duration getDuration(Duration windowDuration) {
    return windowDuration * durationMultiplier;
  }

  Widget getImage() {
    return image == null ? Icons.not_interested : image;
  }

  void enable(bool activate) => active = activate;

  bool isActive() {
    return this.active;
  }

  void setCount(double count) {
    this.count = count;
  }

  double getCount() {
    return this.count != null ? count : 0;
  }

  Factor copy() {
    return new Factor(
      name: name,
      priceMultiplier: priceMultiplier,
      durationMultiplier: durationMultiplier,
    );
  }
}
