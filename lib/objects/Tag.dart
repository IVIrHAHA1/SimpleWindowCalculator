abstract class Tag {
  final String name;
  final double priceMultiplier;
  final Duration duration;

  bool active = false;
  double count;
  final double windowPrice;

  Tag(this.name, this.priceMultiplier, this.duration, this.windowPrice);

  String getName() {
    return name;
  }

  double getTotal() {
    var total = ((priceMultiplier * windowPrice) - windowPrice) * this.getCount();

    return total != null ? total : 0;
  }

  Duration getDuration() {
    return duration;
  }

  double getCount() {
    return count != null ? count : 0;
  }

  setCount(double count) {
    this.count = count;
  }

  enable(bool activate) => active = activate;

  bool isActive() {return this.active;}
}
