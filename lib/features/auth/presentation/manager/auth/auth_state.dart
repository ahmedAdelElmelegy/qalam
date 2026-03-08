part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {}

final class AuthError extends AuthState {
  final AppException exception;
  const AuthError(this.exception);

  @override
  List<Object> get props => [exception.message];
}

final class SignUpLoading extends AuthState {}

final class SignUpSuccess extends AuthState {
  final String message;
  const SignUpSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class SignUpError extends AuthState {
  final AppException exception;
  const SignUpError(this.exception);

  @override
  List<Object> get props => [exception.message];
}
