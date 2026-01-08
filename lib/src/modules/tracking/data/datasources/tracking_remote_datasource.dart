import 'package:my_tracker_app/src/modules/tracking/domain/entities/tracking_details_entity.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/entities/tracking_entity.dart';

abstract class TrackingRemoteDatasource {
  Future<TrackingEntity> registerTracking({required String trackingNumber, String? carrierCode, String? memo, String? category,});
  Future<List<TrackingEntity>> getTrackingList();
  Future<TrackingDetailEntity> getTrackingDetails( String trackingNumber, String carrierCode);
  Future<void> deleteTracking(int idTracking);
}