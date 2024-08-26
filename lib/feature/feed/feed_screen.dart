import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship_project/feature/account/controller/account_controller.dart';
import 'package:internship_project/core/common/error_text.dart';
import 'package:internship_project/core/common/loader.dart';
import 'package:internship_project/core/common/post_card.dart';
import 'package:internship_project/feature/auth/controller/auth_controller.dart';
import 'package:internship_project/feature/post/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    if(isGuest){
      return ref.watch(userAccountProvider).when(
      data: (accounts)=> ref.watch(userPostProvider(accounts)).when(
        data: (data) {
          return Expanded(
            child: ListView.builder(
              //shrinkWrap: true,// extra line
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final post = data[index];
                return  PostCard(post: post);
              }),
          );
        },
        error: (error, stackTrace) {
          //print(error);
          return ErrorText(error: error.toString());
        } ,
        
        loading: ()=> const Loader(), 
        ), 
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: ()=> const Loader(),
      );
    }
    return ref.watch(userAccountProvider).when(
      data: (accounts)=> ref.watch(guestPostProvider).when(
        data: (data) {
          return Expanded(
            child: ListView.builder(
              //shrinkWrap: true,// extra line
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final post = data[index];
                return  PostCard(post: post);
              }),
          );
        },
        error: (error, stackTrace) {
          //print(error);
          return ErrorText(error: error.toString());
        } ,
        
        loading: ()=> const Loader(), 
        ), 
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: ()=> const Loader(),
      );
  }
  }
