// @dart=2.9
import 'dart:io';

import 'package:app/res/owner_colors.dart';
import 'package:app/ui/navigation/auth/login.dart';
import 'package:app/ui/navigation/auth/register.dart';
import 'package:app/ui/navigation/intro/onboarding.dart';
import 'package:app/ui/navigation/intro/splash.dart';
import 'package:app/ui/navigation/main/checkout_flow/checkout.dart';
import 'package:app/ui/navigation/main/checkout_flow/method_payment.dart';
import 'package:app/ui/navigation/main/checkout_flow/sucess.dart';
import 'package:app/ui/navigation/main/filter_products.dart';
import 'package:app/ui/navigation/main/home.dart';
import 'package:app/ui/navigation/main/menu/address/user_addresses.dart';
import 'package:app/ui/navigation/main/menu/categories/categories.dart';
import 'package:app/ui/navigation/main/menu/categories/products.dart';
import 'package:app/ui/navigation/main/menu/categories/subcategories.dart';
import 'package:app/ui/navigation/main/menu/payments/payments.dart';
import 'package:app/ui/navigation/main/menu/user/profile.dart';
import 'package:app/ui/navigation/main/notifications.dart';
import 'package:app/ui/navigation/main/product/product_detail.dart';
import 'package:app/ui/navigation/utilities/pdf_viewer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Preferences.init();

  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  } else if (Platform.isIOS){
    await Firebase.initializeApp(
        /*options: FirebaseOptions(
      apiKey: WSConstants.API_KEY,
      appId: WSConstants.APP_ID,
      messagingSenderId: WSConstants.MESSGING_SENDER_ID,
      projectId: WSConstants.PROJECT_ID,
    )*/);
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Mensagem recebida: ${message.notification.title}');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Mensagem aberta: ${message.notification.title}');
  });

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Mensagem recebida em segundo plano: ${message.notification.title}');
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Água da Serra",
    initialRoute: '/ui/splash',
    color: OwnerColors.colorPrimary,
    routes: {
      '/ui/splash': (context) => Splash(),
      '/ui/onboarding': (context) => Onboarding(),
      '/ui/login': (context) => Login(),
      '/ui/register': (context) => Register(),
      '/ui/home': (context) => Home(),
      '/ui/profile': (context) => Profile(),
      '/ui/pdf_viewer': (context) => PdfViewer(),
      '/ui/categories': (context) => Categories(),
      '/ui/subcategories': (context) => SubCategories(),
      '/ui/products': (context) => Products(),
      '/ui/product_detail': (context) => ProductDetail(),
      '/ui/user_addresses': (context) => UserAddresses(),
      '/ui/method_payment': (context) => MethodPayment(),
      '/ui/checkout': (context) => Checkout(),
      '/ui/payments': (context) => Payment(),
      '/ui/success': (context) => Success(),
      '/ui/notifications': (context) => Notifications(),
      '/ui/filter_products': (context) => FilterProducts(),

      //lista horizontal
      // Container(
      //   height: 180,
      //   child: ListView.builder(
      //     scrollDirection: Axis.horizontal,
      //     itemCount: /*numbersList.length*/ 2,
      //     itemBuilder: (context, index) {
      //       return Card(
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(
      //               Dimens.minRadiusApplication),
      //         ),
      //         margin:
      //             EdgeInsets.all(Dimens.minMarginApplication),
      //         child: Container(
      //           width: MediaQuery.of(context).size.width * 0.80,
      //           padding:
      //               EdgeInsets.all(Dimens.paddingApplication),
      //         ),
      //       );
      //     },
      //   ),
      // ),
    },
  ));
}
