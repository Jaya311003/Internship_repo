import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship_project/core/common/error_text.dart';
import 'package:internship_project/core/common/loader.dart';
import 'package:internship_project/feature/auth/controller/auth_controller.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:internship_project/models/user_model.dart';
import 'package:internship_project/router.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate();
  runApp(const ProviderScope(child:MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  UserModel? userModel;

  void getData(WidgetRef ref, User data) async{
    userModel = await ref.watch(authControllerProvider.notifier).getUserData(data.uid).first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(data: (data) =>MaterialApp.router(
      title: 'Blog App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        if(data!=null){
          getData(ref, data);
          if(userModel !=null)
          {
            return loggedInRoute;
          }
        }
        return loggedOutRoute;
      }),
      routeInformationParser: const RoutemasterParser(),
      debugShowCheckedModeBanner: false,
    ),
    error: (error, stackTrace) => ErrorText(error: error.toString()),
    loading: () => const Loader(),
    ); 
  }
}


