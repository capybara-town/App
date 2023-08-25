import 'package:capybara/src/provider/ui_provider.dart';
import 'package:capybara/src/screen/frame_screen.dart';
import 'package:capybara/src/screen/bnb/home_screen.dart';
import 'package:capybara/src/screen/login/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UiProvider()),
          ],
          child: const App()
      )
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const FrameScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
