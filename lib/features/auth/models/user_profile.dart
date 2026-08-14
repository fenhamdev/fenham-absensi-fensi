class UserProfile {
  final String id;
  final String fullName;
  final String? email;
  final String role; // 'employee', 'admin', 'hr'
  final String department;
  final int quotaCuti;
  final String? avatarUrl;
  final DateTime? createdAt;

  UserProfile({
    required this.id,
    required this.fullName,
    this.email,
    this.role = 'employee',
    this.department = 'General',
    this.quotaCuti = 12,
    this.avatarUrl,
    this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? 'User Fensi',
      email: json['email'],
      role: json['role'] ?? 'employee',
      department: json['department'] ?? 'General',
      quotaCuti: json['quota_cuti'] ?? 12,
      avatarUrl: json['avatar_url'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'role': role,
      'department': department,
      'quota_cuti': quotaCuti,
      'avatar_url': avatarUrl,
    };
  }

  bool get isAdmin => role == 'admin' || role == 'hr';
}
