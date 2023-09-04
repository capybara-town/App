import 'package:cloud_firestore/cloud_firestore.dart';

class FestivalsApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late CollectionReference _ref;

  FestivalsApi() {
    _ref = _db.collection("festivals");
  }

  getFestivals() {
    return _ref;
  }

  getFestivalConfig() {
    return _db.collection("config").doc("festival");
  }

  getFestivalInfo(String pk) {
    return _ref.doc(pk);
  }

  getFestivalMeet(String pk) {
    return _ref.doc(pk).collection("meet");
  }

  getMeet(String pk) {
    return _db.collection("meets").doc(pk);
  }

  Query<Map<String, dynamic>> getMeets(List<dynamic> pks) {
    return _db.collection("meets").where("id", whereIn: pks);
  }

  submitMeet(String pk, String meet) {
    return _db.collection("meets").doc(meet).update({
      'members': FieldValue.arrayUnion([pk])
    });
  }

  outMeet(String pk, String meet) {
    return _db.collection("meets").doc(meet).update({
      'members': FieldValue.arrayRemove([pk])
    });
  }
}