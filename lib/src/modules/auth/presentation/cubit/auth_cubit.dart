import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/common/widgets/toast_custom.dart';
import 'package:my_tracker_app/src/modules/auth/domain/entities/user_entity.dart';
import 'package:my_tracker_app/src/modules/auth/domain/usecases/login_usecase.dart';
import 'package:my_tracker_app/src/modules/auth/domain/usecases/resetpassword_usecase.dart';
import 'package:my_tracker_app/src/modules/auth/domain/usecases/signin_with_google_usecase.dart';
import 'package:my_tracker_app/src/modules/auth/domain/usecases/signout_usecase.dart';
import 'package:my_tracker_app/src/modules/auth/domain/usecases/signup_usecase.dart';
import 'package:my_tracker_app/src/modules/auth/domain/usecases/update_user_usecase.dart';
import 'package:oktoast/oktoast.dart';

import '../../domain/usecases/getuser_usecase.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final SignUpUseCase _signUpUseCase;
  final LoginUseCase _loginUseCase;
  final SignOutUseCase _signOutUseCase;
  final ResetPasswordUsecase _resetPasswordUseCase;
  final GetUserInfoUseCase _getUserInfoUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final UpdateUserUsecase _updateUserUsecase;
  StreamSubscription? _authSubscription;

  AuthCubit({
    required SignUpUseCase signUpUseCase,
    required LoginUseCase loginUseCase,
    required SignOutUseCase signOutUseCase,
    required ResetPasswordUsecase resetPasswordUseCase,
    required GetUserInfoUseCase getUserInfoUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required FirebaseAuth firebaseAuth,
    required UpdateUserUsecase updateUserUsecase,
  })  : _signUpUseCase = signUpUseCase,
        _loginUseCase = loginUseCase,
        _signOutUseCase = signOutUseCase,
        _getUserInfoUseCase = getUserInfoUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        _updateUserUsecase = updateUserUsecase,
        super(const AuthState.loading()) {
    _authSubscription = firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        emit(AuthState.authenticated(user.uid));
      } else {
        emit(const AuthState.unauthenticated());
      }
    });
  }

  bool validateEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool validatePassword(String password) {
    return password.length >= 6;
  }

  bool validateUsername(String username) {
    return username.length >= 6;
  }

  void onEmailChanged(String email) {
    final isValid = validateEmail(email);
    emit(
      AuthState.unauthenticated(
        emailError: isValid ? '' : 'Invalid email format',
        passwordError: state is _Unauthenticated
            ? (state as _Unauthenticated).passwordError
            : '',
        usernameError: state is _Unauthenticated
            ? (state as _Unauthenticated).usernameError
            : '',
      ),
    );
  }

  void onUsernameChanged(String username) {
    final isValid = validateUsername(username);
    emit(
      AuthState.unauthenticated(
        usernameError: isValid ? '' : 'Username must be at least 6 characters',
        emailError: state is _Unauthenticated
            ? (state as _Unauthenticated).emailError
            : '',
        passwordError: state is _Unauthenticated
            ? (state as _Unauthenticated).passwordError
            : '',
      ),
    );
  }

  void onPasswordChanged(String password) {
    final isValid = validatePassword(password);
    emit(
      AuthState.unauthenticated(
        passwordError: isValid ? '' : 'Password must be at least 6 characters',
        emailError: state is _Unauthenticated
            ? (state as _Unauthenticated).emailError
            : '',
        usernameError: state is _Unauthenticated
            ? (state as _Unauthenticated).usernameError
            : '',
      ),
    );
  }

  Future<void> signIn({
    required String username,
    required String password,
    required String methodLogin,
  }) async {
    // validate
    onUsernameChanged(username);
    onPasswordChanged(password);

    final usernameValid = validateUsername(username);
    final passwordValid = validatePassword(password);

    // invalid
    if (!usernameValid || !passwordValid) return;

    emit(const AuthState.loading());
    final result = await _loginUseCase(
      username: username,
      password: password,
      methodLogin: 'email',
    );
    result.fold(
      (failure) {
        emit(
          AuthState.unauthenticated(
            emailError: '',
            usernameError: '',
            passwordError: '',
            errorMessage: failure.message,
          ),
        );
        showToastWidget(
          ToastWidget(title: 'Login Failed', description: failure.message),
          duration: const Duration(seconds: 4),
        );
      },
      (user) async {
        emit(AuthState.authenticated(user.id));
        emit(AuthState.userInfoLoaded(user));
        // // get device token
        // final tokenDevice = await FirebaseMessaging.instance.getToken();
        // // send to server
        // if (tokenDevice != null) {
        //   final updateRessult = await _updateUserUsecase(
        //     user.id,
        //     tokenDevice,
        //     user.username,
        //     user.email,
        //   );
        //   updateRessult.fold(
        //     (failure) {
        //       showToastWidget(
        //         ToastWidget(
        //           title: 'Update token failed',
        //           description: failure.message,
        //         ),
        //       );
        //     },
        //     (_) => print('Device token updated successfully'),
        //   );
        // }
      },
    );
  }

  Future<void> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    // validate
    onEmailChanged(email);
    onUsernameChanged(username);
    onPasswordChanged(password);

    final emailValid = validateEmail(email);
    final usernameValid = validateUsername(username);
    final passwordValid = validatePassword(password);

    if (!emailValid || !passwordValid || !usernameValid) return;

    emit(const AuthState.loading());
    final result = await _signUpUseCase(
      email: email,
      username: username,
      password: password,
    );
    result.fold(
      (failure) {
        emit(
          AuthState.unauthenticated(
            emailError: '',
            passwordError: '',
            usernameError: '',
            errorMessage: failure.message,
          ),
        );
        showToastWidget(
          ToastWidget(title: 'Register Failed', description: failure.message),
          duration: const Duration(seconds: 4),
        );
      },
      (user) {
        emit(AuthState.authenticated(user.id.toString()));
        emit(AuthState.userInfoLoaded(user));
      },
    );
  }

  Future<void> resetPassword({required String email}) async {
    emit(const AuthState.loading());
    final result = await _resetPasswordUseCase(email: email);
    result.fold(
      (failure) {
        showToastWidget(
          ToastWidget(title: 'Error', description: failure.message),
          duration: const Duration(seconds: 4),
        );
      },
      (_) {
        emit(const AuthState.unauthenticated());

        showToastWidget(
          ToastWidget(
            title: 'Success',
            description: 'Password reset link sent to your email!',
          ),
          duration: const Duration(seconds: 4),
        );
      },
    );
  }

  Future<void> signInWithGoogle() async {
    emit(const AuthState.loading());
    final result = await _signInWithGoogleUseCase();
    result.fold(
      (failure) {
        emit(const AuthState.unauthenticated());
        showToastWidget(
          ToastWidget(
            title: 'Google Sign In Failed',
            description: failure.message,
          ),
          duration: const Duration(seconds: 4),
        );
      },
      (user) async {
        emit(AuthState.authenticated(user.id));
        emit(AuthState.userInfoLoaded(user));

        final tokenDevice = await FirebaseMessaging.instance.getToken();
        if (tokenDevice != null) {
          final updateRessult = await _updateUserUsecase(
            user.id,
            tokenDevice,
            user.username,
            user.email,
          );
          updateRessult.fold(
            (failure) {
              showToastWidget(
                ToastWidget(
                  title: 'Update token failed',
                  description: failure.message,
                ),
              );
            },
            (_) =>
                print('Device token updated successfully after Google sign-in'),
          );
        }
      },
    );
  }

  Future<void> signout() async {
    final result = await _signOutUseCase();
    result.fold(
      (failure) {
        showToastWidget(
          ToastWidget(title: 'Logout Failed', description: failure.message),
          duration: const Duration(seconds: 4),
        );
      },
      (_) {
        emit(const AuthState.unauthenticated());
      },
    );
  }

  Future<void> getUserInfo() async {
    if( isClosed) return;
    emit(AuthState.loading());
    try {
      final result = await _getUserInfoUseCase.call();
      if( isClosed) return;

      result.fold(
        (failure) => emit(AuthState.failure(failure.message)),
        (user) => emit(AuthState.userInfoLoaded(user)),
      );
    } catch (e) {
      if (isClosed) return;
      emit(AuthState.failure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  Future<String?> getDeviceToken() async {
    return FirebaseMessaging.instance.getToken();
  }
}
