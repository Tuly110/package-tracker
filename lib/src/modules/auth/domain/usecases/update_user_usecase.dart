import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class UpdateUserUsecase {
  final AuthRepository repository;
  // final UpdateUserUsecase updateUserUsecase;


  UpdateUserUsecase(this.repository);

  Future<Either<Failure, void>> call(String userId, String tokenDevice, String username, String email) async {
    return await repository.updateUser(userId, tokenDevice, username, email);
  }
}