import 'package:capybara/src/component/bounce.dart';
import 'package:capybara/src/theme/color_theme.dart';
import 'package:capybara/src/theme/font_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  CupertinoPageScaffold(
      backgroundColor: ColorTheme.blackPoint,
      child: Stack(
        children: [
          ListView.builder(
            itemCount: 10,
              itemBuilder: (BuildContext ctx, int idx) {
                return Container(
                  height: 186,
                  margin: const EdgeInsets.only(left: 32, right: 32, bottom: 25),
                  decoration: const BoxDecoration( color: ColorTheme.greyPoint),
                );
              }),

          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            height: 600,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    ColorTheme.blackPoint.withOpacity(1),
                    ColorTheme.blackPoint.withOpacity(1),
                    ColorTheme.blackPoint.withOpacity(1),
                    ColorTheme.blackPoint.withOpacity(0.9),
                    ColorTheme.blackPoint.withOpacity(0.8),
                    ColorTheme.blackPoint.withOpacity(0.5),
                    ColorTheme.blackPoint.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
         Positioned(
          bottom: 245,
          left: 103,
          child: Row(
              children: [
                Text('카피바라', style: FontTheme.gradiantYellow),
                const SizedBox(width: 5),
                const Text('시작하기' ,style: FontTheme.headline1,)]),
        ),
          const Positioned(
            bottom: 211,
            left: 64,
            child: Row(
                children: [
                  Text('만나보고 싶던 사람과 네트워킹을 해보세요', style: FontTheme.subtitle1GreyBold),
          ]),),
          Positioned(
            width: 353, 
            height: 53,
            bottom: 100,
            left: 21,
            child: Bounce(
                onTap: () => context.go('/frame'),
                child: Container(
                  decoration: BoxDecoration(color: const Color(0xffFEE500),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row( children: [
                    const SizedBox(width: 18),
                    SizedBox(width: 20, child: SvgPicture.asset('asset/image/kakao-symbol.svg')),
                    const SizedBox(width: 85),
                    const Text('카카오로 시작하기', style: FontTheme.subtitle1BlackBold),
                  ]),

                  ),
                )
              ),
            ])
    );
  }
}
