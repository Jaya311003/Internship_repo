import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship_project/feature/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget{
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref){
    ref.read(authControllerProvider.notifier).logOut();
  }
  void navigateToUserProfile(BuildContext context, String uid){
     Routemaster.of(context).push('/u/$uid');
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref){
      final user = ref.watch(userProvider)!;

      return Drawer(
        child: SafeArea(
          child: Column(
            children: [
             CircleAvatar(backgroundImage: NetworkImage(user.profilePic), radius: 70,),
              const SizedBox(height: 10,),
              Text(user.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 10,),
              const Divider(),
              ListTile(
                title: const Text('My Profile'),
                leading: const Icon(Icons.person),
                onTap: ()=> navigateToUserProfile(context, user.uid),
              ),
              ListTile(
                title: const Text('Logout'),
                leading: const Icon(Icons.logout,
                color: Colors.red),
                onTap: ()=> logOut(ref),
              )
            ],
          ),
          )
      );
  }
}