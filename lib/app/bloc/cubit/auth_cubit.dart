import 'dart:convert';
import 'dart:math' as math;
import 'package:domain/db.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:cardswop/localenv.dart' as env;
// import 'package:cardswop/app/bloc/cubit/navigation_cubit.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  // final db = auth.FirebaseFirestore.instance;
  bool isEmailVerified = false;

  UserView? user;

  // void logIn(String emailAddress, String password) async {
  //   try {
  //     emit(LoginLoading());

  //     await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: emailAddress, password: password);

  //     // user = Swopper()

  //     // getAuth

  //     var userInfo = await db
  //         .collection('swoppers')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .get();

  //     user = Swopper(
  //       username: userInfo['username'],
  //       uid: FirebaseAuth.instance.currentUser!.uid,
  //       email: emailAddress,
  //       prefix: userInfo['prefix'],
  //     );

  //     if (!FirebaseAuth.instance.currentUser!.emailVerified) {
  //       emit(LoggedWithoutEmailVerified());
  //     } else {
  //       emit(LoggedIn());
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       emit(UnLoggedUserNotFound());
  //       log('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       emit(UnLoggedWrongPassword());
  //       log('Wrong password provided for that user.');
  //     } else if (e.code == 'invalid-email') {
  //       log(e.code);
  //       emit(UnLoggedInvalidEmail());
  //     } else {
  //       emit(UnLoggedError());
  //     }
  //   }
  // }

  // void checkAuthStatus(BuildContext context) async {
  //   var tmpUser = FirebaseAuth.instance.currentUser;
  //   if (tmpUser != null) {
  //     var userInfo = await db.collection('swoppers').doc(tmpUser.uid).get();
  //     user = Swopper(
  //       username: userInfo['username'],
  //       prefix: userInfo['prefix'],
  //       uid: tmpUser.uid,
  //       email: tmpUser.email!,
  //     );
  //     if (tmpUser.emailVerified) {
  //       emit(LoggedIn());
  //     } else {
  //       emit(LoggedWithoutEmailVerified());
  //     }
  //   }
  // }

  // void closeAuth(BuildContext context) {
  //   user = null;
  //   FirebaseAuth.instance.signOut();
  //   emit(AuthInitial());
  //   // context.read<NavigationCubit>().switchToLogin();
  // }

  void tryToRegister(
      String username, String emailAddress, String password) async {
    try {
      emit(RegLoading());
      // var doc = await db.collection('swoppers').doc(currentUid).get();

      await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      var currentUid = auth.FirebaseAuth.instance.currentUser!.uid;

      //добавить потом проверку на один и тот же суффик и один и тот же ник!
      user = UserView(
        suffix: math.Random().nextInt(9000) + 1000,
        name: username,
        uid: currentUid,
        email: emailAddress,
      );

      // db.collection('swoppers').doc(currentUid).set(user!.toJson());

      const uri = env.HOST + env.USERS_ENDPOINT;

      var request =
          await http.post(Uri.parse(uri), body: jsonEncode(user!.toJson()));

      if (request.statusCode == 200) {
        emitEmailVerification();
        emit(LoggedWithoutEmailVerified());
      }
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegFailedWeakPassword());
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        emit(RegFailedEmailExist());
        log('The account already exists for that email.');
      } else {
        emit(RegFailed());
        log(e.toString());
      }
    } catch (e) {
      emit(RegFailed());
      log(e.toString());
    }
  }

  void emitEmailVerification() async {
    try {
      await auth.FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } catch (_) {
      log('email verification failed');
    }
  }
}
