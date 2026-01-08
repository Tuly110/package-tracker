import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/repositories/tracking_repository.dart';

import '../../../../core/error/failures.dart';

@lazySingleton
class DeleteTrackingUsecase {
  final TrackingRepository repository;

  DeleteTrackingUsecase(this.repository);

  Future<Either<Failure, void>> call({required int idTracking}){
    return repository.deleteTracking(idTracking: idTracking);
  }
}