import 'package:injectable/injectable.dart';

import '../repositories/notify_repository.dart';

@lazySingleton
class DeleteNotifyUsecase {
  final NotifyRepository repository;
  DeleteNotifyUsecase(this.repository);

  Future<void> call(String id) async{
    return await repository.deleteNotification(id);
  }
}