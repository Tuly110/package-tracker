import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/tracking_details_entity.dart';

part 'tracking_details_model.freezed.dart';
part 'tracking_details_model.g.dart';

@freezed
class TrackingDetailModel with _$TrackingDetailModel {
  const factory TrackingDetailModel({
    required Map<String, dynamic> rawData,
  }) = _TrackingDetailModel;

  factory TrackingDetailModel.fromJson(Map<String, dynamic> json) =>
      TrackingDetailModel(rawData: json);
}

extension TrackingDetailModelX on TrackingDetailModel {
  TrackingDetailEntity toEntity() {
    return TrackingDetailEntity(rawData: rawData);
  }
}


