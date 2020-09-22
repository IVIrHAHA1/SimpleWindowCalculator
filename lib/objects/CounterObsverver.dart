import 'dart:collection';

import 'package:flutter/foundation.dart';

class CounterObserver {
  HashMap<String, CountObserver> observerList;

  CounterObserver() {
    observerList = new HashMap();
  }

// TODO: Handle collisions
  void subscribe(String key, CountObserver newSubscriber) {
    observerList.putIfAbsent(key, () => newSubscriber);
  }

  void unsubscribe(String key) {
    observerList.remove(key);
  }

  void notify(String key, double count) {
    CountObserver subscriber =  observerList.putIfAbsent(key, () => null);

    subscriber.updateCount(count);
  }
}

mixin CountObserver <T>{
  void updateCount(double count);
}