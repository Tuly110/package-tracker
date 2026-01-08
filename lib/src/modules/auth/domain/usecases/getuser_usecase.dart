import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class GetUserInfoUseCase{
  final AuthRepository repository;

  GetUserInfoUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getUserInfo( );
  }
}