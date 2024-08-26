import 'package:flutter/material.dart';
import 'package:internship_project/feature/account/screens/account_screen.dart';
import 'package:internship_project/feature/account/screens/create_account_screen.dart';
import 'package:internship_project/feature/account/screens/edit_account_screen.dart';
import 'package:internship_project/feature/account/screens/mod_tool_screen.dart';
import 'package:internship_project/feature/auth/screen/login_screen.dart';
import 'package:internship_project/feature/home/screens/home_screen.dart';
import 'package:internship_project/feature/post/screens/add_post_type_screen.dart';
import 'package:internship_project/feature/post/screens/comment_screen.dart';
import 'package:internship_project/feature/user_profile/screens/edit_profile_screen.dart';
import 'package:internship_project/feature/user_profile/screens/userprofile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute =
    RouteMap(routes: {'/': (_) => const MaterialPage(child: LoginScreen())});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomePage()),
  '/create-account': (_) => const MaterialPage(child: AccountScreen()),
  '/:name': (route) => MaterialPage(
          child: AccountScreen1(
        name: route.pathParameters['name']!,
      )),
  '/mod-tools/:name': (routeData) => MaterialPage(
          child: ModToolScreen(
        name: routeData.pathParameters['name']!,
      )),
  '/edit-account/:name': (routeData) => MaterialPage(
          child: EditAccountScreen(
        name: routeData.pathParameters['name']!,
      )),
  '/u/:uid': (routeData) => MaterialPage(
          child: UserProfileScreen(
        uid: routeData.pathParameters['uid']!,
      )),
  '/add-post/:type': (routeData) => MaterialPage(
          child: AddPostTypeScreen(
        type: routeData.pathParameters['type']!,
      )),
  '/edit-profile/:uid': (routeData) => MaterialPage(
          child: EditProfileScreen(
        uid: routeData.pathParameters['uid']!,
      )),
  '/post/:postId/comments':(route) => MaterialPage(
          child: CommentScreen(
        postId: route.pathParameters['postId']!,
      )),
});
