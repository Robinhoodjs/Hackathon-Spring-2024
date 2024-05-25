class AppUser {
  final String id;
  String email;
  String username;
  String facultaty;
  final String token;

  AppUser(
    this.id,
    this.email,
    this.username,
    this.facultaty,
    this.token,
  );

  Map<String, Object?> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'facultaty': facultaty,
        'token': token,
      };

  Map<String, Object?> toJsonLimited() => {
        'username': username,
      };

  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(
      map['id'],
      map['email'],
      map['username'],
      map['facultaty'],
      map['token'],
    );
  }

  static AppUser fromMapLimited(Map<String, dynamic> map) {
    return AppUser(
      '',
      '',
      map['username'],
      '',
      '',
    );
  }
}
