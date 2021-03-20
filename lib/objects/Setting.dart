class Setting {
  String title;
  String subtitle;
  num value;
  bool editable;

  Setting({
    this.title,
    this.subtitle,
    this.value = 0,
    this.editable = false,
  });
}
