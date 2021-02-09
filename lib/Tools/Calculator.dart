import 'GlobalValues.dart';

/// A singleton class which calculates the totals of the project.
/// 1. Total Count  [projectCount]
/// 2. Total Price  [projectPrice]
/// 3. Total Duration [projectDuration]
///
/// Can attach notifiers which will update any UI compontents.
class Calculator with Notifier {
  static double projectCount = 0;
  static double projectPrice = 0;
  static Duration projectDuration = Duration();

  static List<Calculatable> projectItems = List();

  Calculator._();
  static final Calculator instance = Calculator._();

  calculateResults() {
    // Calculate price before adjustments
    var windowPriceTotal = 0.0;
    projectCount = 0.0;
    Duration time = Duration();

    for (Calculatable window in projectItems) {
      window.update();
      windowPriceTotal += window.totalPrice;
      projectCount += window.quantity;
      time += window.totalDuration;
    }

    /// If all window have no price or time totals then
    /// set values to zero
    if (windowPriceTotal == 0.0) {
      projectPrice = 0.0;
      projectDuration = Duration();
    } else {
      // Add Drive time
      projectPrice = windowPriceTotal + DRIVETIME;

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
    notifyListeners();
  }
}

mixin Calculatable {
  var quantity;

  double price;
  double totalPrice;
  Duration duration;
  Duration totalDuration;

  update();
}

/// Notifies any attached listeners
mixin Notifier {
  List<Function> _listeners = List();

  notifyListeners() {
    for (Function listener in _listeners) {
      listener();
    }
  }

  attachListener(Function listener) {
    _listeners.add(listener);
  }
}
