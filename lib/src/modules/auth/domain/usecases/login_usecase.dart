import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/core/error/failures.dart';
import 'package:my_tracker_app/src/modules/auth/domain/entities/user_entity.dart';
import 'package:my_tracker_app/src/modules/auth/domain/repositories/auth_repository.dart';
@lazySingleton 
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({required String username, required String password, required String methodLogin,}) {
    return repository.signIn(username: username, password: password, methodLogin: methodLogin);
  }
}