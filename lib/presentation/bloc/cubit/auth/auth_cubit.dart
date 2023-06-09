import 'dart:convert';
import 'dart:math' as math;
import 'package:cardswop_shared/cardswop_shared.dart';
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

  Swopper _emitLogIn(var response) {
    var user =
        Swopper.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

    if (!auth.FirebaseAuth.instance.currentUser!.emailVerified) {
      emit(LoggedIn(isEmailVerified: false, user: user));
      return user;
    } else {
      emit(LoggedIn(isEmailVerified: true, user: user));
      return user;
    }
  }

  void logIn(String emailAddress, String password) async {
    try {
      emit(LoginLoading());
      await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);

      var tmpUser = auth.FirebaseAuth.instance.currentUser;

      if (tmpUser == null) {
        throw Exception('user account is somehowc created, yet user is null');
      }

      var response = await http.get(
        Uri.http(env.HOST, '${env.USERS_ENDPOINT}/${tmpUser.uid}'),
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

  Future<Swopper?> checkAuthStatus() async {
    var tmpUser = auth.FirebaseAuth.instance.currentUser;
    if (tmpUser != null) {
      try {
        var response = await http.get(
          Uri.http(env.HOST, '${env.USERS_ENDPOINT}/${tmpUser.uid}'),
        );

        if (response.statusCode != 200) {
          throw Exception(
              'unable-to-login, backend error, code:  ${response.statusCode}, body${response.body}');
        }

        return _emitLogIn(response);
      } on Exception catch (e) {
        closeAuth();
        log(e.toString());
      } catch (e) {
        closeAuth();
        log(e.toString());
      }
    }
    return null;
  }

  void closeAuth() async {
    await auth.FirebaseAuth.instance.signOut();
    emit(AuthInitial());
    notifyListeners();
  }

  void tryToRegister(
    String username,
    String emailAddress,
    String password,
    List<String>? city,
    int mailExchange,
    String contactLink,
    String galleryLink,
    String exchangeValue,
  ) async {
    try {
      emit(RegLoading());

      await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      var currentUid = auth.FirebaseAuth.instance.currentUser!.uid;

      //TODO: добавить потом проверку на один и тот же суффикc и один и тот же ник!
      var user = Swopper(
        suffix: math.Random().nextInt(9000) + 1000,
        name: username,
        id: currentUid,
        email: emailAddress,
        galleryLink: (galleryLink.isEmpty) ? null : [galleryLink],
        contactLink: [contactLink],
        city: city,
        mailExchange: mailExchange,
        defaultExchangeValue: exchangeValue.isEmpty ? null : exchangeValue,
      );

      var response = await http.post(Uri.http(env.HOST, env.USERS_ENDPOINT),
          body: jsonEncode(user.toJson()));

      if (response.statusCode != 201) {
        throw Exception(
            'unable-to-register, code: ${response.statusCode}, body${response.body}');
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
