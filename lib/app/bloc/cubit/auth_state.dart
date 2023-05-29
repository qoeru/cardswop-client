part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoggedIn extends AuthState {}

class LoggedWithoutEmailVerified extends AuthState {}

class UnLoggedWrongPassword extends AuthState {}

class UnLoggedUserNotFound extends AuthState {}

class UnLoggedError extends AuthState {}

class UnLoggedInvalidEmail extends AuthState {}

class LoggedOut extends AuthState {}

class RegSuccess extends AuthState {}

class RegFailedWeakPassword extends AuthState {}

class RegFailedUsernameExists extends AuthState {}

class RegFailedEmailExist extends AuthState {}

class RegFailed extends AuthState {}

class RegLoading extends AuthState {}

class RegEmailVerification extends AuthState {}
