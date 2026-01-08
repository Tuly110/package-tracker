import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/modules/notify/domain/entities/notify_entity.dart';

import '../../../../core/data/remote/interceptors/auth_interceptor.dart';

/// Interface
abstract class FirebaseNotificationDataSource {
  Future<String?> getToken();

  Stream<NotifyEntity> onMessageStream();

  Future<void> saveTokenToServer(String token, String userId);

  Future<List<NotifyEntity>> fetchNotifications();

  Future<void> updateNotification(String notifyId, String status);

  Future<void> deleteNotification(String notifyId);
}

/// Implementation
@Injectable(as: FirebaseNotificationDataSource)
class FirebaseNotificationDataSourceImpl implements FirebaseNotificationDataSource {
  final Dio dio;
  final FirebaseMessaging _fcm;

  FirebaseNotificationDataSourceImpl(this.dio)
      : _fcm = FirebaseMessaging.instance {
    dio.interceptors.add(AuthInterceptor());
  }

  String get baseUrl => dio.options.baseUrl;

  @override
  Future<String?> getToken() => _fcm.getToken();

  @override
  Stream<NotifyEntity> onMessageStream() {
    return FirebaseMessaging.onMessage.map((remote) {
      return NotifyEntity(        
      message: remote.notification?.body,                         
      status: 'unread',                               
      data: remote.data,
      );
    });
  }

  @override
  Future<void> saveTokenToServer(String token, String userId) async {
    final url = '$baseUrl/api/notification/save-token';

    final response = await dio.post(
      url,
      data: {
        "token": token,
        "user_id": userId,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Lưu token thất bại: ${response.statusCode}');
    }
  }

  @override
  Future<List<NotifyEntity>> fetchNotifications() async {
    final url = '$baseUrl/api/v1/notifications';

    final response = await dio.get(url); // ✅ không cần tự thêm Authorization

    if (response.statusCode == 200) {
      final List data = response.data as List;
      return data.map((e) => NotifyEntity.fromJson(e)).toList();
    } else {
      throw Exception("Không lấy được danh sách notify");
    }
  }

  @override
  Future<void> updateNotification(String notifyId, String status) async {
    final url = '$baseUrl/api/v1/notifications/$notifyId';

    final response = await dio.put(
      url,
      data: {"status": status},
    );

    if (response.statusCode != 200) {
      throw Exception("Update notify thất bại");
    }
  }

  @override
  Future<void> deleteNotification(String notifyId) async {
    final url = '$baseUrl/api/v1/notifications/$notifyId';

    final response = await dio.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Delete notify thất bại");
    }
  }
}
