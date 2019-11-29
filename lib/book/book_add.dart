class BookDetailToAdd {
  final String ISBN;
  final String title;
  final String description;

  BookDetailToAdd({
    this.ISBN,
    this.title,
    this.description,
  });

  factory BookDetailToAdd.fromJson(Map<String, dynamic> json) {
    return new BookDetailToAdd(
      title: json['title'],
      ISBN: json['ISBN'].toString(),
      description: json['description'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['title'] = title;
    map['ISBN'] = ISBN;
    map['description'] = description;

    return map;
  }
}

class BookAddException implements Exception {
  String errorMessage() {
    return 'Failed to add book.';
  }
}
