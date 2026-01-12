import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/entities/tracking_details_entity.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/entities/tracking_entity.dart';

import '../../../../core/data/remote/interceptors/auth_interceptor.dart';
import 'tracking_remote_datasource.dart';

@LazySingleton(as: TrackingRemoteDatasource)
class TrackingRemoteDatasourceImpl implements TrackingRemoteDatasource {
  final Dio dio;

  TrackingRemoteDatasourceImpl()
      : dio = Dio(BaseOptions(
          baseUrl: "https://unheeled-avery-mythical.ngrok-free.dev/api/auth",
          connectTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 3000),
        )) {
    dio.interceptors.add(AuthInterceptor());
  }

  int? _parseId(dynamic id) {
    if (id == null) return null;
    if (id is int) return id;
    return int.tryParse(id.toString());
  }

  @override
  Future<TrackingEntity> registerTracking({
    required String trackingNumber,
    String? carrierCode,
    String? memo,
    String? category,
  }) async {
    final response = await dio.post(
      "/add-order",
      data: {
        "tracking_number": trackingNumber,
        "carrier_code": carrierCode, 
        "note": memo,                
        "category": category,        
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;

      return TrackingEntity(
        id: _parseId(data['id']),
        number: data["tracking_number"] ?? '',
        carrier: data["carrier_name"],
        alias: data["note"],
        category: data["category"],
        register_time:
            DateTime.tryParse(data["createdAt"] ?? '') ?? DateTime.now(),
        status: (data["status"] != null && data["status"].toString().isNotEmpty)
            ? data["status"]
            : (data["tracking_info"]?["track_info"]?["latest_status"]?["status"] ?? 'Pending'),
        tracking_info: data["tracking_info"],
      );
    } else {
      throw Exception("Failed to add order: ${response.statusCode}");
    }
  }

  @override
  Future<List<TrackingEntity>> getTrackingList() async {
    final response = await dio.get(
      "/get-orders",
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = response.data;
      return list
          .map((e) => TrackingEntity(
                id: _parseId(e['id']),
                number: e["tracking_number"] ?? '',
                carrier: e["carrier_name"],
                alias: e["note"],
                category: e["category"],
                register_time:
                    DateTime.tryParse(e["createdAt"] ?? '') ?? DateTime.now(),
                // status: e["status"] ?? '',
                status: e["status"] ?? 
                        e["tracking_info"]?["track_info"]?["latest_status"]?["status"] ?? 
                        'Pending',
                tracking_info: e["tracking_info"],
              ))
          .toList();
    } else {
      throw Exception('API error: ${response.data["code"]}');
    }
  }

  @override
  Future<TrackingDetailEntity> getTrackingDetails(
      String trackingNumber, String carrierCode) async {
    final response = await dio.post("/get-order-by-trackingnumber", data: {
      "tracking_number": trackingNumber,
      "carrier_code": carrierCode,
    });

    print('Raw details tracking: ${jsonEncode(response.data)}');

    if (response.statusCode == 200) {
      return TrackingDetailEntity.fromJson(response.data);
    } else {
      throw Exception(
        response.data["message"] ??
            response.data["data"]?["errors"]?[0]?["message"] ??
            'Unknown error',
      );
    }
  }

  @override
  Future<void> deleteTracking(int idTracking) async {
    final response = await dio.post(
      '/delete-order',
      data: {'id': idTracking},
    );

    if (response.statusCode != 200 || response.data['message'] == null) {
      throw Exception(response.data['message'] ?? 'Delete failed');
    }
  }
}
