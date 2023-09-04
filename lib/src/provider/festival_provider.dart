import 'package:capybara/src/api/festivals_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

import '../locator/locator.dart';
import '../model/festival/festival_info.dart';
import '../model/festival/festival_meet.dart';

class FestivalProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;

  final FestivalsApi _api = locator<FestivalsApi>();

  List<FestivalMeet> meets = [];

  Future<QuerySnapshot<Map<String, dynamic>>> getFestivals() async {
    return _api.getFestivals().get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getFestivalConfig() async {
    return _api.getFestivalConfig().get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getFestivalInfo(String pk) async {
    return _api.getFestivalInfo(pk).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFestivalMeet(String pk) async {
    return _api.getFestivalMeet(pk).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getMeet(String pk) async {
    return _api.getMeet(pk).get();
  }
  
  Future<QuerySnapshot<Object?>> getMeets(List<dynamic> pks) async {
    return _api.getMeets(pks).get();
  }

  Future<List<FestivalMeet>> festivalMeetsInit(List<dynamic> pks) async {
    await getMeets(pks).then((value) {
      meets = value.docs.map((e) => FestivalMeet.fromJson(e.data() as Map<String, dynamic>)).toList();
    });
    return meets;
  }

  Future<FestivalMeet> festivalMeetInit(String pk) async {
    FestivalMeet meet = FestivalMeet(id: "", title: "", description: "", startDate: DateTime.now(), endDate: DateTime.now(), members: [], limit: 0, location: "", fee: "", manager: '');
    await getMeet(pk).then((value) {
      meet = FestivalMeet.fromJson(value.data() as Map<String, dynamic>);
    });
    return meet;
  }

  Future<FestivalInfo> festivalInfoInit(String pk) async {
    FestivalInfo festivalInfo = FestivalInfo(pk: "", category: "", thumbnail: "", title: "", startDate: DateTime.now(), endDate: DateTime.now(), summary: "", description: "", location: "", locationName: "", fee: 0, member: [], meets: [], descriptionImage: []);
    await getFestivalInfo(pk).then((value) {
      festivalInfo = FestivalInfo.fromJson(value.data() as Map<String, dynamic>);
    });
    return festivalInfo;
  }

  Future submitMeet(String pk, String meet) async {
    FestivalMeet festivalMeet = FestivalMeet(id: "", title: "", description: "", startDate: DateTime.now(), endDate: DateTime.now(), members: [], limit: 0, location: "", fee: "", manager: '');
    festivalMeetInit(meet).then((value) {
      festivalMeet = value;
      if (festivalMeet.limit > festivalMeet.members.length) {
        _api.submitMeet(pk, meet);
      }
    });
  }

  Future outMeet(String pk, String meet) async {
    _api.outMeet(pk, meet);
    return;
  }
}