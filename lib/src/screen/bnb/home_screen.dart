import 'package:flutter/material.dart';

import '../../theme/color_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorTheme.blackPoint,
      body: Center(
        child: Text("Home Screen")
      ),
    );
  }
}
