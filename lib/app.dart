import 'package:flutter/material.dart';

import 'core/app_constants.dart';
import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'state/auth_scope.dart';
import 'state/auth_service.dart';

/// Root widget. Wraps the app in an [AuthScope] so every screen can read the
/// session, and starts on the splash screen.
class SkillBridgeApp extends StatefulWidget {
  const SkillBridgeApp({super.key, this.authService});

  /// Optional injected service (used by tests); defaults to the singleton.
  final AuthService? authService;

  @override
  State<SkillBridgeApp> createState() => _SkillBridgeAppState();
}

class _SkillBridgeAppState extends State<SkillBridgeApp> {
  late final AuthService _auth = widget.authService ?? AuthService.instance;

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      service: _auth,
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
