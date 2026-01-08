
import 'package:freezed_annotation/freezed_annotation.dart';

part 'carrier_model.freezed.dart';
part 'carrier_model.g.dart';

@freezed
class CarrierModel with _$CarrierModel {
  const CarrierModel._();
  
  const factory CarrierModel({
    @JsonKey(name: 'key')  int? key,
    @JsonKey(name: '_name')  String? name,
    @JsonKey(name: '_country_iso')  String? country,
    @JsonKey(name: '_type') String? type, 
  }) = _CarrierModel;

  factory CarrierModel.fromJson(Map<String, dynamic> json) =>
      _$CarrierModelFromJson(json);


}