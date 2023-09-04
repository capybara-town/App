import 'package:capybara/src/component/user_list_item.dart';
import 'package:capybara/src/provider/user_provider.dart';
import 'package:capybara/src/theme/color_theme.dart';
import 'package:capybara/src/theme/font_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../component/bounce.dart';
import '../../model/member.dart';

class FollowScreen extends HookWidget {
  const FollowScreen({Key? key, required this.uid, required this.initialIndex}) : super(key: key);

  final String uid;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2, initialIndex: initialIndex);

    final UserProvider userProvider = Provider.of(context);

    final userFuture = useMemoized(() => userProvider.getUser(uid));
    final userSnapshot = useFuture(userFuture);


    Member user = const Member(uid: "", profileImage: "", name: "", nickname: "", belong: "", role: "", interest: [], personality: [], follower: [], following: [], introduceLink: "");
    List<Member> followers = [];
    List<Member> followings = [];

    final followerCompleted = useState(false);
    final followingCompleted = useState(false);

    if (userSnapshot.data != null) {
      user = Member.fromJson(userSnapshot.data!.data() as Map<String, dynamic>);
      final followersFuture = useMemoized(() => userProvider.getUsers(user.follower));
      final followersSnapshot = useFuture(followersFuture);
      final followingsFuture = useMemoized(() => userProvider.getUsers(user.following));
      final followingsSnapshot = useFuture(followingsFuture);
      if (followersSnapshot.data != null) {
        followers = followersSnapshot.data!.docs.map((e) => Member.fromJson(e.data())).toList();
        followerCompleted.value = true;
      }
      if (followingsSnapshot.data != null) {
        followings = followingsSnapshot.data!.docs.map((e) => Member.fromJson(e.data())).toList();
        followingCompleted.value = true;
      }
    }

    return Scaffold(
      backgroundColor: ColorTheme.blackPoint,
      appBar: AppBar(
        backgroundColor: ColorTheme.blackPoint,
        title: Text("${user.nickname}의 팔로우", style: FontTheme.headline3),
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
        bottom: TabBar(
          controller: tabController,
          labelColor: Colors.white,
          unselectedLabelColor: ColorTheme.greyPoint,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: ColorTheme.white,
          indicatorWeight: 1,
          dividerColor: ColorTheme.greyThickest,
          splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStateProperty.resolveWith((states) =>
          states.contains(MaterialState.focused)
              ? null
              : ColorTheme.greyThickest),
          tabs: const [
            Tab(text: "팔로워"),
            Tab(text: "팔로우 중")
          ],
        ),
      ),
      body: (followerCompleted.value || followingCompleted.value) ?
        TabBarView(
          controller: tabController,
          children: [
            list(context, followers),
            list(context, followings)
          ]
        ) :
        const Center(child: CircularProgressIndicator())
    );
  }

  Widget list(BuildContext context, List<Member> users) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 20),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return UserListItem(member: users[index], index: index);
      },
    );
  }
}
