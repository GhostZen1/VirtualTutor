class UserModel {
  final int? userId;
  final String username;
  final String email;
  final String role;
  final String? dob;
  final String? enrollCourse;
  final String? progress;
  final String? createDate;

  UserModel({
    this.userId,
    required this.username,
    required this.email,
    required this.role,
    this.dob,
    this.enrollCourse,
    this.progress,
    this.createDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['UserId'] != null
          ? int.tryParse(json['UserId'].toString())
          : null,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      dob: json['dob'],
      enrollCourse: json['enrollCourse'],
      progress: json['progress'],
      createDate: json['createDate'],
    );
  }

  @override
  String toString() {
    return 'UserModel{userId: $userId, username: $username, email: $email, role: $role}';
  }
}
