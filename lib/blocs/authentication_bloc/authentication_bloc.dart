import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  late final StreamSubscription<MyUser?> _userSubscription;

  AuthenticationBloc({required this.userRepository})
      : super(AuthenticationState.unknown()) {
    // Lắng nghe thay đổi từ userRepository.user
    _userSubscription = userRepository.user.listen(
          (user) {
        add(AuthenticationUserChanged(user));
      },
      onError: (error) {
        print('Error in user stream: $error');
        add(AuthenticationUserChanged(null)); // Đưa về trạng thái unauthenticated khi có lỗi
      },
    );

    // Xử lý sự kiện AuthenticationUserChanged
    on<AuthenticationUserChanged>((event, emit) {
      try {
        if (event.user != null && event.user != MyUser.empty) {
          emit(AuthenticationState.authenticated(event.user!));
        } else {
          emit(const AuthenticationState.unauthenticated());
        }
      } catch (e) {
        print('Error handling AuthenticationUserChanged: $e');
        emit(const AuthenticationState.unauthenticated());
      }
    });
  }

  @override
  Future<void> close() async {
    try {
      await _userSubscription.cancel();
    } catch (e) {
      print('Error canceling subscription: $e');
    }
    return super.close();
  }
}
