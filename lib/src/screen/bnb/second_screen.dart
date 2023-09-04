import 'package:capybara/src/model/festival/festival_info.dart';
import 'package:capybara/src/theme/color_theme.dart';
import 'package:capybara/src/theme/font_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_password_generator/random_password_generator.dart';

import '../../component/bounce_grey.dart';
import '../../model/member.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final db = FirebaseFirestore.instance;
    final password = RandomPasswordGenerator();

    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: ColorTheme.blackPoint,
        body: Column(
          children: [
            BounceGrey(
              onTap: () {
                var newId = password.randomPassword(
                    letters: true,
                    numbers: true,
                    passwordLength: 20,
                    specialChar: true,
                    uppercase: true
                );

                db.collection('festivals').doc(newId).set(
                  FestivalInfo(
                    pk: newId,
                    category: "기획",
                    thumbnail: "https://dev-event.vercel.app/_next/image?url=https%3A%2F%2Fbrave-people-3.s3.ap-northeast-2.amazonaws.com%2FDEVEVENT%2F2023-08-03-20-37-2614-e20e43b1.png&w=640&q=75",
                    title: "1st NE(O)RDINARY DemoDAY",
                    startDate: DateTime(2023, 9, 9, 13, 0, 0, 0, 0),
                    endDate: DateTime(2023, 9, 9, 20, 0, 0, 0, 0),
                    summary: "요약 설명",
                    description: "긴 설명",
                    location: "코엑스 Hall A",
                    locationName: "코엑스 Hall A",
                    fee: 10000,
                    member: ['afdfdf', 'sffdsfs'],
                    meets: [],
                    descriptionImage: []
                  ).toJson()
                );
              },
              child: const Text("festival 데이터 추가", style: FontTheme.subtitle1,)
            ),
            const SizedBox(height: 30),
            BounceGrey(
                onTap: () {
                  var newId = password.randomPassword(
                      letters: true,
                      numbers: true,
                      passwordLength: 20,
                      specialChar: true,
                      uppercase: true
                  );

                  db.collection('users').doc(newId).set(
                      Member(
                        uid: newId,
                        profileImage: "",
                        name: "박성원",
                        nickname: "박씨",
                        belong: "경희대학교",
                        role: "학생",
                        interest: [],
                        personality: [],
                        following: [],
                        follower: [],
                        introduceLink: ""
                      ).toJson()
                  );
                },
                child: const Text("user 데이터 추가", style: FontTheme.subtitle1,)
            ),
          ]
        ),
      ),
    );
  }
}
