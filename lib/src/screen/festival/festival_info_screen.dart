import 'package:capybara/src/theme/color_theme.dart';
import 'package:capybara/src/theme/font_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FestivalInfoScreen extends HookWidget {
  const FestivalInfoScreen({Key? key, required this.pk}) : super(key: key);

  final String pk;

  @override
  Widget build(BuildContext context) {

    // pk로 데이터 불러오기
    return CupertinoPageScaffold(
      backgroundColor: ColorTheme.blackPoint,
      child: Stack(
        children: [
          ListView(
            children: [
              Text(pk, style: FontTheme.subtitle2,)
            ]
          )
        ]
      )
    );
  }
}
