class ItemsManager {
  ItemsManager._();
  static ItemsManager instance = ItemsManager._();
}

mixin Item {
  int itemId;
}