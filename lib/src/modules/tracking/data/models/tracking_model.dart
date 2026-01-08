import 'package:freezed_annotation/freezed_annotation.dart';

part 'tracking_model.freezed.dart';
part 'tracking_model.g.dart';

@freezed
class TrackingModel with _$TrackingModel {
  const TrackingModel._();

  const factory TrackingModel({
    required String number,               
    String? status,      
    int? carrier,                         
    String? alias,                        
    required DateTime register_time,      
    String? latest_event_info,            
  }) = _TrackingModel;

  factory TrackingModel.fromJson(Map<String, dynamic> json) => _$TrackingModelFromJson(json);
  
}

