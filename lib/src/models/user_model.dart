class UserModel {
  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
  });

  final String uid;
  final String name;
  final String email;

  factory UserModel.fromMap(Map<String, dynamic> map, {required String uid}) {
    return UserModel(
      uid: uid,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  UserModel copyWith({String? name, String? email}) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
