import 'package:capybara/src/component/bounce.dart';
import 'package:capybara/src/component/user_list_item.dart';
import 'package:capybara/src/component/zero_content.dart';
import 'package:capybara/src/config/routes.dart';
import 'package:capybara/src/model/festival/festival_meet.dart';
import 'package:capybara/src/model/member.dart';
import 'package:capybara/src/provider/festival_provider.dart';
import 'package:capybara/src/provider/user_provider.dart';
import 'package:capybara/src/theme/color_theme.dart';
import 'package:capybara/src/theme/font_theme.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../component/bounce_grey.dart';
import '../../model/festival/festival_info.dart';

class FestivalInfoScreen extends HookWidget {
  const FestivalInfoScreen({Key? key, required this.pk}) : super(key: key);

  final String pk;

  @override
  Widget build(BuildContext context) {

    final FestivalProvider festivalProvider = Provider.of<FestivalProvider>(context);
    final UserProvider userProvider = Provider.of(context);

    // pk로 데이터 불러오기

    final ValueNotifier<List<FestivalMeet>> meetsData = useState([]);
    final isMeetInitialized = useState(false);
    final isInfoInitialized = useState(false);

    final ValueNotifier<FestivalInfo> festivalInfo = useState(FestivalInfo(pk: "", category: "", thumbnail: "", title: "", startDate: DateTime.now(), endDate: DateTime.now(), summary: "", description: "", location: "", locationName: "", fee: 0, member: [], meets: [], descriptionImage: []));

    if (!(isInfoInitialized.value)) {
      festivalProvider.festivalInfoInit(pk).then((value) {
        festivalInfo.value = value;
        isInfoInitialized.value = true;
      }).then((value) {
        festivalProvider.festivalMeetsInit(festivalInfo.value.meets).then((value) {
        meetsData.value = value;
        isMeetInitialized.value = true;
      });
      });
    }

    final tabController = useTabController(initialLength: 3);
    final tabIndex = useListenable(tabController);

    return Scaffold(
      backgroundColor: ColorTheme.blackPoint,
      floatingActionButton: AnimatedScale(
        duration: const Duration(milliseconds: 600),
        scale: tabIndex.index == 1 ? 1 : 0,
        curve: Curves.easeOutCirc,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: tabIndex.index == 1 ? 1 : 0,
          curve: Curves.easeOutCirc,
          child: Bounce(
            onTap: () {
              context.push(Routes.MEET_ADD, extra: {
                "festivalPk": festivalInfo.value.pk,
                "festivalTitle": festivalInfo.value.title,
                "festivalStart": festivalInfo.value.startDate
              });
            },
            child: Container(
              width: 130,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: ColorTheme.redPoint
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 15,
                      height: 15,
                      alignment: Alignment.center,
                      child: SvgPicture.asset("asset/image/plus.svg", color: ColorTheme.white,)
                    ),
                    const SizedBox(width: 10),
                    const Text("만들기", style: FontTheme.subtitle1WhiteBold)
                  ],
                ),
              ),
            ),
          )
        )
      ),
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
      body: (isInfoInitialized.value) ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(festivalInfo.value.title, style: FontTheme.headline1),
                        const SizedBox(height: 10),
                        Text("${DateFormat.yMMMd('en_US').format(festivalInfo.value.startDate)} ${DateFormat.Hm('en_US').format(festivalInfo.value.startDate)} ~ ${DateFormat.yMMMd('en_US').format(festivalInfo.value.endDate)} ${DateFormat.Hm('en_US').format(festivalInfo.value.endDate)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: ColorTheme.greyLightest),),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Scaffold(
                      backgroundColor: ColorTheme.blackPoint,
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: ColorTheme.blackPoint,
                        title: TabBar(
                          controller: tabController,
                          tabs: const [
                            Tab(text: '정보'),
                            Tab(text: '모임'),
                            Tab(text: '멤버'),
                          ],
                          splashFactory: NoSplash.splashFactory,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          labelColor: ColorTheme.white,
                          unselectedLabelColor: ColorTheme.greyPoint,
                          unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                          dividerColor: ColorTheme.greyThickest,
                          indicator: UnderlineTabIndicator(
                            borderSide: const BorderSide(
                                width: 1, color: ColorTheme.white),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          overlayColor: MaterialStateProperty.resolveWith((states) =>
                          states.contains(MaterialState.focused)
                              ? null
                              : ColorTheme.greyThickest),
                        ),
                      ),
                      body: TabBarView(
                        controller: tabController,
                        children: [
                          info(festivalInfo.value),
                          meets(festivalInfo.value, festivalProvider, meetsData, isMeetInitialized),
                          members(festivalInfo.value.member, userProvider)
                        ]
                      ),
                    ),
                  )
                ],
              ) :
              const Center(child: CircularProgressIndicator())
    );
  }

  Widget tabBar(CarouselController carouselController, ValueNotifier<int> carouselPage) {
    List<String> tab = ["정보", "모임", "참여"];
    return Container(
        height: 40,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: ColorTheme.greyThickest)),
            color: ColorTheme.blackPoint
        ),
        child: ListView.builder(
            itemCount: tab.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, itemIndex) {
              return AnimatedContainer(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: (carouselPage.value == itemIndex) ?
                        const BorderSide(width: 1, color: ColorTheme.white) :
                        BorderSide.none
                    )
                ),
                duration: const Duration(milliseconds: 100),
                child: BounceGrey(
                    onTap: () {
                      carouselController.animateToPage(itemIndex, duration: const Duration(milliseconds: 200), curve: Curves.easeOutCirc);
                      carouselPage.value = itemIndex;
                    },
                    activeColor: ColorTheme.greyThickest,
                    paddingHorizontal: 5,
                    paddingVertical: 0,
                    radius: 5,
                    scale: 0.8,
                    child: Container(
                      color: ColorTheme.greyThickest.withOpacity(0),
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Center(child: Text(tab[itemIndex].toString(), style: carouselPage.value == itemIndex ? FontTheme.subtitle1WhiteBold : FontTheme.subtitle1GreyBold)),
                    )
                ),
              );
            }
        )
    );
  }

  Widget info(FestivalInfo festivalInfo) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      children: [
        ExtendedImage.network(
          festivalInfo.thumbnail,
          width: double.infinity,
          height: 250,
          cache: true,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(15),
          loadStateChanged: (state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                      color: ColorTheme.greyThickest
                  ),
                );
              case LoadState.completed:
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: ExtendedRawImage(
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    image: state.extendedImageInfo?.image,
                  ),
                );
              case LoadState.failed:
                return Container(
                  width: 250,
                  height: 250,
                  color: ColorTheme.greyThickest,
                );
            }
          },
        ),
        const SizedBox(height: 15),
        Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ColorTheme.greyThickest
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(festivalInfo.summary, style: FontTheme.subtitle1WhiteBold),
                if (festivalInfo.description != "") divider(),
                if (festivalInfo.description != "") Text(festivalInfo.description.replaceAll("\\n", "\n"), style: FontTheme.subtitle1),
              ],
            )
        ),
        const SizedBox(height: 15),
        for (int i = 0; i < festivalInfo.descriptionImage.length; i++)
          ExtendedImage.network(
            festivalInfo.descriptionImage[i],
            width: double.infinity,
            cache: true,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(15),
            loadStateChanged: (state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  return Container(
                    width: double.infinity,
                    height: 250,
                    decoration: const BoxDecoration(
                        color: ColorTheme.greyThickest
                    ),
                  );
                case LoadState.completed:
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: ExtendedRawImage(
                      width: double.infinity,
                      fit: BoxFit.cover,
                      image: state.extendedImageInfo?.image,
                    ),
                  );
                case LoadState.failed:
                  return Container(
                    width: double.infinity,
                    height: 250,
                    color: ColorTheme.greyThickest,
                  );
              }
            },
          ),
      ],
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

  Widget meets(FestivalInfo festivalInfo, FestivalProvider festivalProvider, ValueNotifier<List<dynamic>> meets, ValueNotifier<bool> isInitialized) {

    return (isInitialized.value) ?
            (meets.value.isEmpty) ?
              const Center(
                child: ZeroContent()
              ) :
              ListView.builder(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                itemCount: meets.value.length,
                itemBuilder: (context, index) {
                  FestivalMeet meet = meets.value[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                    child: Bounce(
                      onTap: () {
                        context.push(Routes.FESTIVAL_MEET, extra: {"pk": meets.value[index].id});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: ColorTheme.greyThickest,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(meet.title, style: FontTheme.headline3),
                            divider(),
                            Text(
                                (DateFormat.yMMMd('en_US').format(meet.startDate) == DateFormat.yMMMd('en_US').format(meet.endDate)) ?
                                    (DateFormat.Hm('en_US').format(meet.startDate) == DateFormat.Hm('en_US').format(meet.endDate)) ?
                                        "${DateFormat.yMMMd('en_US').format(meet.startDate)} ${DateFormat.Hm("en_US").format(meet.startDate)}" : // startDate == endDate
                                        "${DateFormat.yMMMd('en_US').format(meet.startDate)} ${DateFormat.Hm("en_US").format(meet.startDate)} ~ ${DateFormat.Hm("en_US").format(meet.endDate)}" :// 날짜는 같지만 시간이 다름
                                    "${DateFormat.yMMMd('en_US').format(meet.startDate)} ${DateFormat.Hm("en_US").format(meet.startDate)} ~ ${DateFormat.yMMMd('en_US').format(meet.endDate)} ${DateFormat.Hm("en_US").format(meet.endDate)}",
                                style: FontTheme.subtitle3_greyLightest
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 25,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: meet.limit,
                                itemBuilder: (context, userIndex) {
                                  return Container(
                                    width: 25,
                                    height: 25,
                                    margin: const EdgeInsets.fromLTRB(0, 0, 7, 0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorTheme.greyThickest,
                                      border: Border.all(width: 1, color: ColorTheme.greyThick)
                                    ),
                                  );
                                }
                              ),
                            )
                          ]
                        )
                      ),
                    ),
                  );
                },
              ) :
              const Center(child: CircularProgressIndicator());
  }

  Widget members(List<dynamic> members, UserProvider userProvider) {

    final memberFuture = useMemoized(() => userProvider.getUsers(members));
    final membersData = useFuture(memberFuture);

    List<Member> membersMap = [];

    if (!(membersData.hasError) && membersData.hasData) {
      membersMap = membersData.data!.docs.map((e) => Member.fromJson(e.data())).toList();
    }

    return (membersData.hasError) ?
        const Center(child: Text("error has occurred", style: FontTheme.subtitle2,)) :
        (membersData.hasData) ?
            (membersMap.isEmpty) ?
                const Center(
                  child: ZeroContent(),
                ) :
                ListView.builder(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  itemCount: membersMap.length,
                  itemBuilder: (context, index) {
                    Member member = membersMap[index];
                    return UserListItem(member: member, index: index);
                  },
                ):
            const Center(child: CircularProgressIndicator());
  }
}
