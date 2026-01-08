
import 'package:dartz/dartz.dart';
import 'package:my_tracker_app/src/modules/carrier/data/models/carrier_model.dart';

import '../../../../core/error/failures.dart';

abstract class CarrierRepository {
  Future<Either<Failure, List<CarrierModel>>> getCarriers();
}