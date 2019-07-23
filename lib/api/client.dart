import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:bookbasket/book_list_screen.dart';
import 'package:bookbasket/book_detail.dart';
import 'package:bookbasket/forum/thread_message.dart';
import 'package:bookbasket/thread_add.dart';
import 'dart:convert';

class ThreadAddException implements Exception {
  String errorMessage() {
    return 'Failed to add book.';
  }
}

class BookClient {
  http.Client _client;
  String rootURL;
  final String BOOKS = '/books';
  final String THREADS = '/threads';

  BookClient() {
    // Androidかそれ以外かでurlを変える
    if (Platform.isAndroid) {
      rootURL = 'http://10.0.2.2:8080';
    } else {
      rootURL = 'http://localhost:8080';
    }
    _client = http.Client();
  }

  // 本のリスト取得
  Future<List<Book>> getBooks() async {
    final response = await _client.get(rootURL + BOOKS);

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Book> books = l.map((model) => Book.fromJson(model)).toList();
      return books;
    }
  }

  // フォーラム取得
  Future<List<Thread>> getThreadList(String ISBN) async {
    final response = await _client.get(rootURL + BOOKS + '/' + ISBN + THREADS);
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Thread> threads = l.map((model) => Thread.fromJson(model)).toList();
      return threads;
    }
  }

  // スレッド追加
  Future<ThreadToAdd> postThread(int ISBN, {ThreadToAdd newThreadToAdd}) async {
    var body = newThreadToAdd.toMap();
    final response = await _client
        .post(rootURL + BOOKS + '/' + ISBN.toString() + THREADS, body: body);
    print(response.body);
    if (response.statusCode == 200) {
      return ThreadToAdd.fromJson(json.decode(response.body));
    } else {
      throw new ThreadAddException();
    }
  }

  // 本の詳細取得
  Future<BookDetail> getBookDetail(String ISBN) async {
    final response = await _client.get(rootURL + BOOKS + '/' + ISBN);
    if (response.statusCode == 200) {
      BookDetail detail = BookDetail.fromJson(jsonDecode(response.body));
      return detail;
    }
  }

  // スレッドのメッセージ全取得
  Future<List<ThreadMessage>> getThreadMessages(int threadId) async {
    final response =
        await _client.get(rootURL + THREADS + '/' + threadId.toString());
    if (response.statusCode == 200) {
      Iterable lst = jsonDecode(response.body);
      List<ThreadMessage> messages =
          lst.map((json) => ThreadMessage.fromJson(json)).toList();
      return messages;
    } else {
      throw Exception('Failed to load thread messages');
    }
  }
}
