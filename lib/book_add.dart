import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

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

Future<BookDetailToAdd> createBookToAdd(String url, Map body) async {
  final response = await http.post(url, body: body);

  if (response.statusCode == 200) {
    return BookDetailToAdd.fromJson(json.decode(response.body));
  }

  print(response.body);
  return null;
//  throw new Exception("Failed to create a post.");
}
