import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship_project/feature/account/controller/account_controller.dart';
import 'package:internship_project/core/common/error_text.dart';
import 'package:internship_project/core/common/loader.dart';
import 'package:routemaster/routemaster.dart';

class SearchAccountDelegates extends SearchDelegate{
  final WidgetRef ref;
  
  SearchAccountDelegates(this.ref);
  @override
  List<Widget>? buildActions(BuildContext context){
      return [
        IconButton(
          onPressed: (){
            query='';
          }, 
          icon: const Icon(Icons.close))
      ];
    }
  @override
  Widget? buildLeading(BuildContext context){
   return null;
  }

  @override
  Widget buildResults(BuildContext context){
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context){
    return ref.watch(searchAccountProvider(query)).when(
      data: (accounts)=>ListView.builder(
        itemCount: accounts.length,
        itemBuilder:(BuildContext context, int index) {
          final account = accounts[index];
          return ListTile(
            leading: /*Image.asset('assets/images/profilePic.jpg'),*/CircleAvatar(
              backgroundImage: NetworkImage(account.avatar),
            ),
            title: Text(account.name),
            onTap: ()=> navigateToAccount(context, account.name),
          );
        } ,
        ), 
      error: (error, stackTrace) => ErrorText(error: error.toString()) , 
      loading:()=> const Loader());
  }
  void navigateToAccount(BuildContext context, String accountName) {
    Routemaster.of(context).push(accountName);
  }
}