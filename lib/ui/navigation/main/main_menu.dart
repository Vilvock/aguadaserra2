import 'dart:convert';
import 'dart:io';

import 'package:app/res/styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/application_messages.dart';
import '../../../config/preferences.dart';
import '../../../config/validator.dart';
import '../../../global/application_constant.dart';
import '../../../model/user.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/strings.dart';
import '../../../web_service/links.dart';
import '../../../web_service/service_response.dart';
import '../../components/alert_dialog_generic.dart';
import '../../components/custom_app_bar.dart';

import '../auth/login.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> {
  @override
  void initState() {
    super.initState();
  }

  late Validator validator;
  final postRequest = PostRequest();
  User? _profileResponse;

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(launchWhatsApp(phone: 554836582500, message: "").toString()), mode: LaunchMode.externalNonBrowserApplication)) {
      throw Exception('Could not launch');
    }
  }

  String launchWhatsApp(
      {required int phone,
        required String message,
      }) {
    String url() {
/*      if (Platform.isAndroid) {
        // add the [https]
        return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
      } else {
        // add the [https]*/
        return "https://api.whatsapp.com/send?phone=554836512500"; // new line
      // }
    }
    return url();
  }

  Future<Map<String, dynamic>> loadProfileRequest() async {
    try {
      final body = {
        "id": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LOAD_PROFILE, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = User.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> disableAccount() async {
    try {
      final body = {
        "id": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.DISABLE_ACCOUNT, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        await Preferences.init();
        Preferences.clearUserData();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Login()),
            ModalRoute.withName("/ui/login"));
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg + "\n\n" + Strings.enable_account);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            CustomAppBar(title: "Menu Principal", isVisibleBackButton: false),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                // Expanded(
                FutureBuilder<Map<String, dynamic>>(
                  future: loadProfileRequest(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final response = User.fromJson(snapshot.data!);

                      return Material(
                          elevation: Dimens.elevationApplication,
                          child: Container(
                            padding: EdgeInsets.all(Dimens.paddingApplication),
                            color: OwnerColors.lightGrey,
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      right: Dimens.marginApplication),
                                  child: ClipOval(
                                    child: SizedBox.fromSize(
                                      size: Size.fromRadius(32), // Image radius
                                      child: Image.network(
                                        ApplicationConstant.URL_AVATAR +
                                            response.avatar.toString(),
                                        fit: BoxFit.cover, /*fit: BoxFit.cover*/
                                          errorBuilder: (context, exception, stackTrack) => Image.asset(
                                            'images/default.png',
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        response.nome,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize6,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                          height: Dimens.minMarginApplication),
                                      Text(
                                        response.email,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize5,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_forward_ios,
                                      color: Colors.black38),
                                  onPressed: () => {
                                    Navigator.pushNamed(context, "/ui/profile")
                                  },
                                )
                              ],
                            ),
                          ));
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),

                GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                            child: Icon(Icons.pin_drop_outlined,
                                color: Colors.black),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Meus endereços",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: Dimens.minMarginApplication),
                                Text(
                                  "Atualize ou determine seu endereço principal",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize4,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/ui/user_addresses");
                    }),

                Styles().div_horizontal,

                GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                            child: Icon(Icons.monetization_on_outlined,
                                color: Colors.black),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Meus pagamentos",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: Dimens.minMarginApplication),
                                Text(
                                  "Visualize seu histórico de pagamentos",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize4,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/ui/payments");
                    }),

                Styles().div_horizontal,
                GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                      child: Row(
                        children: [
                          Container(
                              margin:
                                  EdgeInsets.all(Dimens.minMarginApplication),
                              child: Icon(Icons.category_outlined,
                                  color: Colors.black)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Categorias",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: Dimens.minMarginApplication),
                                Text(
                                  "Visualize categorias de ofertas",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize4,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/ui/categories");
                    }),

                Styles().div_horizontal,
                GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                            child: Icon(Icons.contact_support_outlined,
                                color: Colors.black),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Suporte",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: Dimens.minMarginApplication),
                                Text(
                                  "Contacte o suporte",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize4,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      await _launchUrl();

                    }),

                Styles().div_horizontal,

                GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                            child: Icon(Icons.disabled_by_default_outlined,
                                color: Colors.black),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Desativar",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: Dimens.minMarginApplication),
                                Text(
                                  "Desativará permanentemente sua conta",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize4,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      showModalBottomSheet<dynamic>(
                        isScrollControlled: true,
                        context: context,
                        shape: Styles().styleShapeBottomSheet,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        builder: (BuildContext context) {
                          return GenericAlertDialog(
                              title: Strings.attention,
                              content: Strings.disable_account,
                              btnBack: TextButton(
                                  child: Text(Strings.no,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.black54,
                                      )),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                              btnConfirm: TextButton(
                                  child: Text(Strings.yes),
                                  onPressed: () {
                                    disableAccount();
                                  }));
                        },
                      );
                    }),

                Styles().div_horizontal,

                GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                            child: Icon(Icons.logout_outlined,
                                color: Colors.black),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sair",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: Dimens.minMarginApplication),
                                Text(
                                  "Deslogar desta conta",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize4,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      showModalBottomSheet<dynamic>(
                        isScrollControlled: true,
                        context: context,
                        shape: Styles().styleShapeBottomSheet,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        builder: (BuildContext context) {
                          return GenericAlertDialog(
                              title: Strings.attention,
                              content: Strings.logout,
                              btnBack: TextButton(
                                  child: Text(
                                    Strings.no,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Colors.black54,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                              btnConfirm: TextButton(
                                  child: Text(Strings.yes),
                                  onPressed: () async {
                                    await Preferences.init();
                                    Preferences.clearUserData();

                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()),
                                        ModalRoute.withName("/ui/login"));
                                  }));
                        },
                      );
                    }),

                Styles().div_horizontal,
              ],
            ),
          ),
        ));
  }
}
