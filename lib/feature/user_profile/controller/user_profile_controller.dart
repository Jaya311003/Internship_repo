import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship_project/core/provider/storage_repository_provider.dart';
import 'package:internship_project/core/utils.dart';
import 'package:internship_project/feature/auth/controller/auth_controller.dart';
import 'package:internship_project/feature/user_profile/repository/user_profile_repository.dart';
import 'package:internship_project/models/post_model.dart';
import 'package:internship_project/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

final UserProfileControllerProvider = StateNotifierProvider<UserProfileController,bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository, 
    ref: ref,
    storageRepository: storageRepository,
    );
});

final getUserPostProvider = StreamProvider.family((ref, String uid) {
  final userProfileController = ref.watch(UserProfileControllerProvider.notifier);
  return userProfileController.getUserPosts(uid);
});



class UserProfileController extends StateNotifier<bool> {
 
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository=storageRepository,
        super(false);

   void editAccount({
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
    required String name,
  }) async{
    state= true;
    UserModel user = _ref.read(userProvider)!;
    if(profileFile != null){
      final res = await _storageRepository.storeFile(path: 'users/profile', id: user.uid, file: profileFile);
      res.fold((l) => showSnackBar(context, l.message), (r) => user = user.copyWith(profilePic: r));
    }
    if(bannerFile != null){
      final res = await _storageRepository.storeFile(path: 'users/banner', id: user.uid, file: bannerFile);
      res.fold((l) => showSnackBar(context, l.message), (r) => user = user.copyWith(banner: r));
    }
    user = user.copyWith(name: name);
    final res = await _userProfileRepository.editProfile(user);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    } 
    );
  }

  Stream<List<Post>> getUserPosts(String uid){
    return _userProfileRepository.getUserPosts(uid);
  }
}