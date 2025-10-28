import 'dart:async';
import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/di/injection.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  //PROFILE USECASES
  final UpdateDisplayNameUseCase updateDisplayNameUseCase =
      getIt<UpdateDisplayNameUseCase>();
  final UpdateProfilePictureUseCase updateProfilePictureUseCase =
      getIt<UpdateProfilePictureUseCase>();
  final GetCurrentUserProfileUseCase getCurrentUserProfileUseCase =
      getIt<GetCurrentUserProfileUseCase>();

  ProfileBloc() : super(ProfileInitial()) {
    //PROFILE EVENTS
    on<ProfileUpdateDisplayNameRequested>(onProfileUpdateDisplayNameRequested);
    on<ProfileUpdatePictureRequested>(onProfileUpdatePictureRequested);
    on<ProfileLoadRequested>(onProfileLoadRequested);
  }

  //PROFILE HANDLERS
  Future<void> onProfileUpdateDisplayNameRequested(
    ProfileUpdateDisplayNameRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await updateDisplayNameUseCase.execute(
        UpdateDisplayNameUseCaseParams(displayName: event.displayName),
      );
      emit(const ProfileUpdated(message: 'Profile updated successfully!'));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> onProfileUpdatePictureRequested(
    ProfileUpdatePictureRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await updateProfilePictureUseCase.execute(NoParams());
      emit(
        const ProfileUpdated(message: 'Profile picture updated successfully!'),
      );
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! AuthAuthenticated) {
      if (FirebaseAuth.instance.currentUser == null) {
        emit(const ProfileError(message: 'User not authenticated'));
        return;
      }
    }
    emit(ProfileLoading());
    try {
      final profile = await getCurrentUserProfileUseCase.execute(NoParams());
      if (profile.uid != '') {
        emit(ProfileLoaded(profile: profile));
      } else {
        emit(const ProfileError(message: 'Failed to load user profile'));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
