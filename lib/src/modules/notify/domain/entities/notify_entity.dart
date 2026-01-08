import 'package:freezed_annotation/freezed_annotation.dart';

part 'notify_entity.freezed.dart';
part 'notify_entity.g.dart';

@freezed
class NotifyEntity with _$NotifyEntity {
  const factory NotifyEntity({
    @JsonKey(fromJson: _toString) String? id,
    @JsonKey(fromJson: _toString) String? message,
    @JsonKey(fromJson: _toString) String? status,
    @JsonKey(name: 'webhook_data') Map<String, dynamic>? data,
  }) = _NotifyEntity;

  factory NotifyEntity.fromJson(Map<String, dynamic> json) =>
      _$NotifyEntityFromJson(json);

  static List<NotifyEntity> listFromJson(List<dynamic> list) =>
    list.map((e) => NotifyEntity.fromJson(e as Map<String, dynamic>)).toList();
}

String? _toString(Object? value) => value?.toString();
