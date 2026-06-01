class QuoteModel {
  final String id;
  final String text;
  final String author;
  final String? book;   // nullable — some quotes have no book
  final String category;
  bool favorite;

  QuoteModel({
    required this.id,
    required this.text,
    required this.author,
    this.book,
    this.category = 'Uncategorized',
    this.favorite = false
  });

  // Convert from Supabase JSON to QuoteModel
  factory QuoteModel.fromJson(Map<String, dynamic> json) => QuoteModel(
    id:             json['id'].toString(),
    text:           json['text'],
    author:         json['author'],
    book:           json['book'],
    category:       json['category'] ?? 'Uncategorized',
    favorite:       json['favorite'] ?? false,
  );
}

