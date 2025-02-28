import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Thêm dòng này

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc(this._userRepository) : super(SignUpInitial()) {
    on<SignUpRequired>((event, emit) async {
      try {
        emit(SignUpProcess());

        // Đăng ký tài khoản với Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: event.user.email, password: event.password);

        if (userCredential.user != null) {
          // Lưu thông tin vào Firestore
          await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
            'name': event.user.name,  // Thêm tên người dùng
            'email': event.user.email,
          });

          // Đăng xuất ngay để không giữ phiên
          await FirebaseAuth.instance.signOut();

          emit(SignUpSuccess());
        }
      } catch (e) {
        emit(SignUpFailure(e.toString()));
      }
    });
  }
}
