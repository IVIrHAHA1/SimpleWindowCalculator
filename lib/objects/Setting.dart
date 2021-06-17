class Setting {
  String title;
  String subtitle;
  var value;
  bool editable;

  Setting({
    this.title,
    this.subtitle = '',
    this.value,
    this.editable = false,
  });
}
