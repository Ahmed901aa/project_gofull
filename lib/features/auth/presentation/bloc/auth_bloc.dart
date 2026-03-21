import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:project_gofull/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:project_gofull/features/auth/presentation/bloc/auth_event.dart';
import 'package:project_gofull/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase sendOtp;
  final VerifyOtpUseCase verifyOtp;

  AuthBloc({required this.sendOtp, required this.verifyOtp})
      : super(const AuthInitial()) {
    on<SendOtpRequested>(_onSendOtp);
    on<VerifyOtpRequested>(_onVerifyOtp);
  }

  Future<void> _onSendOtp(
    SendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await sendOtp(SendOtpParams(phone: event.phone));
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(OtpSent(event.phone)),
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result =
        await verifyOtp(VerifyOtpParams(phone: event.phone, code: event.code));
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}
