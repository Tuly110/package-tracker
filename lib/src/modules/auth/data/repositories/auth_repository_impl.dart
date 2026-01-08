import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/core/data/remote/token/token_manager.dart';
import 'package:my_tracker_app/src/core/error/failures.dart';
import 'package:my_tracker_app/src/modules/auth/data/datasources/auth_remote_datasource.dart';
import 'package:my_tracker_app/src/modules/auth/data/models/user_model.dart';
import 'package:my_tracker_app/src/modules/auth/domain/entities/user_entity.dart';
import 'package:my_tracker_app/src/modules/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> signIn(
      {required String username, required String password, required String methodLogin,String? tokenDevice,}) async {
    try {
      final userModel = await remoteDataSource.signIn(
        username: username,
        password: password,
        methodLogin: methodLogin,
      );
      print('UserModel received: ${userModel.toJson()}'); // Debug
      print('User ID type: ${userModel.id.runtimeType}'); // Debug
      return Right(userModel.toEntity());
    } on DioException catch (e) {
      print('DioError: ${e.response?.data}');
      return Left(ServerFailure(message: e.response?.data['message'] ?? 'Login failed'));
    } catch (e) {
      print('Unknown error: $e');
      return Left(ServerFailure(message: 'Unknown error: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(
      { required String email,required String username, required String password}) async {
    try {
      final userModel = await remoteDataSource.signUp(
        email: email,
        username: username,
        password: password,
      );
      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data['message'] ?? 'Sign up failed'));
    } catch (e) {
      return Left(ServerFailure(message: 'Unknown error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await TokenManager.clearTokens();
      return Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: 'Cant sign out'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await remoteDataSource.resetPassword(email: email);
      return Right(unit);
    } on firebase.FirebaseAuthException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Unknown error'));
    } catch (e) {
      return Left(ServerFailure(message: 'Cant send reset password email'));
    }
  }

   @override
  Future<Either<Failure, UserEntity>> getUserInfo() async {
    try {
      final UserModel user = await remoteDataSource.getUserInfo();
      return Right(user.toEntity());
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message'] ?? 'Failed to get user info')
          : 'Failed to get user info';

      if (status == 401) {
        return Left(ServerFailure(message: 'Unauthorized'));
      }
      return Left(ServerFailure(message: msg));
    } catch (e) {
      return Left(ServerFailure(message: 'Unknown error: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      
      final userModel = await remoteDataSource.signInWithGoogle();
      return Right(userModel.toEntity());
    } 
    on DioError catch (e) {
      final message = e.response?.data['message'] ?? 'Failed to sign in with Google';
      return Left(ServerFailure(message: e.message ?? 'Unknown error'));
    } 
    catch (e) {
      print(e.toString());
      return Left(
        ServerFailure(message: 'Cant sign in with Google ' + e.toString())
      );
    }
  }
  
@override
Future<Either<Failure, Unit>> updateUser(
    String userId, String tokenDevice, String username, String email) async {
  try {
    await remoteDataSource.updateUser(userId, tokenDevice, username, email);
    return Right(unit);
  } catch (e) {
    return Left(ServerFailure(message: 'Failed to update user: $e'));
  }
}
}
