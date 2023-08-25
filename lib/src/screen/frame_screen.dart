import 'package:capybara/src/screen/bnb/home_screen.dart';
import 'package:capybara/src/screen/bnb/second_screen.dart';
import 'package:capybara/src/screen/bnb/third_screen.dart';
import 'package:capybara/src/screen/login/login_screen.dart';
import 'package:capybara/src/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../component/bounce_grey.dart';
import '../provider/ui_provider.dart';

class FrameScreen extends StatelessWidget {
  const FrameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    UiProvider uiProvider = Provider.of<UiProvider>(context);
    PageController frameController = PageController();

    return CupertinoPageScaffold(
      backgroundColor: ColorTheme.white,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: frameController,
              children: const [
                HomeScreen(),
                SecondScreen(),
                ThirdScreen()
              ]
            )
          ),
          bnb(uiProvider, frameController)
        ]
      )
    );
  }

  Widget bnb(UiProvider uiProvider, PageController frameController) {
    return Container(
        width: double.infinity,
        color: ColorTheme.blackPoint,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 13),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              item("행사", uiProvider, 0, "map-pin-inact.svg", frameController),
              item("신청", uiProvider, 1, "squares-2x2-inact.svg", frameController),
              item("프로필", uiProvider, 2, "squares-2x2-inact.svg", frameController),
            ]
        )
    );
  }

  Widget item(String text, UiProvider uiProvider, int index, String icon, PageController frameController) {
    return BounceGrey(
      onTap: () {
        frameController.animateToPage(
          index,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCirc
        );
      },
      scale: 0.8,
      activeColor: ColorTheme.blackLight,
      paddingVertical: 10,
      paddingHorizontal: 15,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset("asset/image/$icon", width: 25),
            const SizedBox(height: 5,),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w600, color: ColorTheme.white, fontSize: 10),)
          ]
      ),
    );
  }
}
