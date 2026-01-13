import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/modules/notify/domain/usecases/delete_notify_usecase.dart';
import 'package:my_tracker_app/src/modules/notify/domain/usecases/get_notify_usecase.dart';
import 'package:my_tracker_app/src/modules/notify/domain/usecases/update_notify_usecase.dart';

import 'notify_state.dart';

@injectable
class NotifyCubit extends Cubit<NotifyState> {
  final GetNotifyUsecase getNotifications;
  final UpdateNotifyUsecase updateNotification;
  final DeleteNotifyUsecase deleteNotification;

  int get unreadCount {
    final currentState = state;
    if(currentState is NotifyLoaded){
      return currentState.messages
          .where((m) => m.status == 'new'|| m.status == null)
          .length;
    }
    return 0;
  }

  NotifyCubit({
    required this.getNotifications,
    required this.updateNotification,
    required this.deleteNotification,
  }) : super(const NotifyState.initial()) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    emit(const NotifyState.loading());
    try {
      final notifies = await getNotifications();
      emit(NotifyState.loaded(notifies));
    } catch (e) {
      emit(NotifyState.error(e.toString()));
    }
  }

  Future<void> markAsRead(String id) async {
    if (state is! NotifyLoaded) return;
    final current = (state as NotifyLoaded).messages;
    try {
      await updateNotification(id, 'read');
      final updated = current
          .map((n) => n.id == id ? n.copyWith(status: 'read') : n)
          .toList();
      emit(NotifyState.loaded(updated));
    } catch (e) {
      emit(NotifyState.error(e.toString()));
    }
  }

  Future<void> removeNotification(String id) async {
    if (state is! NotifyLoaded) return;
    final current = (state as NotifyLoaded).messages;
    try {
      await deleteNotification(id);
      final updated = current.where((n) => n.id != id).toList();
      emit(NotifyState.loaded(updated));
    } catch (e) {
      emit(NotifyState.error(e.toString()));
    }
  }
}
