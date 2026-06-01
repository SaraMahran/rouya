

class CategoryModel {
  final String id;
  String name;
  String emoji;
  int count;
  String color; // 'accent', 'accent2', or 'gold'
  List<CategoryEntry> entries;

  CategoryModel({
    required this.id,
    required this.name,
    required this.emoji,
    this.count = 0,
    this.color = 'accent',
    List<CategoryEntry>? entries,
  }) : entries = entries ?? [];
}

class CategoryEntry {
  final String date;
  final String note;

  CategoryEntry({required this.date, this.note = ''});
}