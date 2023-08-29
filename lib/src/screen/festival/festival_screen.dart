import 'package:capybara/src/config/routes.dart';
import 'package:capybara/src/provider/festival_provider.dart';
import 'package:capybara/src/theme/color_theme.dart';
import 'package:capybara/src/theme/font_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../component/bounce.dart';
import '../../component/bounce_grey.dart';
import '../../model/festival/festival_info.dart';

class FestivalScreen extends HookWidget {
  FestivalScreen({Key? key}) : super(key: key);

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    final FestivalProvider festivalProvider = Provider.of<FestivalProvider>(context);

    final carouselController = useState(CarouselController());
    final carouselPage = useState(0);

    final snapshotFuture = useMemoized(() => festivalProvider.getFestivals());
    final festivalConfigFuture = useMemoized(() => festivalProvider.getFestivalConfig());
    final snapshot = useFuture(snapshotFuture);
    final festivalConfigSnapshot = useFuture(festivalConfigFuture);

    List<Map<String, dynamic>> festivals = [];
    Map<String, dynamic> festivalConfig = {};
    Map<String, dynamic> groupFestivals = {};

    if (!(snapshot.hasError) && snapshot.hasData) {
      festivals = snapshot.data!.docs.map((e) => e.data()).toList();
      groupFestivals = groupBy(festivals, (Map obj) => obj['category']);
    }

    if (!(festivalConfigSnapshot.hasError) && festivalConfigSnapshot.hasData) {
      festivalConfig = festivalConfigSnapshot.data!.data() as Map<String, dynamic>;
    }

    print("hi!!!");

    return SafeArea(
      bottom: false,
      child: (festivalConfigSnapshot.hasError && snapshot.hasError) ?
          const Center(child: Text("error has occured")) :
          (festivalConfigSnapshot.hasData && snapshot.hasData) ?
              Column(
                children: [
                  tabBar(carouselController.value, carouselPage, festivalConfig),
                  Expanded(
                    child: tabContent(carouselController.value, carouselPage, snapshot.data!.docs, festivalConfigSnapshot.data!.data() as Map<String, dynamic>, groupFestivals)
                  )
                ]
              ) :
              const Center(child: CircularProgressIndicator())
    );
  }

  Widget tabBar(CarouselController carouselController, ValueNotifier<int> carouselPage, Map<String, dynamic> festivalConfig) {

    return Container(
      height: 60,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: ColorTheme.greyThickest)),
          color: ColorTheme.blackPoint
      ),
      child: ListView.builder(
          itemCount: festivalConfig['value'].length,
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
                    child: Center(child: Text(festivalConfig['value'][itemIndex].toString(), style: carouselPage.value == itemIndex ? FontTheme.subtitle1WhiteBold : FontTheme.subtitle1GreyBold)),
                  )
              ),
            );
          }
      )
    );
  }

  Widget tabContent(CarouselController carouselController, ValueNotifier<int> carouselPage, List<QueryDocumentSnapshot<Map<String, dynamic>>> festivalsSnapshot, Map<String, dynamic> festivalConfig, Map<String, dynamic> festivals) {

    return CarouselSlider.builder(
        options: CarouselOptions(
          height: double.infinity,
          viewportFraction: 1,
          enableInfiniteScroll: false,
          scrollPhysics: const NeverScrollableScrollPhysics()
        ),
        carouselController: carouselController,
        itemCount: festivalConfig['value'].length,
        itemBuilder: (context, itemIndex, pageViewIndex) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView.builder(
              itemCount: (festivals[festivalConfig['value'][carouselPage.value]] != null) ? festivals[festivalConfig['value'][carouselPage.value]].length : 0,
              itemBuilder: (context, index) {
                return festivalItem(context, festivalsSnapshot[index], festivals[festivalConfig['value'][carouselPage.value]][index]);
              },
            ),
          );
        }
    );
  }

  Widget festivalItem(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> festivalSnapshot, Map<String, dynamic> festival) {

    FestivalInfo festivalInfo = FestivalInfo.fromJson(festival);

    return Bounce(
      onTap: () {
        context.push(Routes.FESTIVAL_INFO, extra: {"pk": festivalInfo.pk});
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        color: ColorTheme.blackPoint,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              child: Image.network(festivalInfo.thumbnail),
              borderRadius: BorderRadius.circular(15),
            ),
            const SizedBox(height: 15),
            Text(festivalInfo.title, style: FontTheme.headline3),
            const SizedBox(height: 10),
            Text(festivalInfo.summary, style: FontTheme.subtitle1,),
            const SizedBox(height: 10),
            Text("${DateFormat.yMMMd('en_US').format(festivalInfo.startDate)} ${DateFormat.Hm('en_US').format(festivalInfo.startDate)} ~ ${DateFormat.yMMMd('en_US').format(festivalInfo.endDate)} ${DateFormat.Hm('en_US').format(festivalInfo.endDate)}", style: FontTheme.subtitle2),
            const SizedBox(height: 15),
            Row(
              children: [
                Stack(
                  children: [
                    userCircle(0),
                    userCircle(15),
                    userCircle(30)
                  ]
                ),
                const SizedBox(width: 10),
                Text("${festivalInfo.member.length}명", style: FontTheme.subtitle2PointBold),
                const Text("이 참여했어요", style: FontTheme.subtitle2Point)
              ],
            )
          ]
        )
      )
    );
  }

  Widget userCircle(double leftMargin) {
    return Container(
      width: 30,
      height: 30,
      margin: EdgeInsets.fromLTRB(leftMargin, 0, 0, 0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorTheme.greyThickest,
        border: Border.all(width: 3, color: ColorTheme.blackPoint)
      ),
    );
  }
}
