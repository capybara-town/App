import 'package:capybara/src/component/bounce_grey.dart';
import 'package:capybara/src/component/capybara_button.dart';
import 'package:capybara/src/config/routes.dart';
import 'package:capybara/src/model/festival/festival_meet.dart';
import 'package:capybara/src/model/member.dart';
import 'package:capybara/src/provider/festival_provider.dart';
import 'package:capybara/src/provider/user_provider.dart';
import 'package:capybara/src/theme/color_theme.dart';
import 'package:capybara/src/theme/font_theme.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../component/bounce.dart';

class FestivalMeetScreen extends HookWidget {
  const FestivalMeetScreen({Key? key, required this.pk}) : super(key: key);
  
  final String pk;
  
  @override
  Widget build(BuildContext context) {
    
    final FestivalProvider festivalProvider = Provider.of<FestivalProvider>(context);
    final UserProvider userProvider = Provider.of(context);

    final ValueNotifier<FestivalMeet> meet = useState(FestivalMeet(id: "", title: "", description: "", startDate: DateTime.now(), endDate: DateTime.now(), members: [], limit: 0, location: "", fee: "", manager: ''));
    final ValueNotifier<List<Member>> users = useState([]);

    final isMeetInitialized = useState(false);
    final isMemberInitialized = useState(false);

    if (!(isMeetInitialized.value) || !(isMemberInitialized.value)) {
      festivalProvider.festivalMeetInit(pk).then((value) {
        meet.value = value;
        isMeetInitialized.value = true;
      }).then((value) {
        userProvider.getUsers(meet.value.members).then((value) {
          users.value = value.docs.map((e) => Member.fromJson(e.data())).toList();
          isMemberInitialized.value = true;
        });
      });
    }

    return Scaffold(
      backgroundColor: ColorTheme.blackPoint,
      appBar: AppBar(
        backgroundColor: ColorTheme.blackPoint,
        scrolledUnderElevation: 0,
        leading: Bounce(
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
        ),
      ),
      body: SafeArea(
        child: (isMeetInitialized.value && isMemberInitialized.value) ?
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(meet.value.title, style: FontTheme.headline1),
                        const SizedBox(height: 10),
                        Text(
                            (DateFormat.MMMd('en_US').format(meet.value.startDate) == DateFormat.MMMd('en_US').format(meet.value.endDate)) ?
                            (DateFormat.Hm('en_US').format(meet.value.startDate) == DateFormat.Hm('en_US').format(meet.value.endDate)) ?
                            "${DateFormat.MMMd('en_US').format(meet.value.startDate)} ${DateFormat.Hm("en_US").format(meet.value.startDate)}" : // startDate == endDate
                            "${DateFormat.MMMd('en_US').format(meet.value.startDate)} ${DateFormat.Hm("en_US").format(meet.value.startDate)} ~ ${DateFormat.Hm("en_US").format(meet.value.endDate)}" :// 날짜는 같지만 시간이 다름
                            "${DateFormat.MMMd('en_US').format(meet.value.startDate)} ${DateFormat.Hm("en_US").format(meet.value.startDate)} ~ ${DateFormat.MMMd('en_US').format(meet.value.endDate)} ${DateFormat.Hm("en_US").format(meet.value.endDate)}",
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ColorTheme.greyLightest)
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(meet.value.description.replaceAll("\\n", "\n"), style: FontTheme.subtitle1),
                  ),
                  block([
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("멤버", style: FontTheme.headline2),
                          const SizedBox(width: 10),
                          Text("${users.value.length}", style: const TextStyle(fontSize: 20, color: ColorTheme.greyLight, fontWeight: FontWeight.w600)),
                          Text("/${meet.value.limit.toString()}", style: const TextStyle(fontSize: 20, color: ColorTheme.greyPoint, fontWeight: FontWeight.w600))
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        for (int i = 0; i < meet.value.limit; i++)
                          (i < users.value.length) ? user(users.value[i], context, meet.value.manager) : waitUser()
                      ]
                    ),
                  ]),
                  block([
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text("모일 곳", style: FontTheme.headline2),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(meet.value.location, style: FontTheme.subtitle1),
                          const SizedBox(height: 15),
                          ExtendedImage.asset(
                            "asset/image/mock-map.png",
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(10),
                            loadStateChanged: (state) {
                              switch (state.extendedImageLoadState) {
                                case LoadState.loading:
                                  return Container(
                                    width: double.infinity,
                                    height: 200,
                                    color: ColorTheme.blackPoint,
                                  );
                                case LoadState.completed:
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: ExtendedRawImage(
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      image: state.extendedImageInfo?.image,
                                    ),
                                  );
                                case LoadState.failed:
                                  return Container(
                                    width: double.infinity,
                                    height: 200,
                                    color: ColorTheme.blackPoint,
                                  );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ]),
                  block([
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text("참여비", style: FontTheme.headline2),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text(meet.value.fee, style: FontTheme.subtitle1),
                    )
                  ]),
                  const SizedBox(height: 100)
                ]
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorTheme.blackPoint.withOpacity(0),
                        ColorTheme.blackPoint.withOpacity(1),
                        ColorTheme.blackPoint.withOpacity(1),
                        ColorTheme.blackPoint.withOpacity(1),
                        ColorTheme.blackPoint.withOpacity(1),
                      ]
                    )
                  )
                )
              ),
              (meet.value.members.contains(userProvider.me.id.toString())) ?
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: Row(
                        children: [
                          (userProvider.me.id.toString() == meet.value.manager) ?
                              Expanded(
                                child: CapybaraButton(
                                    onTap: () {},
                                    height: 70,
                                    width: double.infinity,
                                    background: ColorTheme.greyThickest,
                                    text: "모임 설정",
                                  textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
                                ),
                              ) :
                              Expanded(
                                child: CapybaraButton(
                                  onTap: () {
                                    festivalProvider.outMeet(userProvider.me.id.toString(), pk).then((value) => {
                                      festivalProvider.festivalMeetInit(pk).then((value) => {
                                        meet.value = value
                                      }).then((value) => {
                                        userProvider.getUsers(meet.value.members).then((value) => {
                                          users.value = value.docs.map((e) => Member.fromJson(e.data())).toList()
                                        })
                                      })
                                    });
                                  },
                                  height: 70,
                                  width: double.infinity,
                                  background: ColorTheme.greyThickest,
                                  text: "모임 나가기",
                                  textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: ColorTheme.redPoint),
                                ),
                              ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: CapybaraButton(
                                onTap: () {},
                                width: double.infinity,
                                text: "채팅하기",
                                height: 70,
                            ),
                          ),
                        ],
                      )
                    )
                  ) :
                  Positioned(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      child: SizedBox(
                          width: double.infinity,
                          height: 70,
                          child: CapybaraButton(
                              onTap: () async {
                                festivalProvider.submitMeet(userProvider.me.id.toString(), pk).then((value) {
                                  Future.delayed(const Duration(milliseconds: 250)).then((value) {
                                    festivalProvider.festivalMeetInit(pk).then((value) {
                                      meet.value = value;
                                    }).then((value) {
                                      userProvider.getUsers(meet.value.members).then((value) => {
                                        users.value = value.docs.map((e) => Member.fromJson(e.data())).toList()
                                      });
                                    });
                                  });
                                });
                              },
                              width: double.infinity,
                              text: "참여하기"
                          )
                      )
                  )
            ],
          ),
        ) :
            const Center(child: CircularProgressIndicator())
      ),
    );
  }

  Widget divider() {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        width: double.infinity,
        height: 1,
        color: ColorTheme.greyThick
    );
  }

  Widget block(List<Widget> child) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 7.5, 20, 7.5),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: ColorTheme.greyThickest
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: child
        )
      ),
    );
  }

  Widget user(Member user, BuildContext context, String managerUid) {

    return BounceGrey(
      onTap: () {
        context.push(Routes.PROFILE, extra: {
          'uid': user.uid,
          'push': true
        });
      },
      paddingVertical: 7.5,
      paddingHorizontal: 20,
      child: Row(
            children: [
              ExtendedImage.network(
                user.profileImage,
                width: 50,
                height: 50,
                cache: true,
                fit: BoxFit.cover,
                shape: BoxShape.circle,
                loadStateChanged: (state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      return Container(
                        width: 50,
                        height: 50,
                        color: ColorTheme.greyThickest,
                      );
                    case LoadState.completed:
                      return ExtendedRawImage(
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        image: state.extendedImageInfo?.image,
                      );
                    case LoadState.failed:
                      return Container(
                        width: 50,
                        height: 50,
                        color: ColorTheme.greyThickest,
                      );
                  }
                },
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (user.uid == managerUid) ?
                      Row(
                        children: [
                          Text(user.nickname, style: FontTheme.subtitle2Bold,),
                          const SizedBox(width: 10),
                          SvgPicture.asset("asset/image/flag.svg")
                        ],
                      ) :
                      Text(user.nickname, style: FontTheme.subtitle2Bold,),
                  const SizedBox(height: 3),
                  Text("${user.role} @${user.belong}", style: FontTheme.subtitle2_greyLightest,)
                ],
              ),
            ]
          ),
    );
  }

  Widget waitUser() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 7.5, 20, 7.5),
      child: Row(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: SvgPicture.asset("asset/image/circle-void-dash.svg")
            ),
            const SizedBox(width: 15),
            const Text("멤버를 기다리고 있어요", style: TextStyle(fontSize: 14, color: ColorTheme.greyPoint),)
          ]
      ),
    );
  }
}
