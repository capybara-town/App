import 'package:capybara/src/model/festival/festival_info.dart';
import 'package:capybara/src/theme/font_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../component/bounce_grey.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final db = FirebaseFirestore.instance;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          BounceGrey(
            onTap: () {
              db.collection('festivals').doc().set(
                FestivalInfo(
                  category: "개발",
                  thumbnail: "https://dev-event.vercel.app/_next/image?url=https%3A%2F%2Fbrave-people-3.s3.ap-northeast-2.amazonaws.com%2FDEVEVENT%2F2023-08-03-20-37-2614-e20e43b1.png&w=640&q=75",
                  title: "1st NE(O)RDINARY DemoDAY",
                  startDate: DateTime(2023, 9, 9, 13, 0, 0, 0, 0),
                  endDate: DateTime(2023, 9, 9, 20, 0, 0, 0, 0),
                  summary: "요약 설명",
                  description: "긴 설명",
                  location: "코엑스 Hall A",
                  locationName: "코엑스 Hall A",
                  fee: 10000
                ).toJson()
              );
            },
            child: const Text("festival 데이터 추가", style: FontTheme.subtitle1,)
          )
        ]
      ),
    );
  }
}
