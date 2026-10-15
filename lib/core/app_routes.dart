import 'package:flutter/material.dart';

import '../features/auth/role_selection_screen.dart';
import '../features/auth/sign_in_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/dashboard/client_dashboard_screen.dart';
import '../features/dashboard/worker_dashboard_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/profile/worker_profile_setup_screen.dart';
import '../features/splash/splash_screen.dart';

/// Named routes used by the app so later sections can link to any screen
/// without importing the concrete widgets.
class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  static const String signIn = '/sign-in';
  static const String register = '/register';
  static const String workerProfileSetup = '/worker-profile-setup';
  static const String workerDashboard = '/worker-dashboard';
  static const String clientDashboard = '/client-dashboard';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final WidgetBuilder builder = _builderFor(settings.name);

    return MaterialPageRoute<dynamic>(
      builder: builder,
      settings: settings,
    );
  }

  static WidgetBuilder _builderFor(String? name) {
    switch (name) {
      case onboarding:
        return (_) => const OnboardingScreen();
      case roleSelection:
        return (_) => const RoleSelectionScreen();
      case signIn:
        return (_) => const SignInScreen();
      case register:
        return (_) => const RegisterScreen();
      case workerProfileSetup:
        return (_) => const WorkerProfileSetupScreen();
      case workerDashboard:
        return (_) => const WorkerDashboardScreen();
      case clientDashboard:
        return (_) => const ClientDashboardScreen();
      case splash:
      default:
        return (_) => const SplashScreen();
    }
  }
}
