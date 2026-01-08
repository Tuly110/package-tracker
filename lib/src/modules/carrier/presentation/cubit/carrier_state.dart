import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_tracker_app/src/modules/carrier/data/models/carrier_model.dart';

part 'carrier_state.freezed.dart';
@freezed

class  CarrierState with _$CarrierState {
  const factory CarrierState.initial() = CarrierInitial;
  const factory CarrierState.success(List<CarrierModel > carriers) = CarrierSuccess;
  const factory CarrierState.loading() = CarrierLoading;
  const factory CarrierState.error(String message) = CarrierError;
}