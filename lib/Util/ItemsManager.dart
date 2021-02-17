/// Manages "active items" and puts forth an active item, which can then be interfaced with.
///
/// - "active items" or [itemsList] is a list of type [T] which is nothing more than a list
///   of previous active items.
///
///   ** (See [ItemsManager.init()] to learn how to instantiate [itemsList])
///
///
/// - To add [Item]s to the [ItemsManager], simply assign any new [Item] to [activeItem].
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

  /// This must be called before using any aspect of the ItemsManger class.
  /// To initiate the ItemsManager class use:
  /// ```dart
  /// // Type is any class which implements the Item mixin
  /// ItemsManager.init<Type>();
  /// ```
  static init<T>() {
    _instance = ItemsManager._();
    _instance._itemsList = List<T>();
  }

  /// Clears the list and sets [activeItem] to the optional [setActiveItem]
  reset({Item setActiveItem}) {
    this._itemsList.clear();
    this.activeItem = setActiveItem;
  }

  ///Removes [Item] and returns the removed item.
  ///
  ///If no item was found, returns null
  remove(Item item) {
    // Removing with index to keep the List.length true.
    // Otherwise, by using the List.remove method, the list will contain null elements.
    int index = _itemsList.indexOf(item);
    if (index >= 0) {
      return _itemsList.removeAt(index);
    } else
      return null;
  }

  /// Adds an Item to the list, but does not make it active.
  /// Returns true if [Item] is not already in the list. Otherwise,
  /// returns false, if [Item] is already in the list.
  bool add(Item item) {
    if (!_itemsList.contains(item)) {
      _itemsList.add(item);
      return true;
    } else
      return false;
  }

  /// Discards [activeItem] from the [itemsList] and sets [activeItem] to null.
  discardActiveItem() {
    // Removing with index to keep the List.length true.
    // Otherwise, by using the List.remove method, the list will contain null elements.
    int index = _itemsList.indexOf(_activatedItem);
    if (index >= 0) {
      _itemsList.removeAt(index);
      _activatedItem = null;
    }
  }

  /// Set the active item, which can then be interfaced with. When setting [activeItem]
  /// [ItemsManager] searches the [items] list and will add the new activated item, if no
  /// such instance was found.
  ///
  /// In the case where the newly [activatedItem] does already exist, the instance from
  /// [items] list will be returned. Thus, only a single instance of [Item] can exist.
  set activeItem(Item item) {
    if (_itemsList.contains(item)) {
      try {
        this._activatedItem =
            _itemsList.singleWhere((element) => element == item);
      } catch (StateException) {
        throw Exception(
            'More than one item was found in itemList, check logical error');
      }
    } else {
      _itemsList.add(item);
      _activatedItem = item;
    }
  }

  /// Set the active item, which can then be interfaced with. When setting [activeItem]
  /// [ItemsManager] searches the [items] list and will add the new activated item, if no
  /// such instance was found.
  ///
  /// In the case where the newly [activatedItem] does already exist, the instance from
  /// [items] list will be returned. Thus, only a single instance of [Item] can exist.
  get activeItem => _activatedItem;

  /// All activated items list
  get items => _itemsList;
}

/// Interface which allows for the intefacing of ItemsManager.
mixin Item {
  get itemId;

  @override
  bool operator ==(other) {
    return (other is Item) && other.itemId == this.itemId;
  }

  @override
  int get hashCode => super.hashCode;
}
