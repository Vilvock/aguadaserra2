// @dart=2.9
import 'dart:io';

import 'package:app/config/useful.dart';
import 'package:app/res/owner_colors.dart';
import 'package:app/ui/navigation/auth/login.dart';
import 'package:app/ui/navigation/auth/recover_password.dart';
import 'package:app/ui/navigation/auth/register.dart';
import 'package:app/ui/navigation/intro/onboarding.dart';
import 'package:app/ui/navigation/intro/splash.dart';
import 'package:app/ui/navigation/main/checkout_flow/checkout.dart';
import 'package:app/ui/navigation/main/checkout_flow/method_payment.dart';
import 'package:app/ui/navigation/main/checkout_flow/sucess.dart';
import 'package:app/ui/navigation/main/filter/filter_products.dart';
import 'package:app/ui/navigation/main/filter/filter_products_results.dart';
import 'package:app/ui/navigation/main/home.dart';
import 'package:app/ui/navigation/main/menu/address/user_addresses.dart';
import 'package:app/ui/navigation/main/menu/categories/categories.dart';
import 'package:app/ui/navigation/main/menu/categories/products.dart';
import 'package:app/ui/navigation/main/menu/categories/subcategories.dart';
import 'package:app/ui/navigation/main/menu/payments/payments.dart';
import 'package:app/ui/navigation/main/menu/user/profile.dart';
import 'package:app/ui/navigation/main/notifications/notifications.dart';
import 'package:app/ui/navigation/main/order/order_detail.dart';
import 'package:app/ui/navigation/main/product/product_detail.dart';
import 'package:app/ui/navigation/utilities/pdf_viewer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/notification_helper.dart';
import 'config/preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  LocalNotification.showNotification(message);
  print("Handling a background message: $message");
}

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

  LocalNotification.initialize();

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

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    LocalNotification.showNotification(message);
    print('Mensagem recebida: ${message.data}');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Mensagem abertaaaaaaaaa: ${message.data}');

  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white, //fundo de todo app
      primarySwatch: Useful().getMaterialColor(OwnerColors.colorPrimary),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Useful().getMaterialColor(OwnerColors.colorPrimary)),
    ),
    debugShowCheckedModeBanner: false,
    title: "Água da Serra",
    initialRoute: '/ui/splash',
    color: OwnerColors.colorPrimary,
    routes: {
      '/ui/splash': (context) => Splash(),
      '/ui/onboarding': (context) => Onboarding(),
      '/ui/login': (context) => Login(),
      '/ui/register': (context) => Register(),
      '/ui/recover_password': (context) => RecoverPassword(),
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
      '/ui/payments': (context) => Payments(),
      '/ui/success': (context) => Success(),
      '/ui/notifications': (context) => Notifications(),
      '/ui/filter_products': (context) => FilterProducts(),
      '/ui/filter_products_results': (context) => FilterProductsResults(),
      '/ui/order_detail': (context) => OrderDetail(),
    },
  ));
}
