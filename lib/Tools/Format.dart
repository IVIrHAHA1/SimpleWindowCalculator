class Format {
  static format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  static formatTime(Duration d) =>
      d.toString().split('.').first.split(':').take(2).join(":");
}
