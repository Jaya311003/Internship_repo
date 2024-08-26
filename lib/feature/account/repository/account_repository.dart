import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:internship_project/core/constant/firebase_constants.dart';
import 'package:internship_project/core/failure.dart';
import 'package:internship_project/core/provider/firebase_provider.dart';
import 'package:internship_project/core/type_defs.dart';
import 'package:internship_project/models/acccount_model.dart';
import 'package:internship_project/models/post_model.dart';
//import 'package:firebase_core/firebase_core.dart';

final accountRepositoryProvider = Provider((ref) {
  return AccountRepository(firestore: ref.watch(firestoreProvider));
});

class AccountRepository {
  final FirebaseFirestore _firestore;
  AccountRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  FutureVoid createAccount(Account account) async {
    try {
      var accountDoc = await _accounts.doc(account.name).get();
      if (accountDoc.exists) {
        throw 'Account name already exists';
      }
      return right(_accounts.doc(account.name).set(account.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid joinAccount(String accountName, String userId) async{
    try {
      return right(_accounts.doc(accountName).update({
        'member': FieldValue.arrayUnion([userId]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }
  FutureVoid leaveAccount(String accountName, String userId) async{
    try {
      return right(_accounts.doc(accountName).update({
        'member': FieldValue.arrayRemove([userId]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Account>> getUserAccounts(String uid) {
    return _accounts
        .where('member', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<Account> accounts = [];
      for (var doc in event.docs) {
        accounts.add(Account.fromMap(doc.data() as Map<String, dynamic>));
      }
      return accounts;
    });
  }

  Stream<Account> getAccountByName(String name) {
    return _accounts
        .doc(name)
        .snapshots()
        .map((event) => Account.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<List<Account>> searchAccount(String query) {
    return _accounts
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      List<Account> accounts = [];
      for (var account in event.docs) {
        accounts.add(Account.fromMap(account.data() as Map<String, dynamic>));
      }
      return accounts;
    });
  }

  FutureVoid editAccount(Account account)async{
    try {
      return right(_accounts.doc(account.name).update(account.toMap()));
    } on FirebaseException catch(e){
      throw e.message!;

    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
 CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postCollection);

  Stream<List<Post>> getAccountPosts(String accountName) {
    return _posts
        .where('accountName', isEqualTo: accountName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => Post.fromMap(e.data() as Map<String, dynamic>),
            )
            .toList());
  }

  CollectionReference get _accounts =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}
