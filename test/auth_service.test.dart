import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:smarsh/firebase_options.dart';
import 'package:smarsh/services/auth/auth_service.dart';
import 'package:smarsh/services/auth/auth_provider.dart';
import 'package:smarsh/services/auth/auth_user.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

void main() async{
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  group('AuthService', () {
    late AuthService authService;
    late AuthProvider mockProvider;

    setUp(() {
      mockProvider = MockAuthProvider();
      authService = AuthService(mockProvider);
    });

    test('createUser calls provider.createUser', () async {
      const email = 'test@test.com';
      const password = 'password';

      const expectedUser = AuthUser(
          email: email,
          id: '23',
          url: 'https://www.google.com  ',
          name: 'Test User',
          isEmailVerified: true);
      when(mockProvider.createUser(email: email, password: password))
          .thenAnswer((_) => Future.value(expectedUser));

      final user =
          await authService.createUser(email: email, password: password);

      expect(user, equals(expectedUser));
      verify(mockProvider.createUser(email: email, password: password))
          .called(1);
    });

    test('currentUser returns provider.currentUser', () {
      const expectedUser = AuthUser(
          email: 'email@s.com',
          id: '23',
          url: 'https://www.google.com  ',
          name: 'Test User',
          isEmailVerified: true);
      when(mockProvider.currentUser).thenReturn(expectedUser);

      final user = authService.currentUser;

      expect(user, equals(expectedUser));
      verify(mockProvider.currentUser).called(1);
    });

    test('logIn calls provider.logIn', () async {
      const email = 'test@test.com';
      const password = 'password';

      const expectedUser = AuthUser(
          email: email,
          id: '23',
          url: 'https://www.google.com  ',
          name: 'Test User',
          isEmailVerified: true);
      when(mockProvider.logIn(email: email, password: password))
          .thenAnswer((_) => Future.value(expectedUser));

      final user = await authService.logIn(email: email, password: password);

      expect(user, equals(expectedUser));
      verify(mockProvider.logIn(email: email, password: password)).called(1);
    });

    test('logOut calls provider.logOut', () async {
      await authService.logOut();

      verify(mockProvider.logOut()).called(1);
    });

    test('sendEmailVerification calls provider.sendEmailVerification',
        () async {
      await authService.sendEmailVerification();

      verify(mockProvider.sendEmailVerification()).called(1);
    });

    test('initialize calls provider.initialize', () async {
      await authService.initialize();

      verify(mockProvider.initialize()).called(1);
    });

    test('sendPasswordReset calls provider.sendPasswordReset', () async {
      const email = 'test@test.com';

      await authService.sendPasswordReset(toEmail: email);

      verify(mockProvider.sendPasswordReset(toEmail: email)).called(1);
    });
  });
}
