import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:internship_project/core/constant/constants.dart';
import 'package:internship_project/feature/account/repository/account_repository.dart';
import 'package:internship_project/core/failure.dart';
import 'package:internship_project/core/provider/storage_repository_provider.dart';
import 'package:internship_project/core/utils.dart';
import 'package:internship_project/feature/auth/controller/auth_controller.dart';
import 'package:internship_project/models/acccount_model.dart';
import 'package:internship_project/models/post_model.dart';
import 'package:routemaster/routemaster.dart';

final userAccountProvider = StreamProvider((ref){
  final accountController = ref.watch(accountControllerProvider.notifier);
  return accountController.getUserAccounts();
});

final getAccountPostProvider = StreamProvider.family((ref, String name) {
  final accountController = ref.watch(accountControllerProvider.notifier);
  return accountController.getAccountPosts(name);
});

final accountControllerProvider = StateNotifierProvider<AccountController,bool>((ref) {
  final accountRepository = ref.watch(accountRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return AccountController(
    accountRepository: accountRepository, 
    ref: ref,
    storageRepository: storageRepository,
    );
});

final getAccountByNameProvider = StreamProvider.family((ref, String name){
   return ref.watch(accountControllerProvider.notifier).getAccountByName(name);
});

final searchAccountProvider = StreamProvider.family((ref, String query) {
   return ref.watch(accountControllerProvider.notifier).searchAccount(query);
});


class AccountController extends StateNotifier<bool> {
 
  final AccountRepository _accountRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  AccountController({
    required AccountRepository accountRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _accountRepository = accountRepository,
        _ref = ref,
        _storageRepository=storageRepository,
        super(false);

  void createAccount(String name, BuildContext context) async{
    state=true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Account account = Account(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      member: [uid],
      mods: [uid],
    );

    final res = await _accountRepository.createAccount(account);
    state=false;
    res.fold((l) => showSnackBar(context,l.message), (r) {
       showSnackBar(context, 'Account created successfully');
       Routemaster.of(context).pop();
    });
  }

  void joinAccount(Account account, BuildContext context) async{
    final user = _ref.read(userProvider)!;
    Either<Failure, void> res;
    if(account.member.contains(user.uid)){
      res=await _accountRepository.leaveAccount(account.name, user.uid);
    } else{
      res = await _accountRepository.joinAccount(account.name, user.uid);
    }

    res.fold((l) => showSnackBar(context, l.message), (r) {
      if(account.member.contains(user.uid)){
        showSnackBar(context, 'leave the group successfully');
      } else{
        showSnackBar(context, 'Join the group successfully');
      }
    });
  }

  Stream<List<Account>> getUserAccounts(){
    final uid = _ref.read(userProvider)!.uid;
    return _accountRepository.getUserAccounts(uid);
  }

   Stream<Account> getAccountByName(String name){
    return _accountRepository.getAccountByName(name);
   }
  
  Stream<List<Account>> searchAccount(String query){
    return _accountRepository.searchAccount(query);
  }
  void editAccount({
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
    required Account account,
  }) async{
    state= true;
    if(profileFile != null){
      final res = await _storageRepository.storeFile(path: 'accounts/profile', id: account.name, file: profileFile);
      res.fold((l) => showSnackBar(context, l.message), (r) => account = account.copyWith(avatar: r));
    }
    if(bannerFile != null){
      final res = await _storageRepository.storeFile(path: 'accounts/banner', id: account.name, file: bannerFile);
      res.fold((l) => showSnackBar(context, l.message), (r) => account = account.copyWith(banner: r));
    }
    final res = await _accountRepository.editAccount(account);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => Routemaster.of(context).pop());
  }
   Stream<List<Post>> getAccountPosts(String accountName){
    return _accountRepository.getAccountPosts(accountName);
  }
}
