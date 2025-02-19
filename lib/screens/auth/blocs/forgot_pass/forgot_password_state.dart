part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordOtpSent extends ForgotPasswordState {
  final String email;
  ForgotPasswordOtpSent(this.email);

  @override
  List<Object> get props => [email];
}

class OtpVerified extends ForgotPasswordState {
  final String email;
  OtpVerified(this.email);

  @override
  List<Object> get props => [email];
}

class PasswordResetSuccess extends ForgotPasswordState {}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String error;
  ForgotPasswordFailure(this.error);

  @override
  List<Object> get props => [error];
}
