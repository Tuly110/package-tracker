import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/modules/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart'; 
import 'package:my_tracker_app/src/core/error/failures.dart';
@lazySingleton 
class ResetPasswordUsecase {
  final AuthRepository repository;

  ResetPasswordUsecase(this.repository);

  Future<Either<Failure, void>> call({required String email}) {
    return repository.resetPassword(email: email);
  }
}