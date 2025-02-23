part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();
  
  @override
  List<Object> get props => [];
}


final class SignUpInitial extends SignUpState {}

class SignUpSuccess extends SignUpState {}
class SignUpFailure extends SignUpState {
  final String error;

  const SignUpFailure(this.error);

  @override
  List<Object> get props => [error];
}
class SignUpProcess extends SignUpState {}