import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/entities/tracking_entity.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/repositories/tracking_repository.dart';

import '../../../../core/error/failures.dart';

@lazySingleton
class TrackingListUsecase{
  final TrackingRepository repository;

  TrackingListUsecase(this.repository);

  Future<Either<Failure, List<TrackingEntity>>> call(){
    return repository.getTrackingList();
  }
}