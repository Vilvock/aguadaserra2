import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/preferences.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
// VAI NA LINHA 15
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () async {

      await Preferences.init();

      if (await Preferences.getLogin()) {
        Navigator.pushReplacementNamed(context, '/ui/home');
      } else {
        Navigator.pushReplacementNamed(context, '/ui/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(Dimens.paddingApplication),
        child: Center(
          child: Image.asset(
            'images/main_logo_1.png',
          ),
        ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [OwnerColors.gradientFirstColor, OwnerColors.gradientSecondaryColor, OwnerColors.gradientThirdColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)
            ),
          ),
      );
  }
}
