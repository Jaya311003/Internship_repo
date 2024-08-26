import 'package:flutter/material.dart';
import 'package:internship_project/feature/feed/feed_screen.dart';
//import 'package:internship_project/features/feed/feed_screen.dart';
//import 'package:internship_project/feature/home/screens/home_screen.dart';
import 'package:internship_project/feature/post/screens/add_post_screen.dart';
//import 'package:internship_project/features/post/screens/add_post_screen.dart';

class Constants {
  static const logoPath = 'assets/images/profilePic.jpg';
  static const loginEmotePath = 'assets/images/login.png';
  static const googlePath = 'assets/images/Google_logo.png';

  static const bannerDefault =
      'assets/images/banner.jpg';
  static const avatarDefault =
      'assets/images/avatar.jpg';

  static const tabWidgets = [
    FeedScreen(),
    AddPostScreen(),
  ];

  static const IconData up = IconData(0xe800, fontFamily: 'MyFlutterApp', fontPackage: null);
  static const IconData down = IconData(0xe801, fontFamily: 'MyFlutterApp', fontPackage: null);

  /*static const awardsPath = 'assets/images/awards';

  static const awards = {
    'awesomeAns': '${Constants.awardsPath}/awesomeanswer.png',
    'gold': '${Constants.awardsPath}/gold.png',
    'platinum': '${Constants.awardsPath}/platinum.png',
    'helpful': '${Constants.awardsPath}/helpful.png',
    'plusone': '${Constants.awardsPath}/plusone.png',
    'rocket': '${Constants.awardsPath}/rocket.png',
    'thankyou': '${Constants.awardsPath}/thankyou.png',
    'til': '${Constants.awardsPath}/til.png',
  };*/
}