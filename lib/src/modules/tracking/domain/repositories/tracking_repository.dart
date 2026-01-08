import 'package:dartz/dartz.dart';
import 'package:my_tracker_app/src/core/error/failures.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/entities/tracking_details_entity.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/entities/tracking_entity.dart';


abstract class TrackingRepository{
  Future<Either<Failure, TrackingEntity>> registerTracking({
    required String trackingNumber, String ? carrierCode, String ? memo, String ? category,
  });
  Future<Either<Failure, List<TrackingEntity>>> getTrackingList();
  Future<Either<Failure, TrackingDetailEntity>> getTrackingDetails(
    String trackingNumber, String carrierCode,);
  Future<Either<Failure, void>> deleteTracking({
   required int idTracking,
  });

  
}