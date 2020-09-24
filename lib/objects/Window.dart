class Window {
  static const double mPRICE = 12;
  static const String mNAME = 'Standard Window';
  static const Duration mDURATION = Duration(minutes: 10);

  final double price;
  final String name;
  final Duration duration;

  double count;

  Window({this.price, this.duration, this.name}) {
    count = 0;
  }

  getName() {
    return name != null ? name : mNAME; 
  }

  getPrice() {
    return price != null ? price : mPRICE;
  }

  getDuration() {
    return duration != null ? duration : mDURATION;
  }

  getTotalDuration() {
    return this.getDuration() * count;
  }

  getTotal() {
    return this.getPrice() * count;
  }

  setCount(double count) {
    this.count = count;
  }

  getCount() {
    return count;
  }
}
