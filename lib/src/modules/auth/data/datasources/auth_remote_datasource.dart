import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/data/remote/token/token_manager.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({
    required String username,
    required String password,
    required String methodLogin,
  });
  Future<UserModel> signUp(
      {required String email,
      required String password,
      required String username});
  Future<UserModel> signInWithGoogle();
  Future<UserModel> getUserInfo();
  Future<void> signOut();
  Future<void> resetPassword({required String email});
  Future<void> updateUser(
      String userId, String tokenDevice, String username, String email);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final firebase.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._googleSignIn, this.dio);

  @override
  Future<UserModel> signIn({
    required String username,
    required String password,
    required String methodLogin,
  }) async {

    String? fcmToken = await FirebaseMessaging.instance.getToken();

    final response = await dio.post('/api/v1/signin', data: {
      'username': username,
      'password': password,
      'methodLogin': methodLogin,
      'tokenDevice': fcmToken, 
    });

    final accessToken = response.data['accessToken'];
    final refreshToken = response.data['refreshToken'];
    await TokenManager.saveTokens(accessToken, refreshToken);
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String username,
    required String password,
  }) async {

    String? fcmToken = await FirebaseMessaging.instance.getToken();


    await dio.post('/api/v1/signup', data: {
      'email': email,
      'username': username,
      'password': password,
      'tokenDevice': fcmToken, 
    });

    final loginReponse = await dio.post('/api/v1/signin', data: {
      'username': username,
      'password': password,
      'tokenDevice': fcmToken, 
    });

    final accessToken = loginReponse.data['accessToken'];
    final refreshToken = loginReponse.data['refreshToken'];
    await TokenManager.saveTokens(accessToken, refreshToken);
    return UserModel.fromJson(loginReponse.data);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign in was canceled');

    String? fcmToken = await FirebaseMessaging.instance.getToken();
    
    final username = googleUser.email.split('@')[0];
    final email = googleUser.email;

    try {
      final response = await dio.post('/api/v1/signin', data: {
        'username': username,
        'methodLogin': 'google',
        'tokenDevice': fcmToken, 
      });
      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];
      await TokenManager.saveTokens(accessToken, refreshToken);

      return UserModel.fromJson(response.data);
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        await dio.post('/api/v1/signup', data: {
          'username': username,
          'email': email,
          'methodLogin': 'google',
          'password': null,
          'tokenDevice': fcmToken, 
        });

        final loginResponse = await dio.post('/api/v1/signin', data: {
          'username': username,
          'methodLogin': 'google',
          'tokenDevice': fcmToken, 
        });
        final accessToken = loginResponse.data['accessToken'];
        final refreshToken = loginResponse.data['refreshToken'];
        await TokenManager.saveTokens(accessToken, refreshToken);

        return UserModel.fromJson(loginResponse.data);
      }
      rethrow;
    }
  }

  @override
  Future<UserModel> getUserInfo() async {
    final accessToken = await TokenManager.getAccessToken();
    final userResponse = await dio.get(
      '/api/v1/user',
      options: Options(headers: {
        "accept": "application/json",
        "Authorization": "Bearer $accessToken",
      }),
    );
    return UserModel.fromJson(userResponse.data);
  }

  @override
  Future<void> signOut() async {
    final accessToken = await TokenManager.getAccessToken();
    await dio.post(
      '/api/v1/logout',
      options: Options(headers: {
        "accept": "application/json",
        "Authorization": "Bearer $accessToken",
      }),
    );

    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    await TokenManager.clearTokens();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> updateUser(
      String userId, String tokenDevice, String username, String email) async {
    final accessToken = await TokenManager.getAccessToken();
    final response = await dio.put('/api/v1/update-user',
        options: Options(headers: {
          "accept": "application/json",
          "Authorization": "Bearer $accessToken",
        }),
        data: {
          'tokenDevice': tokenDevice,
          'id': userId,
          'username': username,
          'email': email,
        });
    if (response.statusCode != 200) {
      throw Exception('Update device token failed');
    }
  }
}
