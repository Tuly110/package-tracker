import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/entities/tracking_details_entity.dart';

import '../../../../core/error/failures.dart';
import '../repositories/tracking_repository.dart';

@lazySingleton
class TrackingDetailsUsecase {
  final TrackingRepository repository;

  TrackingDetailsUsecase(this.repository);

   Future<Either<Failure, TrackingDetailEntity>> call({
    required String trackingNumber,
    required String carrierCode,
  }) {
    return repository.getTrackingDetails(trackingNumber, carrierCode, );
  }
}