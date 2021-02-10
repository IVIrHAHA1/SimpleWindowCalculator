class ItemsManager {
  ItemsManager._();
  static ItemsManager _instance;

  List itemsList;
  Item _activatedItem;

  static ItemsManager get instance {
    if (_instance == null) {
      throw Exception('Failed to initialize ItemsManager');
    }

    return _instance;
  }

  static init<T>() {
    _instance = ItemsManager._();
    _instance.itemsList = List<T>(); 
  }

  discardActiveItem() {
    itemsList.remove(activeItem);
  }

  set activeItem(Item item) {
    if (itemsList.contains(item)) {
      try {
        this._activatedItem =
            itemsList.singleWhere((element) => element == item);
      } catch (StateException) {
        throw Exception('More than one item was found in itemList');
      }
    } else {
      itemsList.add(item);
      _activatedItem = item;
    }
  }

  get activeItem => _activatedItem;
}

mixin Item {
  int itemId;

  @override
  bool operator ==(other) {
    return (other is Item) && other.itemId == this.itemId;
  }

  @override
  int get hashCode => super.hashCode;
}
