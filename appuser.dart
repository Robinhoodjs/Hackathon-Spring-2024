class AppUser {
  final String id;
  String email;
  String username;
  final String token;

  AppUser(
    this.id,
    this.email,
    this.username,
    this.token,
  );

  Map<String, Object?> toJson() => {
        'id': id,
        'email': email,
        'username': username,
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
      map['token'],
    );
  }

  static AppUser fromMapLimited(Map<String, dynamic> map) {
    return AppUser(
      '',
      '',
      map['username'],
      '',
    );
  }
}
