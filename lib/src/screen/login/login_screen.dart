import 'package:capybara/src/component/bounce.dart';
import 'package:capybara/src/config/routes.dart';
import 'package:capybara/src/provider/user_provider.dart';
import 'package:capybara/src/theme/color_theme.dart';
import 'package:capybara/src/theme/font_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.blackPoint,
      body: Stack(
        children: [
          ListView.builder(
            itemCount: 10,
              itemBuilder: (BuildContext context, int idx) {
                return Container(
                  height: 186,
                  margin: const EdgeInsets.only(left: 32, right: 32, bottom: 25),
                  decoration: const BoxDecoration(color: ColorTheme.greyPoint),
                );
              }),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorTheme.blackPoint.withOpacity(0),
                  ColorTheme.blackPoint.withOpacity(0),
                  ColorTheme.blackPoint.withOpacity(0),
                  ColorTheme.blackPoint.withOpacity(0),
                  ColorTheme.blackPoint.withOpacity(0.3),
                  ColorTheme.blackPoint.withOpacity(0.5),
                  ColorTheme.blackPoint.withOpacity(0.8),
                  ColorTheme.blackPoint.withOpacity(1),
                  ColorTheme.blackPoint.withOpacity(1),
                  ColorTheme.blackPoint.withOpacity(1),
                  ColorTheme.blackPoint.withOpacity(1),
                ],
              ),
            ),
          ),
         Positioned(
           left: 0,
           right: 0,
           bottom: 80,
           child: Column(
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text('카피바라', style: FontTheme.gradientYellow),
                   const SizedBox(width: 5),
                   const Text('시작하기' ,style: FontTheme.headline1,),
                 ]
               ),
               const SizedBox(height: 10),
               const Text('만나보고 싶던 사람과 네트워킹을 해보세요', style: FontTheme.subtitle1GreyBold),
               const SizedBox(height: 40),
               kakaoButton(context)
             ]
           )
         ),
        ]
      )
    );
  }

  Widget kakaoButton(BuildContext context) {

    UserProvider userProvider = Provider.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Bounce(
        onTap: () async {
          if (await isKakaoTalkInstalled()) {
            try {
              await UserApi.instance.loginWithKakaoTalk();
              print('카카오톡으로 로그인 성공');
              try {
                User user = await UserApi.instance.me();
                userProvider.me = user;
                print(user.id);
                context.go(Routes.FRAME);
              } catch (error) {
                print('사용자 정보 요청 실패 $error');
              }
            } catch (error) {
              print('카카오톡으로 로그인 실패 $error');

              // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
              // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
              if (error is PlatformException && error.code == 'CANCELED') {
                return;
              }
              // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
              try {
                await UserApi.instance.loginWithKakaoAccount();
                print('카카오계정으로 로그인 성공');
                try {
                  User user = await UserApi.instance.me();
                  userProvider.me = user;
                  print(user.id);
                  context.go(Routes.FRAME);
                } catch (error) {
                  print('사용자 정보 요청 실패 $error');
                }
              } catch (error) {
                print('카카오계정으로 로그인 실패 $error');
              }
            }
          } else {
            try {
              await UserApi.instance.loginWithKakaoAccount();
              print('카카오계정으로 로그인 성공');
              try {
                User user = await UserApi.instance.me();
                userProvider.me = user;
                print(user.id);
                context.go(Routes.FRAME);
              } catch (error) {
                print('사용자 정보 요청 실패 $error');
              }
            } catch (error) {
              print('카카오계정으로 로그인 실패 $error');
            }
          }
        },
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(color: const Color(0xffFEE500),
              borderRadius: BorderRadius.circular(10)),
          child: Stack(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 20),
                    SizedBox(width: 20, child: SvgPicture.asset('asset/image/kakao-symbol.svg')),
                  ],
                ),
                const Center(child: Text('카카오로 시작하기', style: FontTheme.subtitle1BlackBold)),
              ]
          ),
        ),
      ),
    );
  }
}
