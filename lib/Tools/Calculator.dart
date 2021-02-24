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

    return _instance;
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
      item.update();
      itemTotalPrice += item._totalPrice;
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
      projectPrice = itemTotalPrice + DRIVETIME;

      // Round up to an increment of 5, for pricing simplicity
      var temp = projectPrice % 5;
      if (temp != 0) {
        projectPrice += (5 - temp);
      }

      // Ensure price is not below minimum
      if (projectPrice < PRICE_MIN) {
        projectPrice = PRICE_MIN;
      }

      projectDuration = time;
    }

    // Notify of updated results
    if (isListening) notifyListeners();
  }

  static const double pricePerHour = 85;
  _priceDueToTime(Duration totalDuration) {
    var duration = totalDuration.inSeconds / 3600;
    return pricePerHour * duration;
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
