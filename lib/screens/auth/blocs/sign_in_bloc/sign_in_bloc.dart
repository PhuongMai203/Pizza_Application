import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;

  SignInBloc(
    this._userRepository
  ) : super(SignInInitial()) {
    on<SignInRequired>((event, emit) async {
      emit(SignInProcess());
      try {
        final User? user = await _userRepository.signIn(event.email, event.password);
        if (user != null) {
          emit(SignInSuccess(user));
        } else {
          emit(SignInFailure());
        }
      } catch (e) {
        emit(SignInFailure());
      }
    });


    on<SignOutRequired>( (event, emit) async => await _userRepository.logOut());
  }

}
