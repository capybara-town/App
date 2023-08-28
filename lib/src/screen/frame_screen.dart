import 'package:capybara/src/screen/bnb/home_screen.dart';
import 'package:capybara/src/screen/bnb/second_screen.dart';
import 'package:capybara/src/screen/festival/festival_screen.dart';
import 'package:capybara/src/screen/login/login_screen.dart';
import 'package:capybara/src/theme/color_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../component/bounce_grey.dart';

class FrameScreen extends HookWidget {
  const FrameScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final pageIndex = useState(0);

    return CupertinoPageScaffold(
      backgroundColor: ColorTheme.blackPoint,
      child: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: pageIndex.value,
              children: [
                const HomeScreen(),
                const SecondScreen(),
                FestivalScreen()
              ]
            )
          ),
          bnb(pageIndex)
        ]
      )
    );
  }

  Widget bnb(ValueNotifier pageIndex) {
    return Container(
        width: double.infinity,
        color: ColorTheme.greyThickest,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 13),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              item("그룹", 0, pageIndex.value == 0 ? "map-pin-solid.svg" : "map-pin-outline.svg", pageIndex),
              item("탐색", 1, pageIndex.value == 1 ? "squares-2x2-solid.svg" : "squares-2x2-outline.svg", pageIndex),
              item("행사", 2, pageIndex.value == 2 ? "ticket-solid.svg" : "ticket-outline.svg", pageIndex),
            ]
        )
    );
  }

  Widget item(String text, int index, String icon, ValueNotifier pageIndex) {
    return BounceGrey(
      onTap: () {
        pageIndex.value = index;
      },
      scale: 0.8,
      activeColor: ColorTheme.greyThick,
      paddingVertical: 10,
      paddingHorizontal: 15,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset("asset/image/$icon", width: 25),
            const SizedBox(height: 5,),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w600, color: ColorTheme.white, fontSize: 10))
          ]
      ),
    );
  }
}
