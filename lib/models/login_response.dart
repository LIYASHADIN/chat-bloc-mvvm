class LoginResponse {
  final bool encrypted;
  final String token;
  final UserModel user;

  LoginResponse({
    required this.encrypted,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      encrypted: json['encrypted'] ?? false,
      token: json['data']?['token'] ?? '',
      user: UserModel.fromJson(json['data']?['user'] ?? {}),
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? profile;
  final bool isOnline;
  final String? plan;
  final String? planEndDate;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profile,
    this.isOnline = false,
    this.plan,
    this.planEndDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      profile: json['profile'],
      isOnline: json['isOnline'] ?? false,
      plan: json['plan'],
      planEndDate: json['planEndDate'],
    );
  }
}
