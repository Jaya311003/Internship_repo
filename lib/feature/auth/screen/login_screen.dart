import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship_project/core/common/loader.dart';
import 'package:internship_project/core/common/sign_in_button.dart';
import 'package:internship_project/core/constant/constants.dart';
import 'package:internship_project/feature/auth/controller/auth_controller.dart';
import 'package:internship_project/theme/pallet.dart';
import 'package:flutter/material.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInAsGuest(WidgetRef ref, BuildContext context){
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog App", style: TextStyle(
          fontWeight:FontWeight.bold,
          color: Pallet.whitecolor,
        ),),
        actions: [
          TextButton(
            onPressed: ()=> signInAsGuest(ref,context), 
            child:const Text('Skip',
             style: TextStyle(
              fontWeight: FontWeight.bold,
             ),
            ) 
            )
        ],
        backgroundColor: Pallet.blackColor,
      ),
      body: isLoading? const Loader(): Center(
        child: Column(
          children: [
            const SizedBox(height: 30,),
            const Text('Dive into Anything',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 0.5,
            ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(Constants.loginEmotePath,
              height: 300,
              ),
            ),
            const SizedBox(height: 20,),
            const SignInButton(),
        
          ],
          
        ),
      ),
    );
  }
}