class SpendCategory {
  String name;
  String identity;

  int totalSpendindCount;

  SpendCategory({
    required this.name,
    required this.identity,
    this.totalSpendindCount = 0,
  });
}
