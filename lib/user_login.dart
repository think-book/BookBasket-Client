class UserDetailToLogin {
  final String username;
  final String password;

  UserDetailToLogin({
    this.username,
    this.password,
  });

  factory UserDetailToLogin.fromJson(Map<String, dynamic> json) {
    return new UserDetailToLogin(
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

class UserLoginException implements Exception {
  String errorMessage() {
    return 'User login failed.';
  }
}
