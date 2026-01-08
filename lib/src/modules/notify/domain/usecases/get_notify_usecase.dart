import 'package:injectable/injectable.dart';

import '../entities/notify_entity.dart';
import '../repositories/notify_repository.dart';

@lazySingleton
class GetNotifyUsecase {
  final NotifyRepository repository;
  GetNotifyUsecase(this.repository);

  Future<List<NotifyEntity>> call() {
    return repository.getNotifications();
  }
}