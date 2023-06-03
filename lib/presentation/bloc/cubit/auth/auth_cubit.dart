import 'dart:convert';
import 'dart:math' as math;
import 'package:cardswop/globals.dart';
import 'package:cardswop_shared/db.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'dart:developer';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:cardswop/localenv.dart' as env;

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> with ChangeNotifier {
  AuthCubit() : super(AuthInitial());

  // final db = auth.FirebaseFirestore.instance;

  void _emitLogIn(var response) {
    var user =
        UserView.jsonDecode(jsonDecode(response.body) as Map<String, dynamic>);

    if (!auth.FirebaseAuth.instance.currentUser!.emailVerified) {
      emit(LoggedIn(isEmailVerified: false, user: user));
      notifyListeners();
    } else {
      emit(LoggedIn(isEmailVerified: true, user: user));
      notifyListeners();
    }
  }

  void logIn(String emailAddress, String password) async {
    try {
      emit(LoginLoading());
      await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);

      var response = await http.put(
        Uri.http(env.HOST, env.USERS_ENDPOINT),
        headers: Globals.corsHeaders,
        body: jsonEncode({'uid': auth.FirebaseAuth.instance.currentUser!.uid}),
      );

      if (response.statusCode != 200) {
        closeAuth();
        throw Exception(
            'unable-to-login, backend error, code:  ${response.statusCode}, body${response.body}');
      }
      _emitLogIn(response);
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(UnLoggedUserNotFound());
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        emit(UnLoggedWrongPassword());
        log('Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        log(e.code);
        emit(UnLoggedInvalidEmail());
      } else {
        emit(UnLoggedError());
      }
    } on Exception catch (e) {
      log(e.toString());
      emit(UnLoggedError());
    } catch (e) {
      log(e.toString());
      emit(UnLoggedError());
    }
  }

  void getUserData(var fbUser) async {
    if (fbUser == null) {
      emit(AuthInitial());
    } else {
      try {
        var response = await http.put(
          Uri.http(env.HOST, env.USERS_ENDPOINT),
          headers: Globals.corsHeaders,
          body:
              jsonEncode({'uid': auth.FirebaseAuth.instance.currentUser!.uid}),
        );

        if (response.statusCode != 200) {
          throw Exception(
              'unable-to-login, backend error, code:  ${response.statusCode}, body${response.body}');
        }

        _emitLogIn(response);

        // emit(LoggedWithoutEmailVerified());
        // log('emitted!!!');
      } on Exception catch (e) {
        closeAuth();
        log(e.toString());
      } catch (e) {
        closeAuth();
        log(e.toString());
      }
    }
  }

  void checkAuthStatus() async {
    var tmpUser = auth.FirebaseAuth.instance.currentUser;
    if (tmpUser != null) {
      try {
        var response = await http.put(
          Uri.http(env.HOST, env.USERS_ENDPOINT),
          headers: Globals.corsHeaders,
          body:
              jsonEncode({'uid': auth.FirebaseAuth.instance.currentUser!.uid}),
        );

        if (response.statusCode != 200) {
          throw Exception(
              'unable-to-login, backend error, code:  ${response.statusCode}, body${response.body}');
        }

        _emitLogIn(response);
      } on Exception catch (e) {
        closeAuth();
        log(e.toString());
      } catch (e) {
        closeAuth();
        log(e.toString());
      }
    }
  }

  void closeAuth() {
    auth.FirebaseAuth.instance.signOut();
    emit(AuthInitial());
    notifyListeners();
  }

  void tryToRegister(
      String username, String emailAddress, String password) async {
    try {
      emit(RegLoading());

      await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      var currentUid = auth.FirebaseAuth.instance.currentUser!.uid;

      //добавить потом проверку на один и тот же суффикc и один и тот же ник!
      var user = UserView(
        suffix: math.Random().nextInt(9000) + 1000,
        name: username,
        uid: currentUid,
        email: emailAddress,
      );

      var request = await http.post(Uri.http(env.HOST, env.USERS_ENDPOINT),
          headers: Globals.corsHeaders, body: jsonEncode(user.jsonEncode()));

      if (request.statusCode != 201) {
        throw Exception(
            'unable-to-register, code: ${request.statusCode}, body${request.body}');
      }
      emitEmailVerification();

      emit(LoggedIn(isEmailVerified: false, user: user));
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
