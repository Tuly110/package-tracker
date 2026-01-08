import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/usecases/delete_tracking_usecase.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/usecases/register_usecase.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/usecases/tracking_details_usecase.dart';
import 'package:my_tracker_app/src/modules/tracking/presentation/cubit/tracking_state.dart';

import '../../domain/entities/tracking_entity.dart';
import '../../domain/usecases/traking_list_usecase.dart';

@injectable
class TrackingCubit extends Cubit<TrackingState> {
  final RegisterUseCase registerUseCase;
  final TrackingListUsecase trackingListUseCase;
  final DeleteTrackingUsecase deleteTrackingUsecase;
  final TrackingDetailsUsecase trackingDetailsUsecase;

  List<TrackingEntity> _trackings = [];

  TrackingCubit(
    this.registerUseCase,
    this.trackingListUseCase,
    this.deleteTrackingUsecase,
    this.trackingDetailsUsecase,
  ): super(const TrackingState.initial());

  Future<void> registerTracking(
      String trackingNumber,
      String? carrierCode,
      String? memo,
      String? category,
    ) async {
    emit(const TrackingState.loading());
    final result = await registerUseCase(
      trackingNumber: trackingNumber,
      carrierCode: carrierCode,
      memo: memo,
      category: category,
    );

    result.fold(
      (failure) {
        emit(TrackingState.error(failure.message));
      },
      (tracking) async {
        emit(TrackingState.success(tracking));

        _trackings = [..._trackings, tracking];
        emit(TrackingState.successList(_trackings));

        // fetch lại từ API để đồng bộ
        final listResult = await trackingListUseCase();
        listResult.fold(
          (failure) => emit(TrackingState.error(failure.message)),
          (trackings) {
            _trackings = trackings;
            emit(TrackingState.successList(_trackings));
          },
        );
      }
    );

  }

  Future<void> getTrackingList() async {
    emit(const TrackingState.loading());

    final result = await trackingListUseCase();

    result.fold(
      (failure) => emit(const TrackingState.error('Failed to fetch tracking list')),
      (trackingList) => emit(TrackingState.successList(trackingList)),
    );    
  }

  Future<void> getTrackingDetails(String trackingNumber,String carrierCode, ) async{
    emit(const TrackingState.loading());

    final result = await trackingDetailsUsecase(
      trackingNumber: trackingNumber,
      carrierCode: carrierCode,
      // userId: userId
    );

    result.fold(
      (failure) => emit(TrackingState.error(failure.message)),
      (tracking) => emit(TrackingDetails(tracking)),
    );
  }

  Future<void> deleteTrackingById(int idTracking) async {
    emit(const TrackingState.loading());
    final result = await deleteTrackingUsecase(idTracking: idTracking);

    result.fold(
      (failure) => emit(TrackingState.error(failure.message)),
      (_) async {
        emit(const TrackingState.delete());
        await fetchTrackings(); // reload list
      },
      
    );
  }

  Future<void> fetchTrackings() async {
    emit(const TrackingState.loading());
    final result = await trackingListUseCase();

    result.fold(
      (failure) => emit(TrackingState.error(failure.message)),
      (trackings) {
        emit(TrackingState.successList(trackings));
      },
    );
  }


}