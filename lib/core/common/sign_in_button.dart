import 'package:internship_project/core/constant/constants.dart';
import 'package:internship_project/feature/auth/controller/auth_controller.dart';
import 'package:internship_project/theme/pallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInButton extends ConsumerWidget{
  final bool isFromLogin;
  const SignInButton({super.key, this.isFromLogin=true});

  void signInWithGoogle(BuildContext context, WidgetRef ref){
    ref.read(authControllerProvider.notifier).signInWithGoogle(context, isFromLogin);

  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(context, ref), 
        icon: Image.asset(Constants.googlePath, width: 30,), 
        label: const Text('SignIn with Google',
        style: TextStyle(
          fontSize: 17,
          color: Pallet.blackColor,
        ),),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(218, 255, 254, 254),
          minimumSize: const Size(double.infinity, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )
        ),
        ),
    );
  }
}