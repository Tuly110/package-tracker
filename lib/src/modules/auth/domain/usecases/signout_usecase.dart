import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/core/error/failures.dart';
import 'package:my_tracker_app/src/modules/auth/domain/repositories/auth_repository.dart';

@lazySingleton 
class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}