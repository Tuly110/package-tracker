import 'package:dartz/dartz.dart';
import 'package:my_tracker_app/src/core/error/failures.dart';
import 'package:my_tracker_app/src/modules/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn({required String username, required String password, required String methodLogin,String? tokenDevice,});
  Future<Either<Failure, UserEntity>> signUp({required String email, required String username, required String password});
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure,void>> resetPassword({required String email});
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, UserEntity>> getUserInfo();
  Future<Either<Failure, Unit>> updateUser(String userId, String tokenDevice,String username, String email);
  
}