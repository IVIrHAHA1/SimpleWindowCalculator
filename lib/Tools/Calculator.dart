import 'package:shared_preferences/shared_preferences.dart';
import '../objects/OManager.dart' as s;

import '../GlobalValues.dart';
/* ***DEVELOPER'S NOTE: 
* This class can be further abstracted, by 
* making Calculatable take charge of the update()
* method.
*/

/// A singleton class which calculates the totals of the project.
/// 1. Total Count  [projectCount]
/// 2. Total Price  [projectPrice]
/// 3. Total Duration [projectDuration]
///
/// Can attach notifiers which will update any UI compontents.
class Calculator with Notifier {
  double projectCount = 0;
  double projectPrice = 0;
  Duration projectDuration = Duration();

  List<Calculatable> projectItems;

  Calculator._();
  static Calculator _instance;

  static Calculator get instance {
    if (_instance == null) {
      _instance = Calculator._();
    }

    _instance.updateDefaults();

    return _instance;
  }

  double driveTime;
  double minPrice;
  double targetRate;

  Future<void> updateDefaults() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String key;

    key = s.settingsList[s.DefaultSettings.targetProduction].title;
    targetRate = preferences.getDouble(key) ?? TARGET_HOURLY_RATE;

    key = s.settingsList[s.DefaultSettings.minPrice].title;
    minPrice = preferences.getDouble(key) ?? PRICE_MIN;

    key = s.settingsList[s.DefaultSettings.driveTime].title;
    driveTime = preferences.getDouble(key) ?? DRIVETIME;
  }

  /// Performs calculations on objects and thus updates
  /// - [projectCount]
  /// - [projectPrice]
  /// - [projectDuration]
  update() {
    if (projectItems == null) {
      throw Exception('NEED TO ASSIGN [projectItems]');
    }
    // Calculate price before adjustments
    var itemTotalPrice = 0.0;
    projectCount = 0.0;
    Duration time = Duration();

    for (Calculatable item in projectItems) {
      item.price = _priceDueToTime(item.duration);

      item.update();
      itemTotalPrice += item.price;
      projectCount += item.quantity;
      time += item.totalDuration;
    }

    /// If all window have no price or time totals then
    /// set values to zero
    if (itemTotalPrice == 0.0) {
      projectPrice = 0.0;
      projectDuration = Duration();
    } else {
      var hourlyPrice = _priceDueToTime(time);
      if (itemTotalPrice < hourlyPrice) {
        itemTotalPrice = hourlyPrice;
      }

      // Add Drive time
      projectPrice = itemTotalPrice + driveTime;

      // Round up to an increment of 5, for pricing simplicity
      var temp = projectPrice % 5;
      if (temp != 0) {
        projectPrice += (5 - temp);
      }

      // Ensure price is not below minimum
      if (projectPrice < minPrice) {
        projectPrice = minPrice;
      }

      if (projectCount <= 0) projectPrice = 0;
      projectDuration = time;
    }

    // Notify of updated results
    if (isListening) notifyListeners();
  }

  _priceDueToTime(Duration totalDuration) {
    var duration = totalDuration.inSeconds / 3600.0;
    return targetRate * duration;
  }
}

/// Implementing the Calculatable mixin allows for Calculator interfacing.
mixin Calculatable {
  var quantity;
  double price;
  Duration duration;

  Duration totalDuration;
  double _totalPrice;

  update();

  get totalPrice => _totalPrice <= 0 ? 0.0 : _totalPrice;
  set totalPrice(total) => _totalPrice = total;
}

/// Notifies any attached listeners
mixin Notifier {
  List<Function> _listeners = List();

  notifyListeners() {
    for (Function listener in _listeners) {
      listener();
    }
  }

  addListener(Function listener) {
    _listeners.add(listener);
  }

  bool get isListening => _listeners.isNotEmpty;
}
