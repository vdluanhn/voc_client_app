class User {
  final int? userId;
  final String? userName;
  final String? fullName;
  final String? status;
  final String? role;
  late String? accessToken = null;

  User({
    this.userId,
    this.userName,
    this.fullName,
    this.status,
    this.role,
  });

  User.fromJson(Map<dynamic, dynamic> json)
      : userId = json['user_id'] as int?,
        userName = json['user_name'] as String?,
        fullName = json['full_name'] as String?,
        status = json['status'] as String?,
        role = json['role'] as String?;

  Map<String, dynamic> toJson() => {'user_id': userId, 'user_name': userName, 'full_name': fullName, 'status': status, 'role': role};
}
