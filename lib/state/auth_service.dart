import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../models/user_role.dart';
import '../models/worker_profile.dart';

/// Outcome of an authentication action.
class AuthResult {
  const AuthResult.success() : error = null;
  const AuthResult.failure(this.error);

  final String? error;

  bool get isSuccess => error == null;
}

class _Account {
  _Account({
    required this.user,
    required this.password,
  });

  AppUser user;
  final String password;
}

/// In-memory authentication and session store.
///
/// Part 1 owns getting the user into the app. This service is the single
/// handover point: once a user registers or signs in, later sections can read
/// [currentUser], [userRole] and [workerProfile] from anywhere in the tree.
///
/// It can be swapped for a real backend later without changing the screens.
class AuthService extends ChangeNotifier {
  AuthService() {
    _seedDemoAccounts();
  }

  static final AuthService instance = AuthService();

  final Map<String, _Account> _accounts = <String, _Account>{};

  AppUser? _currentUser;
  UserRole? _pendingRole;
  bool _hasSeenOnboarding = false;

  AppUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  UserRole? get userRole => _currentUser?.role ?? _pendingRole;
  WorkerProfile? get workerProfile => _currentUser?.workerProfile;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  UserRole? get pendingRole => _pendingRole;

  /// The route the app should show once the splash animation finishes.
  String get initialRouteAfterSplash {
    if (!_hasSeenOnboarding) return '/onboarding';
    if (isAuthenticated) {
      return userRole == UserRole.worker
          ? '/worker-dashboard'
          : '/client-dashboard';
    }
    return '/role-selection';
  }

  void completeOnboarding() {
    if (_hasSeenOnboarding) return;
    _hasSeenOnboarding = true;
    notifyListeners();
  }

  void selectRole(UserRole role) {
    _pendingRole = role;
    notifyListeners();
  }

  bool emailRegistered(String email) =>
      _accounts.containsKey(_normalise(email));

  AuthResult register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    UserRole? role,
  }) {
    final String key = _normalise(email);
    if (_accounts.containsKey(key)) {
      return const AuthResult.failure(
        'An account with this email already exists.',
      );
    }

    final UserRole resolvedRole = role ?? _pendingRole ?? UserRole.client;
    final AppUser user = AppUser(
      id: key,
      fullName: fullName.trim(),
      email: key,
      phone: phone.trim(),
      role: resolvedRole,
      workerProfile:
          resolvedRole == UserRole.worker ? const WorkerProfile() : null,
    );

    _accounts[key] = _Account(user: user, password: password);
    _currentUser = user;
    notifyListeners();
    return const AuthResult.success();
  }

  AuthResult signIn({required String email, required String password}) {
    final _Account? account = _accounts[_normalise(email)];
    if (account == null) {
      return const AuthResult.failure('No account found for that email.');
    }
    if (account.password != password) {
      return const AuthResult.failure('Incorrect password. Please try again.');
    }
    _currentUser = account.user;
    notifyListeners();
    return const AuthResult.success();
  }

  void saveWorkerProfile(WorkerProfile profile) {
    final AppUser? user = _currentUser;
    if (user == null) return;

    final AppUser updated = user.copyWith(
      workerProfile: profile,
      location: profile.location ?? user.location,
    );
    _currentUser = updated;
    _accounts[_normalise(user.email)]?.user = updated;
    notifyListeners();
  }

  void signOut() {
    _currentUser = null;
    _pendingRole = null;
    notifyListeners();
  }

  /// Resets all state; useful for tests and "start over" flows.
  void reset() {
    _accounts.clear();
    _currentUser = null;
    _pendingRole = null;
    _hasSeenOnboarding = false;
    _seedDemoAccounts();
    notifyListeners();
  }

  String _normalise(String email) => email.trim().toLowerCase();

  void _seedDemoAccounts() {
    _accounts.putIfAbsent(
      'worker@skillbridge.app',
      () => _Account(
        user: const AppUser(
          id: 'worker@skillbridge.app',
          fullName: 'Chanda Mwale',
          email: 'worker@skillbridge.app',
          phone: '0971234567',
          role: UserRole.worker,
          location: 'Lusaka',
          workerProfile: WorkerProfile(
            trade: 'Welding',
            bio: 'Certified welder with a passion for clean, durable work.',
            location: 'Lusaka',
            yearsExperience: 5,
            hourlyRate: 120,
            skills: <String>['MIG Welding', 'Arc Welding', 'Metal Fabrication'],
          ),
        ),
        password: 'password123',
      ),
    );
    _accounts.putIfAbsent(
      'client@skillbridge.app',
      () => _Account(
        user: const AppUser(
          id: 'client@skillbridge.app',
          fullName: 'Linda Banda',
          email: 'client@skillbridge.app',
          phone: '0967654321',
          role: UserRole.client,
          location: 'Kitwe',
        ),
        password: 'password123',
      ),
    );
  }
}
