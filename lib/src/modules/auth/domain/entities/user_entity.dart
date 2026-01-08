import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    @JsonKey(fromJson: _idFromJson) required String id,
    required String username,
    required String email,
    String? accessToken,
    String? refreshToken,
    String? tokenDevice,
    String? methodLogin,
    String? imgAvatar,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);
}

String _idFromJson(dynamic id) {
  if (id is int) return id.toString();
  if (id is String) return id;
  return ''; // Fallback
}
