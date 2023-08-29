import 'package:capybara/src/component/bounce.dart';
import 'package:capybara/src/model/festival/festival_meet.dart';
import 'package:capybara/src/provider/festival_provider.dart';
import 'package:capybara/src/theme/color_theme.dart';
import 'package:capybara/src/theme/font_theme.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
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

    // pk로 데이터 불러오기
    final festivalInfoSnapshot = useFuture(festivalProvider.getFestivalInfo(pk));
    final festivalMeetSnapshot = useFuture(festivalProvider.getFestivalMeet(pk));

    FestivalInfo festivalInfo = FestivalInfo(pk: "", category: "", thumbnail: "", title: "", startDate: DateTime.now(), endDate: DateTime.now(), summary: "", description: "", location: "", locationName: "", fee: 0, member: []);
    List<FestivalMeet> festivalMeets = [];

    if (!(festivalInfoSnapshot.hasError) && festivalInfoSnapshot.hasData) {
      festivalInfo = FestivalInfo.fromJson(festivalInfoSnapshot.data!.data() as Map<String, dynamic>);
    }

    if (!(festivalMeetSnapshot.hasError) && festivalInfoSnapshot.hasData) {
      festivalMeets = festivalMeetSnapshot.data!.docs.map((e) => FestivalMeet.fromJson(e.data())).toList();
    }

    final carouselController = useState(CarouselController());
    final carouselPage = useState(0);

    return Scaffold(
      backgroundColor: ColorTheme.blackPoint,
      floatingActionButton: AnimatedScale(
        duration: const Duration(milliseconds: 400),
        scale: carouselPage.value == 1 ? 1 : 0,
        curve: Curves.easeOutCirc,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: carouselPage.value == 1 ? 1 : 0,
          curve: Curves.easeOutCirc,
          child: FloatingActionButton(
            child: const Icon(Icons.abc),
            onPressed: () {},
          )
        )
      ),
      body: Stack(
        children: [
          (festivalInfoSnapshot.hasError && festivalMeetSnapshot.hasError) ?
              const Center(child: Text("error has occured")) :
              (festivalInfoSnapshot.hasData && festivalMeetSnapshot.hasData) ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(festivalInfo.thumbnail, width: double.infinity, height: 230, fit: BoxFit.cover),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(festivalInfo.title, style: FontTheme.headline3),
                            const SizedBox(height: 10),
                            Text("${DateFormat.yMMMd('en_US').format(festivalInfo.startDate)} ${DateFormat.Hm('en_US').format(festivalInfo.startDate)} ~ ${DateFormat.yMMMd('en_US').format(festivalInfo.endDate)} ${DateFormat.Hm('en_US').format(festivalInfo.endDate)}", style: FontTheme.subtitle2,),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      tabBar(carouselController.value, carouselPage),
                      Expanded(
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: double.infinity,
                            viewportFraction: 1,
                            enableInfiniteScroll: false,
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                          ),
                          carouselController: carouselController.value,
                          items: [
                            info(festivalInfo),
                            meets(festivalMeets)
                          ],
                        )
                      )
                    ],
                  ) :
                  const Center(child: CircularProgressIndicator()),
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorTheme.blackPoint.withOpacity(0.8),
                  ColorTheme.blackPoint.withOpacity(0)
                ]
              )
            ),
          ),
          Positioned(
            left: 20,
            top: 60,
            child: Container(
              width: 30,
              height: 30,
              child: Bounce(
                  onTap: () {
                    context.pop();
                  },
                  scale: 0.8,
                  child: SvgPicture.asset("asset/image/chevron-left.svg", width: 30, height: 30)
              ),
            ),
          )
        ]
      )
    );
  }

  Widget tabBar(CarouselController carouselController, ValueNotifier<int> carouselPage) {
    List<String> tab = ["정보", "모임", "참여"];
    return Container(
        height: 60,
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
                        const BorderSide(width: 2, color: ColorTheme.white) :
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      children: [
        Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorTheme.greyThickest
            ),
            child: Text(festivalInfo.summary, style: FontTheme.subtitle2)
        ),
        const SizedBox(height: 15),
        Text(festivalInfo.description, style: FontTheme.subtitle2)
      ],
    );
  }

  Widget meets(List<FestivalMeet> meets) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      itemCount: meets.length,
      itemBuilder: (context, index) {
        FestivalMeet meet = meets[index];
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(meet.title, style: FontTheme.headline3),
              const SizedBox(height: 10),
              Text("${meet.startDate} ~ ${meet.endDate}", style: FontTheme.subtitle2),
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
        );
      },
    );
  }

  Widget members(List<String> members, FestivalProvider festivalProvider) {

    final membersData = useFuture(festivalProvider.getUsers(members));

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      itemCount: 3,
      itemBuilder: (context, index) {
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network("", width: 50, height: 50)
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                Text(members[index])
              ]
            )
          ]
        );
      },
    );
  }
}
