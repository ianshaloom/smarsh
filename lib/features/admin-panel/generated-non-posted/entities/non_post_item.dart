class Item {
  final String id;
  final String name;
  final int expectedCount;
  final int recentCount;
  int? _nonPosted;

  int get nonPosted {
    _nonPosted = recentCount - expectedCount;

    return _nonPosted!;
  }

  Item(
    this.id,
    this.name,
    this.expectedCount,
    this.recentCount,
  );
}
