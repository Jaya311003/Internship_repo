import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship_project/core/common/sign_in_button.dart';
import 'package:internship_project/feature/account/controller/account_controller.dart';
import 'package:internship_project/core/common/error_text.dart';
import 'package:internship_project/core/common/loader.dart';
import 'package:internship_project/feature/auth/controller/auth_controller.dart';
import 'package:internship_project/models/acccount_model.dart';
import 'package:routemaster/routemaster.dart';

class UserAccount extends ConsumerWidget {
  const UserAccount({super.key});

  void navigateToCreateAccount(BuildContext context) {
    Routemaster.of(context).push('/create-account');
  }
  void navigateToAccount(BuildContext context, Account account) {
    Routemaster.of(context).push('/${account.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [ isGuest? const SignInButton()
          : ListTile(
            title: const Text('Create an account'),
            leading:const Icon(Icons.add),
            onTap: () => navigateToCreateAccount(context),
          ),
          if(!isGuest)
             ref.watch(userAccountProvider).when(
                data: (accounts) => Expanded(
                  child: ListView.builder(
                    itemCount: accounts.length,
                    itemBuilder: (BuildContext context, int index){
                      final account = accounts[index];
                      return ListTile(
                        leading: /*Image.asset('assets/images/profilePic.jpg', width: 40, height: 40,),*/CircleAvatar(
                          backgroundImage: NetworkImage(account.avatar),
                        ),
                        title: Text(account.name),
                        onTap: (){
                          navigateToAccount(context, account);
                        },
                      );
                    },
                    ),
                ),
                error: (error, stackTrace) => ErrorText(error: error.toString()),
                loading: ()=> const Loader(),
              )
        ],
      )),
    );
  }
}
