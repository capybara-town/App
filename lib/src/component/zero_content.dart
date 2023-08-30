import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/color_theme.dart';
import '../theme/font_theme.dart';

class ZeroContent extends StatelessWidget {
  const ZeroContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 2,),
        Image.asset("asset/image/character.png", width: 200,),
        const SizedBox(height: 30),
        const Text("아직 컨텐츠가 없어요", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: ColorTheme.greyLight)),
        const Spacer(flex: 3,)
      ]
    );
  }
}
