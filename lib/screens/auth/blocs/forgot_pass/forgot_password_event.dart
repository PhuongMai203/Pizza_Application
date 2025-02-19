part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ForgotPasswordRequested extends ForgotPasswordEvent {
  final String email;
  ForgotPasswordRequested(this.email);

  @override
  List<Object> get props => [email];
}

class VerifyOtpEvent extends ForgotPasswordEvent {
  final String email;
  final String otp;
  VerifyOtpEvent(this.email, this.otp);

  @override
  List<Object> get props => [email, otp];
}

class ResetPasswordEvent extends ForgotPasswordEvent {
  final String newPassword;
  ResetPasswordEvent(this.newPassword);

  @override
  List<Object> get props => [newPassword];
}
