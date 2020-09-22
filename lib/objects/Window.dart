import 'package:flutter/foundation.dart';

class Window {
  final double price;
  final double time;
  final String name;

  double count;

  Window({@required this.price, @required this.time, @required this.name}) {
    count = 0;
  }

  getPrice() {
    return price;
  }

  getTime() {
    return time;
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
