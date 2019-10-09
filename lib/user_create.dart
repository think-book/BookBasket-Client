import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class UserDetailToAdd {
  final String username;
  final String password;

  UserDetailToAdd({
    this.username,
    this.password,
  });

  factory UserDetailToAdd.fromJson(Map<String, dynamic> json) {
    return new UserDetailToAdd(
      username: json['username'],
      password: json['password'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['username'] = username;
    map['password'] = password;

    return map;
  }
}

class UserAddException implements Exception {
  String errorMessage() {
    return 'Failed to add user.';
  }
}
