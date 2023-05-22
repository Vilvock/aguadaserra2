import 'dart:convert';

import 'package:app/res/styles.dart';
import 'package:flutter/material.dart';
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

        setState(() {

        });

      } else {

      }
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Menu Principal", isVisibleBackButton: false),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          children: [
            // Expanded(
            Material(
                elevation: Dimens.elevationApplication,
                child: Container(
                  padding: EdgeInsets.all(Dimens.paddingApplication),
                  color: Colors.black12,
                  child: Row(
                    children: [
                      Container(
                        margin:
                        EdgeInsets.only(right: Dimens.marginApplication),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('images/person.jpg'),
                          radius: 32,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lorem Ipsum Nome",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize6,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: Dimens.minMarginApplication),
                            Text(
                              "email@email.com.br",
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
                        onPressed: () =>
                        {Navigator.pushNamed(context, "/ui/profile")},
                      )
                    ],
                  ),
                )),

            GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(Dimens.minMarginApplication),
                        child:
                        Icon(Icons.pin_drop_outlined, color: Colors.black),
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
                        child:
                        Icon(Icons.monetization_on_outlined, color: Colors.black),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Meus pegamentos",
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
                          margin: EdgeInsets.all(Dimens.minMarginApplication),
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
                onTap: () {Navigator.pushNamed(context, "/ui/categories");}
            ),

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
                onTap: () {}),


            Styles().div_horizontal,

            GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(Dimens.minMarginApplication),
                        child: Icon(Icons.logout_outlined, color: Colors.black),
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return GenericAlertDialog(
                          title: Strings.attention,
                          content: Strings.logout,
                          btnBack: TextButton(
                              child: Text(Strings.no),
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

            Styles().div_horizontal
          ],
        ),
      ),
    );
  }
}
