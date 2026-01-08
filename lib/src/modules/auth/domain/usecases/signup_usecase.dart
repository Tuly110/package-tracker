import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/core/error/failures.dart';
import 'package:my_tracker_app/src/modules/auth/domain/entities/user_entity.dart';
import 'package:my_tracker_app/src/modules/auth/domain/repositories/auth_repository.dart';

@lazySingleton 
class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({required String email, required String username, required String password}) {
    return repository.signUp(email: email, username: username, password: password);
  }
}