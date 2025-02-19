import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  Future<void> _onForgotPasswordRequested(
      ForgotPasswordRequested event, Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());

    try {
      String otp = (100000 + Random().nextInt(900000)).toString();

      await _firestore.collection('password_resets').doc(event.email).set({
        'otp': otp,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await _auth.sendPasswordResetEmail(email: event.email);

      emit(ForgotPasswordOtpSent(event.email));
    } catch (e) {
      emit(ForgotPasswordFailure("Error: ${e.toString()}"));
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());

    try {
      DocumentSnapshot snapshot =
      await _firestore.collection('password_resets').doc(event.email).get();

      if (snapshot.exists && snapshot['otp'] == event.otp) {
        emit(OtpVerified(event.email));
      } else {
        emit(ForgotPasswordFailure("Invalid OTP"));
      }
    } catch (e) {
      emit(ForgotPasswordFailure("Error: ${e.toString()}"));
    }
  }

  Future<void> _onResetPassword(
      ResetPasswordEvent event, Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());

    try {
      await _auth.currentUser!.updatePassword(event.newPassword);
      emit(PasswordResetSuccess());
    } catch (e) {
      emit(ForgotPasswordFailure("Error: ${e.toString()}"));
    }
  }
}
