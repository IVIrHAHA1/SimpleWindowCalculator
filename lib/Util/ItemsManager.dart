class ItemsManager {
  ItemsManager._();
  static ItemsManager _instance;

  List<Item> itemsList = List();
  Item _activatedItem;

  static ItemsManager get instance {
    if (_instance == null) _instance = ItemsManager._();

    return _instance;
  }

  set activeItem(Item item) {
    try {
      this._activatedItem = itemsList.singleWhere(
        (element) => element.itemId == item.itemId,
        orElse: () {
          itemsList.add(item);
          return item;
        },
      );
    } catch (StateError) {
      throw StateError(
          "more than one item was put into itemsList. Verify logical error");
    }
  }

  get activeItem => _activatedItem;
}

mixin Item {
  int itemId;

  @override
  bool operator ==(other) {
    print('checking this');
    return (other is Item) && other.itemId == this.itemId;
  }

  @override
  int get hashCode => super.hashCode;
}
