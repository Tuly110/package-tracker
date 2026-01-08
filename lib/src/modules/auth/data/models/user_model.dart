import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_tracker_app/src/modules/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._(); 

  const factory UserModel({
    @JsonKey(fromJson: _idFromJson) required String id,
    required String email,
    required String username,
    @JsonKey(name: 'accessToken')  String? accessToken, 
    @JsonKey(name: 'refreshToken')  String? refreshToken, 
    String? imgAvatar, 
    String? methodLogin,
  }) = _UserModel;

  factory UserModel.fromFirebaseUser(firebase.User user) {
    return UserModel(
      id: user.uid,
      email: user.email!,
      username: user.displayName ?? 'New User',
      imgAvatar: user.photoURL,
      accessToken: '',
      refreshToken: '',
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      username: username,
      imgAvatar: imgAvatar,
      accessToken: accessToken ?? '',
      refreshToken: refreshToken ?? '',
    );
  }
}


String _idFromJson(dynamic id) {
  if (id is int) return id.toString();
  if (id is String) return id;
  return ''; // Fallback
}
