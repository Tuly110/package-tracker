import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:my_tracker_app/src/modules/carrier/data/models/carrier_model.dart';

abstract class CarrierLocalDatasource{
  Future<List<CarrierModel>> getCarriers();
}

// implements
class CarrierLocalDatasourceImpl implements CarrierLocalDatasource{
  @override
  Future<List<CarrierModel>> getCarriers() async {
    final jsonString = await rootBundle.loadString('assets/data/apicarrier.all.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => CarrierModel.fromJson(e)).toList();
  }
}