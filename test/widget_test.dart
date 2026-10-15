import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skillbridge/app.dart';
import 'package:skillbridge/core/validators.dart';
import 'package:skillbridge/models/user_role.dart';
import 'package:skillbridge/state/auth_service.dart';

void main() {
  group('Validators', () {
    test('rejects invalid emails', () {
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.email('worker@skillbridge.app'), isNull);
    });

    test('requires strong enough passwords', () {
      expect(Validators.password('short'), isNotNull);
      expect(Validators.password('password123'), isNull);
    });

    test('checks password confirmation', () {
      expect(Validators.confirmPassword('abc12345', 'xyz98765'), isNotNull);
      expect(Validators.confirmPassword('password123', 'password123'), isNull);
    });
  });

  group('AuthService', () {
    test('registers, signs in and exposes role data', () {
      final AuthService auth = AuthService();

      auth.selectRole(UserRole.worker);
      final AuthResult result = auth.register(
        fullName: 'Test Worker',
        email: 'test@skillbridge.app',
        phone: '0970000000',
        password: 'password123',
      );

      expect(result.isSuccess, isTrue);
      expect(auth.isAuthenticated, isTrue);
      expect(auth.userRole, UserRole.worker);
      expect(auth.currentUser?.fullName, 'Test Worker');

      auth.signOut();
      expect(auth.isAuthenticated, isFalse);

      final AuthResult signIn = auth.signIn(
        email: 'test@skillbridge.app',
        password: 'password123',
      );
      expect(signIn.isSuccess, isTrue);
      expect(auth.currentUser?.role, UserRole.worker);
    });

    test('rejects duplicate emails and wrong passwords', () {
      final AuthService auth = AuthService();

      auth.register(
        fullName: 'Someone',
        email: 'dup@skillbridge.app',
        phone: '0970000000',
        password: 'password123',
        role: UserRole.client,
      );
      expect(
        auth
            .register(
              fullName: 'Someone Else',
              email: 'dup@skillbridge.app',
              phone: '0970000001',
              password: 'password123',
              role: UserRole.client,
            )
            .isSuccess,
        isFalse,
      );
      expect(
        auth
            .signIn(email: 'dup@skillbridge.app', password: 'wrong-password')
            .isSuccess,
        isFalse,
      );
    });
  });

  testWidgets('Splash screen shows branding then routes to onboarding',
      (WidgetTester tester) async {
    final AuthService auth = AuthService();

    await tester.pumpWidget(SkillBridgeApp(authService: auth));

    expect(find.text('SkillBridge'), findsOneWidget);
    expect(find.text('Show it. Prove it. Grow it.'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    expect(find.text('Show It'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
