import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class BookDetail {
  final String ISBN;
  final String title;
  final String description;

  BookDetail({
    this.ISBN,
    this.title,
    this.description,
  });

  factory BookDetail.fromJson(Map<String, dynamic> json) {
    return new BookDetail(
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

Future<BookDetail> createBookToAdd(String url, Map body) async {
  final response = await http.post(url, body: body);

  if (response.statusCode == 200) {
    return BookDetail.fromJson(json.decode(response.body));
  }

  print(response.body);
  return null;
//  throw new Exception("Failed to create a post.");
}
