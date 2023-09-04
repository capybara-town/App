import 'package:capybara/src/component/zero_content.dart';
import 'package:capybara/src/config/routes.dart';
import 'package:capybara/src/provider/festival_provider.dart';
import 'package:capybara/src/theme/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../component/bounce_grey.dart';
import '../../model/festival/festival_info.dart';

class FestivalScreen extends HookWidget {
  FestivalScreen({Key? key}) : super(key: key);

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final FestivalProvider festivalProvider = Provider.of<FestivalProvider>(
        context);

    final snapshotFuture = useMemoized(() => festivalProvider.getFestivals());
    final festivalConfigFuture = useMemoized(() =>
        festivalProvider.getFestivalConfig());
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
      festivalConfig =
      festivalConfigSnapshot.data!.data() as Map<String, dynamic>;
    }

    return SafeArea(
        bottom: false,
        child: (festivalConfigSnapshot.hasError && snapshot.hasError) ?
        const Center(child: Text("error has occured")) :
        (festivalConfigSnapshot.hasData && snapshot.hasData) ?
        DefaultTabController(
          length: festivalConfig['value'].length,
          child: Scaffold(
            backgroundColor: ColorTheme.greyThickest,
            appBar: AppBar(
              backgroundColor: ColorTheme.blackPoint,
              bottom: TabBar(tabs: [
                for (int index = 0; index <
                    festivalConfig['value'].length; index++)
                  Tab(text: festivalConfig['value'][index])
              ],
                splashFactory: NoSplash.splashFactory,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorSize: TabBarIndicatorSize.tab,
                padding: const EdgeInsets.only(left: 20),
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
                children: [
                  for (int index = 0; index < festivalConfig['value'].length; index++)
                    (groupFestivals[festivalConfig['value'][index]] != null) ?
                        ListView.builder(
                          itemCount: (groupFestivals[festivalConfig['value'][index]] !=
                              null) ? groupFestivals[festivalConfig['value'][index]]
                              .length : 0,
                          itemBuilder: (context, pageIndex) {
                            return festivalItem(
                                context, snapshot.data!.docs[pageIndex],
                                groupFestivals[festivalConfig['value'][index]][pageIndex]);
                          },
                        ) :
                        const ZeroContent()
                ]
            ),
          ),
        ) :
        const Center(child: CircularProgressIndicator())
    );
  }

  Widget festivalItem(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> festivalSnapshot, Map<String, dynamic> festival) {

    FestivalInfo festivalInfo = FestivalInfo.fromJson(festival);

    return Column(
      children: [
        BounceGrey(
          onTap: () {
            context.push(Routes.FESTIVAL_INFO, extra: {"pk": festivalInfo.pk});
          },
          paddingHorizontal: 20,
          paddingVertical: 15,
          radius: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xff3F3D39)
                        ),
                        child: const Text("컨퍼런스", style: TextStyle(fontSize: 10, color: Color(0xffB6B6AD), fontWeight: FontWeight.w600))
                      ),
                      const SizedBox(height: 8),
                      Text(festivalInfo.title, style: const TextStyle(fontSize: 14, color: ColorTheme.white)),
                      const SizedBox(height: 8),
                      Text(festivalInfo.summary, style: const TextStyle(fontSize: 12, color: ColorTheme.greyLightest)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ExtendedImage.network(
                  festivalInfo.thumbnail,
                  width: 60,
                  height: 60,
                  cache: true,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(10),
                  loadStateChanged: (state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                              color: ColorTheme.greyThickest
                          ),
                        );
                      case LoadState.completed:
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: ColorTheme.greyThick)
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ExtendedRawImage(
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              image: state.extendedImageInfo?.image,
                            ),
                          ),
                        );
                      case LoadState.failed:
                        return Container(
                          width: 60,
                          height: 60,
                          color: ColorTheme.greyThickest,
                        );
                    }
                  },
                ),
              ]),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(festivalInfo.startDate.toString(), style: const TextStyle(fontSize: 12, color: Color(0xff86867D))),
                  const Spacer(),
                  SvgPicture.asset('asset/image/users.svg'),
                  const SizedBox(width: 3),
                  Text("${festivalInfo.member.length}", style: const TextStyle(fontSize: 12, color: Color(0xff86867D)))
                ]
              )
            ]
          )
        ),
        divider()
      ],
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

  Widget divider()
  {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        width: double.infinity,
        height: 1,
        color: const Color(0xff302E2C)
    );
  }
}
