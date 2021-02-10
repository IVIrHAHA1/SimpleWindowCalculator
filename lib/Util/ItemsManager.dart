/// Manages "active items" and puts forth an active item, which can then be interfaced with.
///
/// - "active items" or [itemsList] is a list of type [T] which is nothing more than a list
///   of previous active items.
///
///   ** (See [ItemsManager.init()] to learn how to instantiate [itemsList])
///
///
/// - Adding [Item]s to the [ItemsManager], simply assign any new [Item] to [activeItem].
///   This will automatically ADD-TO or RETRIEVE the [Item] to/from [itemsList].
///   Therefore, only a single instance of an [Item] can exist in the [itemsList].
///
///   ** (See [activeItem] for more details.)
///
///
/// As a singleton class, [ItemsManager] is accessable across the entire project.
class ItemsManager {
  ItemsManager._();
  static ItemsManager _instance;

  /// The list of activated items.
  List _itemsList;
  Item _activatedItem;

  /// Get the singleton instance of ItemsManger.
  static ItemsManager get instance {
    if (_instance == null) {
      throw Exception('Failed to initialize ItemsManager');
    }

    return _instance;
  }

  static init<T>() {
    _instance = ItemsManager._();
    _instance._itemsList = List<T>();
  }

  /// Clears the list and sets [activeItem] to the optional [setActiveItem]
  reset({Item setActiveItem}) {
    this._itemsList.clear();
    this.activeItem = setActiveItem;
  }

  discardActiveItem() {
    _itemsList.remove(activeItem);
    activeItem = null;
  }

  set activeItem(Item item) {
    if (_itemsList.contains(item)) {
      try {
        this._activatedItem =
            _itemsList.singleWhere((element) => element == item);
      } catch (StateException) {
        throw Exception('More than one item was found in itemList');
      }
    } else {
      _itemsList.add(item);
      _activatedItem = item;
    }
  }

  get items => _itemsList;
  get activeItem => _activatedItem;
}

mixin Item {
  get itemId;

  @override
  bool operator ==(other) {
    return (other is Item) && other.itemId == this.itemId;
  }

  @override
  int get hashCode => super.hashCode;
}
