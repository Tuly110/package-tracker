import '../entities/notify_entity.dart';

abstract class NotifyRepository {
  Future<List<NotifyEntity>> getNotifications();
  Future<void> updateNotificationStatus(String id, String status);
  Future<void> deleteNotification(String id);
}
