import 'package:capybara/firebase_options.dart';
import 'package:capybara/src/config/routes.dart';
import 'package:capybara/src/provider/festival_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => FestivalProvider()),
          ],
          child: const App()
      )
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
