import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/notify_entity.dart';
import '../../domain/repositories/notify_repository.dart';

@LazySingleton(as: NotifyRepository)
class NotifyRepositoryImpl implements NotifyRepository {
  final Dio _dio;

  NotifyRepositoryImpl(this._dio);

  @override
  Future<List<NotifyEntity>> getNotifications() async {
    final response = await _dio.get('/api/v1/notifications');
    if (response.statusCode == 200) {
      final data = response.data;
      final list = data is List ? data : (data is Map ? data['data'] : null);
      if (list is List) {
        return list.map((e) => NotifyEntity.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Unexpected response format when getting notifications');
      }
    } else {
      throw Exception('Failed to load notifications: ${response.statusCode}');
    }
  }

  @override
  Future<void> updateNotificationStatus(String id, String status) async {
    final response = await _dio.put('/api/v1/notifications/$id', data: {'status': status});
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update notification: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    final response = await _dio.delete('/api/v1/notifications/$id');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete notification: ${response.statusCode}');
    }
  }
}
