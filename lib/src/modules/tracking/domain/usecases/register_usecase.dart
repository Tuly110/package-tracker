import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/core/error/failures.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/entities/tracking_entity.dart';

import '../repositories/tracking_repository.dart';

@lazySingleton

class RegisterUseCase{
  final TrackingRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, TrackingEntity>> call({
    required String trackingNumber, String ? carrierCode, String ? memo, String ? category,
  }) {
    return repository.registerTracking(trackingNumber: trackingNumber);
  }

  
}
