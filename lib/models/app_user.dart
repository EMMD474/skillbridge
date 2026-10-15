import 'user_role.dart';
import 'worker_profile.dart';

/// The logged-in user handed over to the dashboard section.
class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.location,
    this.workerProfile,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final UserRole role;
  final String? location;
  final WorkerProfile? workerProfile;

  String get firstName {
    final String trimmed = fullName.trim();
    if (trimmed.isEmpty) return 'there';
    return trimmed.split(RegExp(r'\s+')).first;
  }

  String get initials {
    final List<String> parts =
        fullName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'SB';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  AppUser copyWith({
    String? fullName,
    String? email,
    String? phone,
    UserRole? role,
    String? location,
    WorkerProfile? workerProfile,
  }) {
    return AppUser(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      location: location ?? this.location,
      workerProfile: workerProfile ?? this.workerProfile,
    );
  }
}
