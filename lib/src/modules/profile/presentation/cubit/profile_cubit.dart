import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/modules/profile/presentation/cubit/profile_state.dart';

import '../../../auth/domain/usecases/update_user_usecase.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final UpdateUserUsecase _updateUserUsecase;

  ProfileCubit(this._updateUserUsecase) : super(const ProfileState.initial());

  Future<void> updateProfile(
    String userId, String tokenDevice, String username, String email) async {
  emit(const ProfileState.loading());
  final result = await _updateUserUsecase(userId, tokenDevice, username, email);
  result.fold(
    (failure) => emit(ProfileState.error(failure.message)),
    (_) => emit(const ProfileState.loaded("User information updated successfully!")),
  );
}

}
