class AboutUserModel {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String email;
  final bool blocked;
  final String? blockedCode;
  final String role;

  AboutUserModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    required this.blocked,
    this.blockedCode,
    required this.role,
  });

  factory AboutUserModel.fromJson(Map<String, dynamic> json) {
    json = json['data'];
    final attributes = json['attributes'] as Map<String, dynamic>;
    return AboutUserModel(
      id: json['id'] as String,
      createdAt: attributes['created_at'] as String,
      updatedAt: attributes['updated_at'] as String,
      email: attributes['email'] as String,
      blocked: attributes['blocked'] as bool,
      blockedCode: attributes['blocked_code'] as String?,
      role: attributes['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': {
        'created_at': createdAt,
        'updated_at': updatedAt,
        'email': email,
        'blocked': blocked,
        'blocked_code': blockedCode,
        'role': role.toLowerCase(),
      },
    };
  }
}
