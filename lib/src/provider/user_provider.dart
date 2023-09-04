import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../api/users_api.dart';
import '../locator/locator.dart';
import '../model/member.dart';

class UserProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;

  final UsersApi _api = locator<UsersApi>();

  late User _me;
  Member profileMember = const Member(uid: "", profileImage: "", name: "", nickname: "", belong: "", role: "", interest: [], personality: [], follower: [], following: [], introduceLink: "");

  set me(User user) {
    _me = user;
    notifyListeners();
  }

  User get me => _me;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String user) async {
    return _api.getUser(user).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUsers(List<dynamic> users) async {
    return _api.getUsers(users).get();
  }

  Future<Member> profileInit(String uid) async {
    await getUser(uid).then((value) {
      profileMember = Member.fromJson(value.data() as Map<String, dynamic>);
    });
    return profileMember;
  }

  Future follow(String follower, String followee) async {
    await _api.setFollow(follower, followee);
    return;
  }

  Future removeFollow(String follower, String followee) async {
    await _api.removeFollow(follower, followee);
    return;
  }
}