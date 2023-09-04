import 'package:capybara/src/screen/festival/festival_meet_screen.dart';
import 'package:capybara/src/screen/festival/meet_add_screen.dart';
import 'package:capybara/src/screen/login/login_screen.dart';
import 'package:capybara/src/screen/user/follow_screen.dart';
import 'package:capybara/src/screen/user/profile_screen.dart';
import 'package:go_router/go_router.dart';
import '../screen/festival/festival_info_screen.dart';
import '../screen/frame_screen.dart';

class Routes {
  static const String FRAME = "/frame";
  static const String FESTIVAL_INFO = "/festivalInfo/:pk";
  static const String LOGIN = "/login";
  static const String FESTIVAL_MEET = "/festivalMeet/:pk";
  static const String MEET_ADD = "/meetAdd/:festivalPk/:festivalTitle";
  static const String PROFILE = "/profile/:uid/:me";
  static const String FOLLOW = "/follow/:uid";
}

final GoRouter router = GoRouter(
    initialLocation: Routes.LOGIN,
    routes: [
      GoRoute(
          path: Routes.LOGIN,
          builder: (context, state) => const LoginScreen()
      ),
      GoRoute(
          path: Routes.FRAME,
          builder: (context, state) => const FrameScreen()
      ),
      GoRoute(
          path: Routes.FESTIVAL_INFO,
          builder: (context, state) {
            final String pk = (state.extra! as Map<String, dynamic>)['pk'] as String;
            return FestivalInfoScreen(pk: pk);
          }
      ),
      GoRoute(
          path: Routes.FESTIVAL_MEET,
          builder: (context, state) {
            final String pk = (state.extra! as Map<String, dynamic>)['pk'] as String;
            return FestivalMeetScreen(pk: pk);
          }
      ),
      GoRoute(
        path: Routes.MEET_ADD,
        builder: (context, state) {
          final String festivalPk = (state.extra! as Map<String, dynamic>)['festivalPk'] as String;
          final String festivalTitle = (state.extra! as Map<String, dynamic>)['festivalTitle'] as String;
          final DateTime festivalStart = (state.extra! as Map<String, dynamic>)['festivalStart'] as DateTime;
          return MeetAddScreen(festivalPk: festivalPk, festivalTitle: festivalTitle, festivalStart: festivalStart);
        },
      ),
      GoRoute(
        path: Routes.PROFILE,
        builder: (context, state) {
          final String uid = (state.extra! as Map<String, dynamic>)['uid'] as String;
          final bool push = (state.extra! as Map<String, dynamic>)['push'] as bool;
          return ProfileScreen(uid: uid, push: push);
        }
      ),
      GoRoute(
        path: Routes.FOLLOW,
        builder: (context, state) {
          final String uid = (state.extra! as Map<String, dynamic>)['uid'] as String;
          final int initialIndex = (state.extra! as Map<String, dynamic>)['initialIndex'] as int;
          return FollowScreen(uid: uid, initialIndex: initialIndex);
        }
      )
    ]
);