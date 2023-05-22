import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../config/application_messages.dart';
import '../../../../config/preferences.dart';
import '../../../../global/application_constant.dart';
import '../../../../model/user.dart';
import '../../../../res/dimens.dart';
import '../../../../res/owner_colors.dart';
import '../../../../res/strings.dart';
import '../../../../res/styles.dart';
import '../../../../web_service/links.dart';
import '../../../../web_service/service_response.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/progress_hud.dart';

class MethodPayment extends StatefulWidget {
  const MethodPayment({Key? key}) : super(key: key);

  @override
  State<MethodPayment> createState() => _MethodPayment();
}

class _MethodPayment extends State<MethodPayment>
    with TickerProviderStateMixin {
  final postRequest = PostRequest();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> payWithCreditCard(String idOrder, String totalValue, String idCreditCard) async {
    try {
      final body = {
        "id_usuario": await Preferences.getUserData()!.id,
        "id_pedido": idOrder,
        "tipo_pagamento": ApplicationConstant.CREDIT_CARD,
        "payment_id": "",
        "valor": totalValue,
        "card": idCreditCard,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.ADD_PAYMENT, body);

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

  Future<void> payWithTicketWithOutAddress(String idOrder, String totalValue) async {
    try {
      final body = {
        "id_pedido": idOrder,
        "id_usuario": await Preferences.getUserData()!.id,
        "tipo_pagamento": ApplicationConstant.TICKET_IN_TERM,
        "valor": totalValue,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.ADD_PAYMENT, body);

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

  Future<void> payWithTicket(String idOrder, String totalValue) async {
    try {
      final body = {
        "id_pedido": idOrder,
        "id_usuario": await Preferences.getUserData()!.id,
        "tipo_pagamento": ApplicationConstant.TICKET,
        "valor": totalValue ,
        "cep": "90690-040",
        "estado": "RS",
        "cidade": "Porto Alegre",
        "endereco": "Rua Antonio carlos tibiricça",
        "bairro": "Petroópolis",
        "numero": "7464",
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.ADD_PAYMENT, body);

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

  Future<void> payWithPIX(String idOrder, String totalValue) async {
    try {
      final body = {
        "id_pedido": idOrder,
        "id_usuario": await Preferences.getUserData()!.id,
        "tipo_pagamento": ApplicationConstant.PIX,
        "valor": totalValue,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.ADD_PAYMENT, body);

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

  Future<List<Map<String, dynamic>>> findAddress() async {
    try {
      final body = {"id_endereco": 29, "token": ApplicationConstant.TOKEN};

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.FIND_ADDRESS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
            title: "Escolha um Método de pagamento", isVisibleBackButton: true),
        body: Container(
            child: SingleChildScrollView(
                child: Column(children: [
          Container(
            height: 60,
            child: TabBar(
              tabs: [
                Container(
                  child: Text(
                    'Entrega',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  child: Text(
                    'Retirada no local',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
              unselectedLabelColor: const Color(0xffacb3bf),
              indicatorColor: Color(0xFFffac81),
              labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3.0,
              indicatorPadding: EdgeInsets.all(10),
              isScrollable: false,
              controller: _tabController,
            ),
          ),
          Container(
            height: 200,
            child: TabBarView(controller: _tabController, children: <Widget>[
              Container(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: findAddress(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final response = User.fromJson(snapshot.data![0]);

                        if (response.rows != 0) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(Dimens.minRadiusApplication),
                            ),
                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, "/ui/user_addresses");
                                },
                                child: Container(
                                  padding: EdgeInsets.all(Dimens.paddingApplication),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Endereço selecionado",
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: Dimens.textSize4,
                                                fontWeight: FontWeight.bold,
                                                color: OwnerColors.colorPrimaryDark,
                                              ),
                                            ),
                                            SizedBox(
                                                height: Dimens.minMarginApplication),
                                            Text(
                                              response.endereco_completo,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: Dimens.textSize5,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                                height: Dimens.minMarginApplication),
                                            Styles().div_horizontal
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    }),
              ),
              Container(
                child: Text("sign up"),
              )
            ]),
          ),

          SizedBox(height: Dimens.minMarginApplication),
          Styles().div_horizontal,
          SizedBox(height: Dimens.minMarginApplication),
          InkWell(
              onTap: () {},
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimens.minRadiusApplication),
                  ),
                  margin: EdgeInsets.all(Dimens.minMarginApplication),
                  child: Container(
                    padding: EdgeInsets.all(Dimens.minPaddingApplication),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                            child: Material(
                                borderRadius: BorderRadius.circular(
                                    Dimens.minRadiusApplication),
                                elevation: Dimens.elevationApplication,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.minRadiusApplication),
                                    child: Image.asset('images/qr_code.png',
                                        height: 70, width: 70)))),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "PIX",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize6,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: Dimens.minMarginApplication,
                            ),
                            Text(
                              "Liberação das moedas de forma instantânea.",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize4,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        )),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black38,
                            size: 20,
                          ),
                          onPressed: () => {},
                        )
                      ],
                    ),
                  ))),
          InkWell(
              onTap: () {},
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimens.minRadiusApplication),
                  ),
                  margin: EdgeInsets.all(Dimens.minMarginApplication),
                  child: Container(
                    padding: EdgeInsets.all(Dimens.minPaddingApplication),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                            child: Material(
                                borderRadius: BorderRadius.circular(
                                    Dimens.minRadiusApplication),
                                elevation: Dimens.elevationApplication,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.minRadiusApplication),
                                    child: Image.asset('images/credit_card.png',
                                        height: 70, width: 70)))),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Novo Cartão de Crédito",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize6,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: Dimens.minMarginApplication,
                            ),
                            Text(
                              "Pagamento de forma segura e instantânea.",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize4,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        )),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black38,
                            size: 20,
                          ),
                          onPressed: () => {},
                        )
                      ],
                    ),
                  ))),
          InkWell(
              onTap: () {},
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimens.minRadiusApplication),
                  ),
                  margin: EdgeInsets.all(Dimens.minMarginApplication),
                  child: Container(
                    padding: EdgeInsets.all(Dimens.minPaddingApplication),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                            child: Material(
                                borderRadius: BorderRadius.circular(
                                    Dimens.minRadiusApplication),
                                elevation: Dimens.elevationApplication,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.minRadiusApplication),
                                    child: Image.asset('images/ticket.png',
                                        height: 70, width: 70)))),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Boleto",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize6,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: Dimens.minMarginApplication,
                            ),
                            Text(
                              "Será aprovado em 1 a 2 dias úteis.",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize4,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        )),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black38,
                            size: 20,
                          ),
                          onPressed: () => {},
                        )
                      ],
                    ),
                  )))
        ]))));
  }
}
