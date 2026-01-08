import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/modules/carrier/data/models/carrier_model.dart';
import 'package:my_tracker_app/src/modules/carrier/domain/usecases/carrier_usecase.dart';
import 'package:my_tracker_app/src/modules/carrier/presentation/cubit/carrier_state.dart';

@injectable

class CarrierCubit extends Cubit <CarrierState>{
  final CarrierUsecase carrierUsecase;

  List<CarrierModel> carriers = [];

  CarrierCubit(
    this.carrierUsecase
  ): super(const CarrierState.initial());

  Future<void> getCarriers() async {
    emit(const CarrierState.loading());
    final result = await carrierUsecase();
    result.fold(
      (failure) => emit(CarrierState.error(failure.message)),
      (carriers) => emit(CarrierState.success(carriers)),
    );
  }

}