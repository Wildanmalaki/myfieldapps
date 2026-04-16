class UserModel {
  int? id;
  String username;
  String email;
  String password;
  String role;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });

  String get displayName => username.trim().isEmpty ? email : username;

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: _asInt(map['id']),
      username: map['username']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      password: map['password']?.toString() ?? '',
      role: map['role']?.toString() ?? 'user booking',
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}
