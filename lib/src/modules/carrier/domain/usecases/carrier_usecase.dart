import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/modules/carrier/data/models/carrier_model.dart';
import 'package:my_tracker_app/src/modules/carrier/domain/repositories/carrier_repository.dart';

import '../../../../core/error/failures.dart';

@lazySingleton

class CarrierUsecase {
  final CarrierRepository repository;

  CarrierUsecase(this.repository);

 Future<Either<Failure, List<CarrierModel>>> call() {
    return repository.getCarriers();
  }
  
}