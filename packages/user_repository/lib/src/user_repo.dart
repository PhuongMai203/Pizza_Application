import 'package:firebase_auth/firebase_auth.dart';

import 'models/models.dart';

abstract class UserRepository {
  Stream<MyUser?> get user;

	Future<MyUser> signUp(MyUser myUser, String password);

	Future<void> setUserData(MyUser user);

	Future<User?> signIn(String email, String password);

	Future<void> sendPasswordResetOTP(String email);

	Future<void> logOut();
}