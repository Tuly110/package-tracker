import 'package:injectable/injectable.dart';

import '../repositories/notify_repository.dart';

@lazySingleton
class UpdateNotifyUsecase {
  final NotifyRepository repository;
  UpdateNotifyUsecase(this.repository);

  Future<void> call(String id, String status) =>
      repository.updateNotificationStatus(id, status);
}