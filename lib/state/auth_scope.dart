import 'package:flutter/widgets.dart';

import 'auth_service.dart';

/// Exposes the [AuthService] to the widget tree and rebuilds dependants when
/// the session changes.
class AuthScope extends InheritedNotifier<AuthService> {
  const AuthScope({
    super.key,
    required AuthService service,
    required super.child,
  }) : super(notifier: service);

  static AuthService of(BuildContext context) {
    final AuthScope? scope =
        context.dependOnInheritedWidgetOfExactType<AuthScope>();
    assert(scope != null, 'AuthScope was not found in the widget tree.');
    return scope!.notifier!;
  }

  /// Reads the service without subscribing to rebuilds (safe in callbacks).
  static AuthService read(BuildContext context) {
    final AuthScope? scope = context.getInheritedWidgetOfExactType<AuthScope>();
    assert(scope != null, 'AuthScope was not found in the widget tree.');
    return scope!.notifier!;
  }
}
