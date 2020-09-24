import 'package:flutter/foundation.dart';

class Window {
  final double price;
  final double time;
  final String name;

  double count;
  Duration duration;

  Window({@required this.price, @required this.time, @required this.name}) {
    count = 0;
    duration = Duration(minutes: 10);
  }

  getPrice() {
    return price;
  }

  getDuration() {
    return duration;
  }

  getName() {
    return name;
  }

  setCount(double count) {
    this.count = count;
  }

  getCount() {
    return count;
  }
}
