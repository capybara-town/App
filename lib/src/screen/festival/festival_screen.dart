import 'package:capybara/src/config/routes.dart';
import 'package:capybara/src/theme/color_theme.dart';
import 'package:capybara/src/theme/font_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../component/bounce.dart';
import '../../component/bounce_grey.dart';
import '../../model/festival/festival_info.dart';

class FestivalScreen extends HookWidget {
  FestivalScreen({Key? key}) : super(key: key);

  final db = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getFestivals() async {
    return db.collection("festivals").get();
  }

  @override
  Widget build(BuildContext context) {

    final carouselController = useState(CarouselController());
    final carouselPage = useState(0);

    final snapshot = useFuture(getFestivals());

    return SafeArea(
      bottom: false,
      child: snapshot.hasError ?
          const Center(child: Text("error has occured")) :
          snapshot.hasData ?
              Column(
                children: [
                  tabBar(carouselController, carouselPage),
                  Expanded(
                    child: tabContent(carouselController, carouselPage, snapshot.data!.docs)
                  )
                ]
              ) :
              const Center(child: CircularProgressIndicator())
    );
  }

  Widget tabBar(ValueNotifier<CarouselController> carouselController, ValueNotifier<int> carouselPage) {

    return Container(
      height: 60,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: ColorTheme.greyThickest)),
          color: ColorTheme.blackPoint
      ),
      child: ListView.builder(
          itemCount: 4,
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
                    carouselController.value.jumpToPage(itemIndex);
                    carouselPage.value = itemIndex;
                  },
                  activeColor: ColorTheme.greyThickest,
                  paddingHorizontal: 5,
                  paddingVertical: 0,
                  radius: 5,
                  scale: 0.8,
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Center(child: Text("개발", style: carouselPage.value == itemIndex ? FontTheme.subtitle1WhiteBold : FontTheme.subtitle1GreyBold)),
                  )
              ),
            );
          }
      ),
    );
  }

  Widget tabContent(ValueNotifier<CarouselController> carouselController, ValueNotifier<int> carouselPage, List<QueryDocumentSnapshot<Map<String, dynamic>>> festivals) {

    return CarouselSlider.builder(
        options: CarouselOptions(
          height: double.infinity,
          viewportFraction: 1,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason) {
            carouselPage.value = index;
          },
        ),
        carouselController: carouselController.value,
        itemCount: 4,
        itemBuilder: (context, itemIndex, pageViewIndex) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView.builder(
              itemCount: festivals.length,
              itemBuilder: (context, index) {
                return festivalItem(context, festivals[index]);
              },
            ),
          );
        }
    );
  }

  Widget festivalItem(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> festival) {

    FestivalInfo festivalInfo = FestivalInfo.fromJson(festival.data());

    return Bounce(
      onTap: () {
        context.push(Routes.FESTIVAL_INFO, extra: {"pk": festival.id});
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
            Text("${festivalInfo.startDate.toString()} ~ ${festivalInfo.endDate.toString()}", style: FontTheme.subtitle2),
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
                Text("120명", style: FontTheme.subtitle2PointBold),
                Text("이 참여했어요", style: FontTheme.subtitle2Point)
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
