import 'package:freezed_annotation/freezed_annotation.dart';

part 'tracking_entity.freezed.dart';
part 'tracking_entity.g.dart';

@freezed
abstract class TrackingEntity with _$TrackingEntity {
  const TrackingEntity._();
  const factory TrackingEntity({
    @JsonKey(name: 'id') int? id,
    required String number,               
    String? status,  
    String? carrier,                         
    String? alias,         
    String? category,          
    required DateTime register_time,      
    String? latest_event_info, 
    int? userId,
    Map<String, dynamic>? tracking_info,
  }) = _TrackingEntity;

  factory TrackingEntity.fromJson(Map<String, dynamic> json) => _$TrackingEntityFromJson(json);

  String? get latestStatus =>
      tracking_info?['latest_status']?['status'] as String?;
}


