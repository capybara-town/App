import 'package:go_router/go_router.dart';

import '../screen/festival/festival_info_screen.dart';
import '../screen/frame_screen.dart';

class Routes {
  static const String FRAME = "/frame";
  static const String FESTIVAL_INFO = "/festivalInfo/:pk";
}

final GoRouter router = GoRouter(
    initialLocation: Routes.FRAME,
    routes: [
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
      )
    ]
);