/// The two experiences a SkillBridge user can choose from.
enum UserRole {
  worker,
  client;

  String get label {
    switch (this) {
      case UserRole.worker:
        return 'Skilled Worker';
      case UserRole.client:
        return 'Client';
    }
  }

  String get description {
    switch (this) {
      case UserRole.worker:
        return 'Showcase your skills, win jobs and grow your reputation.';
      case UserRole.client:
        return 'Discover trusted workers and hire the right skills fast.';
    }
  }
}
