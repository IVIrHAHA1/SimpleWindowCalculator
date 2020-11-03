import 'package:flutter/material.dart';

class Factor {
  final factorKey;
  final String name;
  final double priceMultiplier;
  final double durationMultiplier;

  final Widget image;

  bool affixed = false;

  double count = 0;

  Factor({
    @required this.factorKey,
    @required this.name,
    @required this.priceMultiplier,
    @required this.durationMultiplier,
    this.image,
  });

  String getName() {
    return name;
  }

  /*
   * Returns the total price this factor produces
   */
  double getUpdatedPrice(double windowPrice) {
    return windowPrice * (priceMultiplier - 1.0) * count;
  }

  Duration getDuration(Duration windowDuration) {
    return windowDuration * durationMultiplier;
  }

  Widget getImage() {
    return image == null ? Icons.not_interested : image;
  }

  void affix(bool affix) => affixed = affix;

  bool isAffixed() {
    return this.affixed;
  }

  void setCount(double count) {
    this.count = count;

    if (this.count <= 0) this.count = 0;
  }

  double getCount() {
    return this.count != null ? count : 0;
  }

  getMultiplier() {
    return this.priceMultiplier;
  }

  getKey() {
    return factorKey;
  }

  Factor copy() {
    return new Factor(
        factorKey: factorKey,
        name: name,
        priceMultiplier: priceMultiplier,
        durationMultiplier: durationMultiplier,
        image: image);
  }
}
