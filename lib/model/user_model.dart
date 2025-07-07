class UserModel {
  final String id;
  final String name;
  final String email;
  final String mobile; 
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'], 
    );
  }
}
