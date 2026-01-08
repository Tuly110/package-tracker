import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/core/error/failures.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/entities/tracking_details_entity.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/entities/tracking_entity.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/repositories/tracking_repository.dart';

import '../datasources/tracking_remote_datasource.dart';

@LazySingleton(as: TrackingRepository)
class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDatasource remoteDataSource;

  TrackingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> deleteTracking({required int idTracking}) async {
    try {
      await remoteDataSource.deleteTracking(idTracking);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }


 
  @override
  Future<Either<Failure, TrackingDetailEntity>> getTrackingDetails(String trackingNumber,  String carrierCode,) async {
    try {
      final result = await remoteDataSource.getTrackingDetails(trackingNumber,  carrierCode , );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }


  @override
  Future<Either<Failure, List<TrackingEntity>>> getTrackingList() 
  async {
    try{
      final result = await remoteDataSource.getTrackingList();
      return Right(result);

    }catch(e){
      return Left(ServerFailure(message: e.toString()));
    }
    
  }

  @override
  Future<Either<Failure, TrackingEntity>> registerTracking(
    {
      required dynamic trackingNumber, 
      String? carrierCode,
      String? memo,
      String? category,
    }) async {
    try{
      final result = await remoteDataSource.registerTracking(
        trackingNumber: trackingNumber,
        carrierCode: carrierCode,
        memo: memo,
        category: category,
      );
      return Right(result);
    }catch(e){
      return Left(ServerFailure(message: e.toString()));
    }
  }
}