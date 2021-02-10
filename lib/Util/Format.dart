class Format {
  static format(double n, int places) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : places);
  }

  static formatTime(Duration d) =>
      d.toString().split('.').first.split(':').take(2).join(":");
}
