import 'package:capybara/src/theme/theme.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: ColorTheme.white,
      child: Center(
        child: Text("Login Screen")
      )
    );
  }
}
