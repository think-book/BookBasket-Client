class UserDetailToRegister {
  final String username;
  final String password;

  UserDetailToRegister({
    this.username,
    this.password,
  });

  factory UserDetailToRegister.fromJson(Map<String, dynamic> json) {
    return new UserDetailToRegister(
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

class UserRegistrationException implements Exception {
  String errorMessage() {
    return 'Failed to register user.';
  }
}
