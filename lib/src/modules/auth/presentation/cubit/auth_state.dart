part of 'auth_cubit.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.unauthenticated({
    @Default('') String emailError,
    @Default('') String passwordError,
    @Default('') String usernameError,
    String? errorMessage,
  }) = _Unauthenticated;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(String userId) = _Authenticated;
  const factory AuthState.failure(String message) = _Failure;
  const factory AuthState.userInfoLoaded(UserEntity user) = _UserInfoLoaded;
}
