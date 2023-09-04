import 'package:capybara/src/component/bounce_grey.dart';
import 'package:capybara/src/model/member.dart';
import 'package:capybara/src/provider/festival_provider.dart';
import 'package:capybara/src/provider/user_provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../component/bounce.dart';
import '../../config/routes.dart';
import '../../theme/color_theme.dart';
import '../../theme/font_theme.dart';



class ProfileScreen extends HookWidget {
  const ProfileScreen({Key? key, required this.uid, required this.push}) : super(key: key);

  final String uid;
  final bool push;

  @override
  Widget build(BuildContext context) {

    UserProvider userProvider = Provider.of<UserProvider>(context);


    final isInitialized = useState(false);

    final ValueNotifier<Member> user = useState(const Member(uid: "", profileImage: "", name: "", nickname: "", belong: "", role: "", interest: [], personality: [], follower: [], following: [], introduceLink: ""));
    late bool me;

    if (!(isInitialized.value)) {
      userProvider.profileInit(uid).then((value) {
        user.value = value;
        isInitialized.value = true;
      });
    }

    me = (user.value.uid == userProvider.me.id.toString());

    bool isFollowed = user.value.follower.contains(userProvider.me.id.toString());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.blackPoint,
        scrolledUnderElevation: 0,
        leading: (push) ? Bounce(
            onTap: () {
              context.pop();
            },
            scale: 0.8,
            child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                child: SvgPicture.asset("asset/image/chevron-left.svg")
            )
        ) : const SizedBox()
      ),
      backgroundColor: ColorTheme.blackPoint,
      body: SafeArea(
        top: false,
        child: (isInitialized.value) ?
        ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.value.nickname, style: FontTheme.headline1),
                      const SizedBox(height: 10),
                      Text("${user.value.role} @${user.value.belong}", style: FontTheme.subtitle1GreyLightest),
                    ],
                  ),
                  const Spacer(),
                  ExtendedImage.network(
                    user.value.profileImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    shape: BoxShape.circle,
                    loadStateChanged: (state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.loading:
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorTheme.greyThickest
                            ),
                          );
                        case LoadState.completed:
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: ExtendedRawImage(
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              image: state.extendedImageInfo?.image,
                            ),
                          );
                        case LoadState.failed:
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorTheme.greyThickest
                            ),
                          );
                      }
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                children: [
                  Bounce(
                    onTap: () {
                      context.push(Routes.FOLLOW, extra: {
                        'uid': user.value.uid,
                        'initialIndex': 0,
                      });
                    },
                    child: Row(
                      children: [
                        const Text("팔로워", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ColorTheme.white)),
                        const SizedBox(width: 5),
                        Text("${user.value.follower.length}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: ColorTheme.white),),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Bounce(
                    onTap: () {
                      context.push(Routes.FOLLOW, extra: {
                        'uid': user.value.uid,
                        'initialIndex': 1,
                      });
                    },
                    child: Row(
                      children: [
                        const Text("팔로우 중", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ColorTheme.white)),
                        const SizedBox(width: 5),
                        Text("${user.value.following.length}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: ColorTheme.white),),
                      ],
                    ),
                  )
                ]
              )
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                children: [
                  for(int i = 0; i < user.value.personality.length; i++)
                    _personalityItem(user.value.personality[i])
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Bounce(
                      onTap: () async {
                        final url = Uri.parse(user.value.introduceLink);
                        if (!await launchUrl(url)) {
                          throw Exception('Could not launch ${user.value.introduceLink}');
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: ColorTheme.greyThickest
                        ),
                        child: const Center(child: Text("소개 페이지", style: FontTheme.subtitle1WhiteBold)),
                      )
                    )
                  ),
                  const SizedBox(width: 15),
                  (!me) ?
                      (isFollowed) ?
                          Expanded(
                              child: Bounce(
                                  onTap: () {
                                    userProvider.removeFollow(userProvider.me.id.toString(), user.value.uid);
                                    userProvider.profileInit(uid).then((value) => {
                                      user.value = value
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: ColorTheme.greyThickest
                                    ),
                                    child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset("asset/image/user.svg", color: ColorTheme.redPoint,),
                                            const SizedBox(width: 5),
                                            const Text("팔로우 중", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ColorTheme.redPoint)),
                                          ],
                                        )),
                                  )
                              )
                          ) :
                          Expanded(
                              child: Bounce(
                                  onTap: () {
                                    userProvider.follow(userProvider.me.id.toString(), user.value.uid);
                                    userProvider.profileInit(uid).then((value) {
                                      print(value.follower);
                                      user.value = value;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: ColorTheme.redPoint
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset("asset/image/user.svg", color: Colors.white,),
                                          const SizedBox(width: 5),
                                          const Text("팔로우", style: FontTheme.subtitle1WhiteBold),
                                        ],
                                      )),
                                  )
                              )
                          ) :
                      Expanded(
                          child: Bounce(
                              onTap: () {},
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: ColorTheme.redPoint
                                ),
                                child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset("asset/image/check-badge-outline.svg", color: Colors.white, width: 17, height: 17),
                                        const SizedBox(width: 5),
                                        const Text("모은 배지", style: FontTheme.subtitle1WhiteBold),
                                      ],
                                    )),
                              )
                          )
                      )
                ]
              ),
            )
          ],
        ) :
            const Center(child: CircularProgressIndicator())
      )
    );
  }

  Widget _personalityItem(String text) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      margin: const EdgeInsets.fromLTRB(0, 0, 8, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: ColorTheme.greyThickest
      ),
      child: Text(text, style: FontTheme.subtitle2)
    );
  }
}
