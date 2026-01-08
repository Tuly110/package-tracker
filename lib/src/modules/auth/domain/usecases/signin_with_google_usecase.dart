import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/core/error/failures.dart';
import 'package:my_tracker_app/src/modules/auth/domain/entities/user_entity.dart';
import 'package:my_tracker_app/src/modules/auth/domain/repositories/auth_repository.dart';

@lazySingleton 
class SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() {
    return repository.signInWithGoogle();
  }
}
