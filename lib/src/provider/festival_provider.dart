import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FestivalProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getFestivals() async {
    return db.collection("festivals").get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getFestivalConfig() async {
    return db.collection("config").doc("festival").get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getFestivalInfo(String pk) async {
    return db.collection("festivals").doc(pk).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFestivalMeet(String pk) async {
    return db.collection("festivals").doc(pk).collection("meet").get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUsers(List<String> users) async {
    return db.collection("users").where('uid', whereIn: users).get();
}
}