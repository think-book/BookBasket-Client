import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:bookbasket/book_add.dart';
import 'package:bookbasket/book_detail.dart';
import 'package:bookbasket/book_list_screen.dart';
import 'package:bookbasket/user_list_screen.dart';
import 'package:bookbasket/public_booklist_screen.dart';
import 'package:bookbasket/forum/message_to_add.dart';
import 'package:bookbasket/forum/thread_message.dart';
import 'package:bookbasket/forum/message_post_exception.dart';
import 'package:bookbasket/thread_add.dart';
import 'package:bookbasket/user_create.dart';
import 'package:bookbasket/user_login.dart';
import 'dart:convert';

class ThreadAddException implements Exception {
  String errorMessage() {
    return 'Failed to add a thread.';
  }
}

class BookClient {
  http.Client _client;
  String rootURL;
  final String BOOKS = '/books';
  final String USERS = '/users';
  final String THREADS = '/threads';
  final String USER_REGISTRATION = '/users/registration';
  final String USER_LOGIN = '/users/login';
  final String PUBLIC_BOOKLIST = '/books/all';

  BookClient() {
    // Androidかそれ以外かでurlを変える
//       rootURL = 'https://thinkbook.itsp.club';
      rootURL = 'http://localhost';
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

    // 以下はclient単体で flutter runするときにコメントを外す。その際、上のserverへのrequestをコメントアウトする。
//    String json = "[{\"ISBN\":9784274219986,\"title\":\"機械学習入門\"},{\"ISBN\":9784774173016,\"title\":\"SQL実践入門\"},{\"ISBN\":9784798145600,\"title\":\"あたらしい人工知能の教科書\"},{\"ISBN\":9784822236861,\"title\":\"グーグルに学ぶディープラーニング\"},{\"ISBN\":9784865940404,\"title\":\"ブロックチェーン 仕組みと理論\"},{\"ISBN\":9784873117386,\"title\":\"入門 Python 3\"}]";
//    Iterable l = jsonDecode(json);
//    List<Book> books = l.map((model) => Book.fromJson(model)).toList();
//    return books;
  }

  // ユーザーのリスト取得
  Future<List<User>> getUsers() async {
    final response = await _client.get(rootURL + USERS+ '/lists');

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<User> users= l.map((model) => User.fromJson(model)).toList();
      return users;
    }
  }

  // 他人の本棚を取得
  Future<List<Book>> getUserBooks(int id) async {
    final response = await _client.get(rootURL + USERS + '/' + id.toString() + '/books');
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Book> books = l.map((model) => Book.fromJson(model)).toList();
      return books;
    }
  }

  // public本のリスト取得
  Future<List<PublicBook>> getPublicBookList() async {
//    final response = await _client.get(rootURL + PUBLIC_BOOKLIST);

//    if (response.statusCode == 200) {
//      Iterable l = jsonDecode(response.body);
//      List<PublicBook> books = l.map((model) => PublicBook.fromJson(model)).toList();
//      return books;
//    }

    // 以下はclient単体で flutter runするときにコメントを外す。その際、上のserverへのrequestをコメントアウトする。
    String json = "[{\"ISBN\":9784274219986,\"title\":\"機械学習入門\"},{\"ISBN\":9784774173016,\"title\":\"SQL実践入門\"},{\"ISBN\":9784798145600,\"title\":\"あたらしい人工知能の教科書\"},{\"ISBN\":9784822236861,\"title\":\"グーグルに学ぶディープラーニング\"},{\"ISBN\":9784865940404,\"title\":\"ブロックチェーン 仕組みと理論\"},{\"ISBN\":9784873117386,\"title\":\"入門 Python 3\"}]";
    Iterable l = jsonDecode(json);
    List<PublicBook> books = l.map((model) => PublicBook.fromJson(model)).toList();
    return books;
  }

  // 本追加
  Future<BookDetailToAdd> postBook(BookDetailToAdd bookDetailToAdd) async {
    var url = rootURL + BOOKS;
    var body = bookDetailToAdd.toMap();
    final response = await _client.post(url, body: body);

    if (response.statusCode == 200) {
      return BookDetailToAdd.fromJson(json.decode(response.body));
    }
    throw new BookAddException();
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
    // print(response.body);
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

  Future<MessageToAdd> postMessage(int threadId, {MessageToAdd newMessageToAdd}) async {
      var body = newMessageToAdd.toMap();
      final response = await _client.post(rootURL + THREADS + '/' + threadId.toString(), body: body);
      if(response.statusCode == 200) {
          return MessageToAdd.fromJson(json.decode(response.body));
      } else {
          throw new MessagePostException();
      }
  }

  Future<User> registerUser(UserDetailToRegister userDetailToRegister) async {
    var body = userDetailToRegister.toMap();
    final response = await _client.post(rootURL + USER_REGISTRATION, body: body);
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
        throw new UserRegistrationException();
    }

  }

  Future<User> loginUser(UserDetailToLogin userDetailToLogin) async {
    var body = userDetailToLogin.toMap();
    final response = await _client.post(rootURL + USER_LOGIN, body: body);
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
        throw new UserLoginException();
    }

  }

  Future<Image> getPicture(String ISBN) async {
      final response = await _client.get("https://www.googleapis.com/books/v1/volumes?q=" + ISBN);
      if (response.statusCode == 200) {
          var res = json.decode(response.body);
          return Image.network(res['items'][0]['volumeInfo']['imageLinks']['thumbnail']);
      } else {
          return Image.asset('res/img/book.png');
      }
  }
}
