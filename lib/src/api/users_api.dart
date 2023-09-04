import 'package:cloud_firestore/cloud_firestore.dart';

class UsersApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late CollectionReference _ref;

  UsersApi() {
    _ref = _db.collection("users");
  }

  getUser(String user) {
    return _ref.doc(user);
  }

  getUsers(List<dynamic> users) {
    return _ref.where('uid', whereIn: users);
  }

  setFollow(String follower, String followee) {
    _ref.doc(followee).update({
      'follower': FieldValue.arrayUnion([follower])
      //followee의 '팔로워' 기록에 follower 추가
    }).then((value) => {
      _ref.doc(follower).update({
        'following': FieldValue.arrayUnion([followee])
      }) //follower의 '팔로우 중' 기록에 followee 추가
    });
  }

  removeFollow(String follower, String followee) {
    _ref.doc(followee).update({
      'follower': FieldValue.arrayRemove([follower])
    }).then((value) => {
      _ref.doc(follower).update({
        'following': FieldValue.arrayRemove([followee])
      })
    });
  }
}