import 'package:capybara/firebase_options.dart';
import 'package:capybara/src/api/users_api.dart';
import 'package:capybara/src/config/routes.dart';
import 'package:capybara/src/locator/locator.dart';
import 'package:capybara/src/provider/festival_provider.dart';
import 'package:capybara/src/provider/user_provider.dart';
import 'package:capybara/src/theme/color_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  KakaoSdk.init(nativeAppKey: dotenv.get("KAKAO_NATIVE_API"));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  setupLocator();
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => FestivalProvider()),
            ChangeNotifierProvider(create: (_) => UserProvider()),
          ],
          child: const App()
      )
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      theme: ThemeData(
        fontFamily: 'Pretendard',
        textTheme: TextTheme(

        ),
        splashColor: ColorTheme.greyThick
      )
    );
  }
}
