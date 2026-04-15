class UserModel {
  int? id;
  String email;
  String password;

  UserModel({this.id, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: _asInt(map['id']),
      email: map['email']?.toString() ?? '',
      password: map['password']?.toString() ?? '',
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
