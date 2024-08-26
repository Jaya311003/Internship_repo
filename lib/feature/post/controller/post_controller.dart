
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship_project/core/provider/storage_repository_provider.dart';
import 'package:internship_project/core/utils.dart';
import 'package:internship_project/feature/auth/controller/auth_controller.dart';
import 'package:internship_project/feature/post/repository/post_repository.dart';
import 'package:internship_project/models/acccount_model.dart';
import 'package:internship_project/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import 'package:internship_project/models/comment_model.dart';

final postControllerProvider = StateNotifierProvider<PostController,bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
    postRepository: postRepository, 
    ref: ref,
    storageRepository: storageRepository,
    );
});

final userPostProvider = StreamProvider.family((ref, List<Account> accounts) {
  final postController= ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(accounts);

});

final guestPostProvider = StreamProvider((ref)  {
  final postController= ref.watch(postControllerProvider.notifier);
  return postController.fetchGuestPosts() ;
});

final getPostByIdProvider = StreamProvider.family((ref, String postId)  {
  final postController= ref.watch(postControllerProvider.notifier);
  return postController.getPostById(postId) ;
});

final getPostCommentsProvider= StreamProvider.family((ref, String postId)  {
  final postController= ref.watch(postControllerProvider.notifier);
  return postController.fetchPostComments(postId) ;
});


class PostController extends StateNotifier<bool> {
 
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository=storageRepository,
        super(false);

    void shareTextPost({
    required BuildContext context,
    required String title,
    required Account selectedAccount,
    required String description,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      title: title,
      accountName: selectedAccount.name,
      accountProfilePic: selectedAccount.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );

    final res = await _postRepository.addPost(post);
    
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted successfully!');
      Routemaster.of(context).pop();
    });
  }

     void shareLinkPost({
    required BuildContext context,
    required String title,
    required Account selectedAccount,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      title: title,
      accountName: selectedAccount.name,
      accountProfilePic: selectedAccount.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final res = await _postRepository.addPost(post);
    
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted successfully!');
      Routemaster.of(context).pop();
    });
  }
   void shareImagePost({
    required BuildContext context,
    required String title,
    required Account selectedAccount,
    
    required File? file,
    
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
      path: 'posts/${selectedAccount.name}',
      id: postId,
      file: file,
      
    );

    imageRes.fold((l) => showSnackBar(context, l.message), (r) async {
      final Post post = Post(
        id: postId,
        title: title,
        accountName: selectedAccount.name,
        accountProfilePic: selectedAccount.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'image',
        createdAt: DateTime.now(),
        awards: [],
        link: r,
       
      );

      final res = await _postRepository.addPost(post);
    
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Posted successfully!');
        Routemaster.of(context).pop();
      });
    });
  }

  Stream<List<Post>> fetchUserPosts(List<Account> accounts){
    if(accounts.isNotEmpty){
      return _postRepository.fetchUserPosts(accounts);
    }
    return Stream.value([]);
  }

   Stream<List<Post>> fetchGuestPosts(){
    
      return _postRepository.fetchGuestPosts();
    
  }

  Stream<List<Comment>> fetchPostComments(String postId){
   return _postRepository.getCommentOfPost(postId);
  }

  void deletePost(Post post, BuildContext context) async{
    final res = await _postRepository.deletePost(post);
    res.fold((l) => null, (r) => showSnackBar(context, 'Post deleted successfully'));
  }

  void upvote(Post post) async{
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.upvote(post, uid);
  }

   void downvote(Post post) async{
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.downvote(post, uid);
  }
  
  Stream<Post> getPostById(String postId){
    return _postRepository.getPostById(postId);
  }

  void addComment({ required BuildContext context, required String text, required Post post}) async{
    final user= _ref.read(userProvider)!;
   String commentID = const Uuid().v1();
   Comment comment = Comment(
    id:commentID, 
    text: text,
    createdAt: DateTime.now(),
    postId: post.id,
    username: user.name,
    profilePic: user.profilePic,
    );
    final res = await _postRepository.addComment(comment);
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

   
}