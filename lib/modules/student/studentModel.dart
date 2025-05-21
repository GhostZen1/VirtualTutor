class UserModel {
  final int userId;
  final String username;
  final String email;
  final String role;
  final String? dob;
  final String? enrollCourse;
  final String? progress;
  final String? createDate;

  UserModel({
    required this.userId,
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
      userId: json['UserId'],
      username: json['Username'],
      email: json['Email'],
      role: json['Role'],
      dob: json['DOB'],
      enrollCourse: json['EnrollCourse'],
      progress: json['Progress'],
      createDate: json['CreateDate'],
    );
  }
}
