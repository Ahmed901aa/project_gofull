import 'package:project_gofull/core/services/token_storage.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/auth/data/models/user_model.dart';
import 'package:project_gofull/features/auth/domain/usecases/login_usecase.dart';
import 'package:project_gofull/features/auth/domain/usecases/logout_usecase.dart';
import 'package:project_gofull/features/auth/domain/usecases/register_usecase.dart';
import 'package:project_gofull/features/auth/presentation/bloc/auth_event.dart';
import 'package:project_gofull/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final TokenStorage tokenStorage;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.tokenStorage,
  }) : super(const AuthInitial()) {
    on<CheckAuthRequested>(_onCheckAuth);
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
  }

  // ── Check saved session ───────────────────────────────────

  Future<void> _onCheckAuth(
    CheckAuthRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (tokenStorage.isLoggedIn) {
      final userJson = tokenStorage.getUser();
      if (userJson != null) {
        final user = UserModel.fromJson(userJson);
        emit(AuthAuthenticated(user));
        return;
      }
    }
    emit(const AuthUnauthenticated());
  }

  // ── Login ─────────────────────────────────────────────────

  Future<void> _onLogin(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await loginUseCase(
      LoginParams(phone: event.phone, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  // ── Register ──────────────────────────────────────────────

  Future<void> _onRegister(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await registerUseCase(
      RegisterParams(
        name: event.name,
        phone: event.phone,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        role: event.role,
      ),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  // ── Logout ────────────────────────────────────────────────

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await logoutUseCase(const NoParams());
    emit(const AuthUnauthenticated());
  }
}
