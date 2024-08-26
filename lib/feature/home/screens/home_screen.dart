import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship_project/core/constant/constants.dart';
import 'package:internship_project/feature/auth/controller/auth_controller.dart';
import 'package:internship_project/feature/home/Drawer/account.dart';
import 'package:internship_project/feature/home/Drawer/profile_drawer.dart';
import 'package:internship_project/feature/home/delegates/search_account.dart';
import 'package:internship_project/theme/pallet.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key}) ;

  @override
  ConsumerState<ConsumerStatefulWidget> createState()=> _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>{
  int _page=0;

  void displayDrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }
  void displayEndDrawer(BuildContext context){
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanged(int page){
    setState(() {
      _page=page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallet.blackColor,
        title: const Text('Home',
        style: TextStyle(color: Pallet.whitecolor),
        ),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: ()=> displayDrawer(context), 
              icon: const Icon(Icons.menu, color: Pallet.whitecolor,),
              );
          }
        ),
          actions: [
            IconButton(
            onPressed: (){
              showSearch(context: context, delegate: SearchAccountDelegates(ref));
            }, 
            icon: const Icon(Icons.search, color: Pallet.whitecolor,),
            ),
            Builder(
              builder: (context) {
                return IconButton(
                  onPressed: ()=>displayEndDrawer(context), 
                  icon: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePic),
                  ),
                  );
              }
            ),
          
            
          ],
      ),
      
      body:Column(
        children: [
          const SizedBox(height: 10,),
          Constants.tabWidgets[_page],
        ],

      ) ,
      drawer: const UserAccount() ,
      endDrawer: isGuest? null : const ProfileDrawer(),
      bottomNavigationBar: isGuest? null : CupertinoTabBar(
        backgroundColor: Pallet.blackColor,
        activeColor: Pallet.whitecolor,
        items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home)),
        BottomNavigationBarItem(icon: Icon(Icons.add)),
      ],
      onTap: onPageChanged,
      currentIndex: _page,
      ),
    );
  }
}
