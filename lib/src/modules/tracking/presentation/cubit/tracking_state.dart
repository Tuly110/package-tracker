import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/entities/tracking_details_entity.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/entities/tracking_entity.dart';

part 'tracking_state.freezed.dart';
@freezed
class TrackingState with _$TrackingState {
  const factory TrackingState.initial() = TrackingInitial;
  const factory TrackingState.loading() = TrackingLoading;
  const factory TrackingState.success(TrackingEntity tracking) = TrackingSuccess;
  const factory TrackingState.successList(List<TrackingEntity> trackings) = TrackingSuccessList;
  const factory TrackingState.details(TrackingDetailEntity tracking) = TrackingDetails;
  const factory TrackingState.error(String message) = TrackingError;
  const factory TrackingState.delete() = _Delete;
}