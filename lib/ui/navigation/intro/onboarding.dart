import 'dart:async';

import 'package:app/res/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../components/dot_indicator.dart';
import '../auth/login.dart';

// VAI NA LINHA 68
class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late PageController _pageController;
  int _pageIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
    //
    // _timer = Timer.periodic(Duration(seconds: 4), (timer) {
    //   if (_pageIndex < 2) {
    //     _pageIndex++;
    //     _pageController.animateToPage(
    //       _pageIndex,
    //       duration: Duration(milliseconds: 400),
    //       curve: Curves.easeInOut,
    //     );
    //   } else {
    //     _pageIndex = 0;
    //     _pageController.animateToPage(
    //       _pageIndex,
    //       duration: Duration(milliseconds: 400),
    //       curve: Curves.easeInOut,
    //     );
    //   }
    // });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          OwnerColors.gradientFirstColor,
          OwnerColors.gradientSecondaryColor,
          OwnerColors.gradientThirdColor
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(
          children: [
            Expanded(
                child: PageView.builder(
                    itemCount: demo_data.length,
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _pageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) => OnboardingContent(
                          image: demo_data[index].image,
                          title: demo_data[index].title,
                          subtitle: demo_data[index].subtitle,
                        ))),
            SizedBox(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Dimens.paddingApplication),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(
                              demo_data.length,
                              (index) => Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: DotIndicator(
                                      isActive: index == _pageIndex,
                                      color: Colors.white,
                                    ),
                                  )),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(Dimens.marginApplication),
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            style: Styles().styleDefaultButton,
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()),
                                  ModalRoute.withName("/ui/login"));
                            },
                            child: Text(
                              "Pular",
                              style: Styles().styleDefaultTextButton,
                            )),
                      ),
                      Text(
                        "Já possui uma conta? Entre aqui",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:Dimens.textSize5,
                            fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Onboard {
  final String image, title, subtitle;

  const Onboard(
      {required this.title, required this.image, required this.subtitle});
}

final List<Onboard> demo_data = [
  Onboard(
    image: 'images/intro1_image.png',
    title: "",
    subtitle: "A Água da Serra é uma marca historicamente jovem.",
  ),
  Onboard(
    image: 'images/intro2_image.png',
    title: "",
    subtitle: "Agora com mais sabores além do original",
  ),
  Onboard(
    image: 'images/intro3_image.png',
    title: "",
    subtitle: "Sabores para todos os gostos",
  )
];

class OnboardingContent extends StatelessWidget {
  final String image, title, subtitle;

  const OnboardingContent(
      {Key? key,
      required this.title,
      required this.image,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
                child: Container(
                  child: Center(
                    child: Image.asset(
                      color: Colors.white,
                      image,
                      height: 180,
                      width: 180,
                    ),
                  ),
                )),
            Container(
                padding: EdgeInsets.all(Dimens.paddingApplication),
                margin: EdgeInsets.only(bottom: Dimens.marginApplication),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      subtitle,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimens.textSize6,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
