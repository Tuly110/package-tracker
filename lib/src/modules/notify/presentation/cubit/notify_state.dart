import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notify_entity.dart';

part 'notify_state.freezed.dart';

@freezed
class NotifyState with _$NotifyState {
  const factory NotifyState.initial() = NotifyInitial;
  const factory NotifyState.loading() = NotifyLoading;
  const factory NotifyState.loaded(List<NotifyEntity> messages) = NotifyLoaded;
  const factory NotifyState.error(String message) = NotifyError;
}
