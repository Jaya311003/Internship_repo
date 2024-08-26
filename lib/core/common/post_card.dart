import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship_project/core/constant/constants.dart';
import 'package:internship_project/feature/auth/controller/auth_controller.dart';
import 'package:internship_project/feature/post/controller/post_controller.dart';
import 'package:internship_project/models/post_model.dart';
import 'package:internship_project/theme/pallet.dart';
import 'package:routemaster/routemaster.dart';



class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  void deletePost(WidgetRef ref, BuildContext context) async{
     ref.read(postControllerProvider.notifier).deletePost(post, context);
  }
  void upvotePost(WidgetRef ref) async{
     ref.read(postControllerProvider.notifier).upvote(post);
  }

   void downvotePost(WidgetRef ref) async{
     ref.read(postControllerProvider.notifier).downvote(post);
  }

  void navigateToComments(BuildContext context){
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText =  post.type == 'text';
    final isTypeLink =  post.type == 'link';
    final user = ref.watch(userProvider)!;
    
    final isGuest = !user.isAuthenticated;


    return Column(
          children: [
            Container(
              
              decoration:const BoxDecoration(
                color: Pallet.whitecolor
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child:Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 16,
                          ),//.copyWith(right: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                
                                
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(post.accountProfilePic),
                                        radius: 16,
                                      ),
                                      Padding(padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          
                                          Text(post.accountName,
                                          style:const  TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          ),
                                          Text('u/${post.username}',
                                          style:const  TextStyle(
                                            fontSize: 12,
                                            
                                          ),
                                          ),
                                        ],
                                      ),
                                      ),
                                    
                                    ],
                                  ),
                                  if(post.uid == user.uid)
                                       IconButton(
                                      onPressed: ()=> deletePost(ref, context), 
                                      icon: const Icon(
                                        Icons.delete, 
                                        color: Colors.red,),
                                        ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(post.title,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                                
                                ),
                              ),
                              if(isTypeImage)
                                SizedBox(
                                  height: MediaQuery.of(context).size.height*0.35,
                                  width: double.infinity,
                                  child: 
                                      Image.network(post.link!,
                                      fit: BoxFit.cover,
                                      
                                      ),
                                      
                                ),
                              if(isTypeLink)
                                SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: AnyLinkPreview(
                                    displayDirection: UIDirection.uiDirectionHorizontal,
                                    link: post.link!,)
                                ),
                              if(isTypeText)
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(post.description!,
                                  style: const TextStyle(
                                    color: Pallet.greycolor,
                                  ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: isGuest ? (){}:()=> upvotePost(ref), 
                                          icon: Icon(
                                            Constants.up,
                                            size: 30,
                                            color: post.upvotes.contains(user.uid)? Color.fromARGB(255, 14, 85, 143): null,
                                          ),
                                          ),
                                          Text('${post.upvotes.length - post.downvotes.length == 0? 'Vote' :post.upvotes.length - post.downvotes.length}',
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                          ),
                                          IconButton(
                                          onPressed: isGuest ? (){}: ()=>downvotePost(ref), 
                                          icon: Icon(
                                            Constants.down,
                                            size: 30,
                                            color: post.downvotes.contains(user.uid)? Colors.red: null,
                                          ),
                                          ),
                                      ],
                                    ),
                                     Row(
                                      children: [
                                        IconButton(
                                          onPressed: () =>navigateToComments(context), 
                                          icon: const Icon(
                                            Icons.comment
                                          ),
                                          ),
                                          Text('${post.commentCount == 0? 'Comment' :post.commentCount}',
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                          ),
                                         
                                      ],
                                    )
                                  ],
                                ),
                                
                               const SizedBox( height: 20,),    
                                 
                            ],
                          ),
                            
                        )
                        
                      ],
                    )
                    )
                ],
              ),
            )
          ],
        
      
    );
  }
}