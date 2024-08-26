

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship_project/feature/account/controller/account_controller.dart';
import 'package:internship_project/core/common/error_text.dart';
import 'package:internship_project/core/common/loader.dart';
import 'package:internship_project/core/common/post_card.dart';
import 'package:internship_project/feature/auth/controller/auth_controller.dart';
import 'package:internship_project/models/acccount_model.dart';
import 'package:routemaster/routemaster.dart';

class AccountScreen1 extends ConsumerWidget {
  final String name;
  const AccountScreen1({super.key, required this.name});

void navigateToModTools(BuildContext context){
  Routemaster.of(context).push('/mod-tools/$name');
}

void joinAccount(WidgetRef ref, Account account, BuildContext context){
  ref.read(accountControllerProvider.notifier).joinAccount(account, context);
}
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user= ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      body: ref.watch(getAccountByNameProvider(name)).when(
        data: (account) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled){
            return [
              SliverAppBar(
                expandedHeight: 150,
                floating: true,
                snap: true,
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(account.banner, fit: BoxFit.cover,))
                  ],
                  
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(delegate: SliverChildListDelegate([
                  Align(
                    alignment: Alignment.topLeft,
                    child:CircleAvatar(
                      backgroundImage: NetworkImage(account.avatar),
                      radius: 35,
                    )
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(account.name,
                      style:const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),),
                      if(!isGuest)
                      account.mods.contains(user.uid)?
                      OutlinedButton(
                        onPressed:() {
                           navigateToModTools(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                        ), 
                        child: const Text('Mod tools')):
                        OutlinedButton(
                        onPressed: ()=> joinAccount(ref, account, context),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                        ), 
                        child:Text(account.member.contains(user.uid) ?'Joined':'Join'))
                    ],
                  ),
                  Padding(padding: const EdgeInsets.only(top: 10),
                  child: Text('${account.member.length} members'),
                  )
                ])),
                )
            ];
          }, 
          body: ref.watch(getAccountPostProvider(name)).when(
            data: (data) {
              return  ListView.builder(
              //shrinkWrap: true,// extra line
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final post = data[index];
                return  PostCard(post: post);
              }
          );
            }, 
            error: (error, stackTrace) {
             //print(error);
              return ErrorText(error: error.toString());
            },
        loading: ()=> const Loader(),),
          ),
        
        error: (error, stackTrace) => ErrorText(error: error.toString()), 
        loading: ()=> const Loader(),
        ),
    );
  }
}