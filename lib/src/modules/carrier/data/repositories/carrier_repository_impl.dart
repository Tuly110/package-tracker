import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/carrier_repository.dart';
import '../models/carrier_model.dart';

@LazySingleton(as: CarrierRepository)
class CarrierRepositoryImpl implements CarrierRepository {
  @override
  Future<Either<Failure, List<CarrierModel>>> getCarriers() async {
    try {
      final jsonString = await rootBundle.loadString('assets/apicarrier.all.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final carriers = jsonList.map((json) => CarrierModel.fromJson(json)).toList();
      return Right(carriers);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}