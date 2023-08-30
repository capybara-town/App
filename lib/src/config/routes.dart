import 'package:capybara/src/screen/login/login_screen.dart';
import 'package:go_router/go_router.dart';

import '../screen/festival/festival_info_screen.dart';
import '../screen/frame_screen.dart';
import '../screen/login/login_screen.dart';

class Routes {
  static const String FRAME = "/frame";
  static const String FESTIVAL_INFO = "/festivalInfo/:pk";
  static const String LOGIN = "/login";
}

final GoRouter router = GoRouter(
    initialLocation: Routes.FRAME,
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

    ]
);