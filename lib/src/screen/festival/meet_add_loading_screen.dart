import 'package:capybara/src/theme/color_theme.dart';
import 'package:capybara/src/theme/font_theme.dart';
import 'package:flutter/material.dart';

class MeetAddLoadingScreen extends StatelessWidget {
  const MeetAddLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.blackPoint,
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Image.asset("asset/image/character.png", width: 200),
                const SizedBox(height: 30),
                const Text("모임을 게시하고 있어요", style: FontTheme.headline2),
                const SizedBox(height: 10),
                const Text("잠시만 기다려주세요", style: FontTheme.subtitle1)
              ]
            )
          )
        ]
      ),
    );
  }
}
