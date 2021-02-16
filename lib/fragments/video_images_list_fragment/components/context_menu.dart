
class MenuItemAssetList {
  static const SortByDate = MenuItemAssetList._('Sort By Date');
  static const SortByType = MenuItemAssetList._('Sort By Type');
  static const values = [
    SortByDate,
    SortByType,
  ];

  const MenuItemAssetList._(this.text);

  final String text;
}
