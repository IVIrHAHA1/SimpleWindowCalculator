import 'dart:collection';


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

  void notify(String key, var value) {
    // retrieve subsriber in question
    CountObserver subscriber =  observerList.putIfAbsent(key, () => null);

    subscriber.updateValue(value);
  }
}

mixin CountObserver <T>{
  void updateValue(var value);
}