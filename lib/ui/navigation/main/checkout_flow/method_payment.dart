import 'dart:convert';

import 'package:app/model/freight.dart';
import 'package:app/model/order.dart';
import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:flutter/material.dart';

import '../../../../config/application_messages.dart';
import '../../../../config/preferences.dart';
import '../../../../global/application_constant.dart';
import '../../../../model/cart.dart';
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


  bool _isChanged = false;

  int _idAddress = 29;
  late int _idCart;
  late String _totalValue;
  late String _freightValue;
  late String _itensValue;

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
      //
      // if (response.status == "01") {
      // setState(() {
      // });
      // } else {}

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> findWithdrawalTime(String withdrawal, String date) async {
    try {
      final body = {
        "id_retirada": withdrawal,
        "data": date,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.FIND_WITHDRAWAL_TIME, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Order.fromJson(parsedResponse);

    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> findWithdrawal(String idAddress) async {
    try {
      final body = {
        "id_endereco": idAddress,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.FIND_WITHDRAWAL, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Order.fromJson(parsedResponse);

    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> addOrder(
      String idCart,
      String typeDelivery, // 1 tipo entrega no endereco e 2 retirada eu acho
      String? idAddress, // quando for tipo entrega 1
      String? scheduleWithdrawalId, // quando for tipo retirada 2
      String? dateWithdrawal, // quando for tipo retirada 2
      String typePayment,
      String cartValue,
      String freightValue,
      String totalValue,
      String obs) async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "id_carrinho": idCart,
        "tipo_entrega": typeDelivery,
        "id_endereco": idAddress,
        "hora_retirada_id": scheduleWithdrawalId,
        "metodo_pagamento": typePayment,
        "data_retirada": dateWithdrawal,
        "valor": cartValue,
        "valor_frete": freightValue,
        "valor_total": totalValue,
        "obs": obs,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.ADD_ORDER, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Cart.fromJson(_map[0]);

      if (response.status == "01") {

        Navigator.pushNamed(context, "/ui/checkout", arguments: {
          "id_cart": _idCart,
          "total_value": _totalValue,
          "id_order": response.id.toString(),
        });

      } else {}
      // ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> calculeFreightValue() async {
    try {
      final body = {
        "id_endereco": _idAddress,
        "id_carrinho": _idCart,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.CALCULE_FREIGHT, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Freight.fromJson(parsedResponse);

      _itensValue = response.valor_itens;
      _freightValue = response.valor_frete;
      _totalValue = response.valor_total;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> findAddress() async {
    try {
      final body = {
        "id_endereco": _idAddress,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.FIND_ADDRESS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      calculeFreightValue();

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = {};
    data = ModalRoute.of(context)!.settings.arguments as Map;

    _idCart = data['id_cart'];

    return Scaffold(
        resizeToAvoidBottomInset: true,
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
                    "Entrega",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: Dimens.textSize6,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                    child: Text(
                  "Retirada no local",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: Dimens.textSize6,
                    fontWeight: FontWeight.bold,
                  ),
                ))
              ],
              unselectedLabelColor: Colors.grey,
              indicatorColor: OwnerColors.colorPrimaryDark,
              labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2.0,
              indicatorPadding: EdgeInsets.all(Dimens.minPaddingApplication),
              isScrollable: false,
              controller: _tabController,
              onTap: (value) {

                setState(() {
                  if (value == 0) {
                    _isChanged = false;
                  } else {
                    _isChanged = true;
                  }
                });


                print(value);

              },
            ),
          ),
          Container(
            child: AutoScaleTabBarView(controller: _tabController, children: <Widget>[
              Container(
                height: 150,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: findAddress(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final response = User.fromJson(snapshot.data![0]);

                        if (response.rows != 0) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimens.minRadiusApplication),
                            ),
                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, "/ui/user_addresses");
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.all(Dimens.paddingApplication),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              response.nome,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: Dimens.textSize5,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                                height: Dimens
                                                    .minMarginApplication),
                                            Expanded(child:
                                            Text(
                                              response.endereco_completo,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: Dimens.textSize5,
                                                color: Colors.black,
                                              ),
                                            )),
                                            SizedBox(
                                                height: Dimens
                                                    .minMarginApplication),
                                            Styles().div_horizontal,

                                            SizedBox(
                                                height: Dimens
                                                    .minMarginApplication),
                                            Text(
                                              "Alterar endereço",
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: Dimens.textSize4,
                                                fontWeight: FontWeight.bold,
                                                color: OwnerColors
                                                    .colorPrimaryDark,
                                              ),
                                            ),
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
                      return Center(child: CircularProgressIndicator());
                    }),
              ),
              Container(
                padding: EdgeInsets.all(Dimens.paddingApplication),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Escolha a data e horário para retirada",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: Dimens.textSize6,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: Dimens.marginApplication),
                      TextField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: OwnerColors.colorPrimary, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          hintText: 'Data',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Dimens.radiusApplication),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(
                              Dimens.textFieldPaddingApplication),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: Dimens.textSize5,
                        ),
                      ),
                      SizedBox(height: Dimens.marginApplication),
                      TextField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: OwnerColors.colorPrimary, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          hintText: 'Horário',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Dimens.radiusApplication),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(
                              Dimens.textFieldPaddingApplication),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: Dimens.textSize5,
                        ),
                      ),
                    ]),
              )
            ]),
          ),

                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            Dimens.minRadiusApplication),
                      ),
                      margin: EdgeInsets.all(
                          Dimens.minMarginApplication),
                      child: Container(
                        padding: EdgeInsets.all(
                            Dimens.paddingApplication),
                        child: Column(children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Valor do frete",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize6,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                "",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: Dimens.textSize6,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ]),
                      )),
          SizedBox(height: Dimens.minMarginApplication),
          Styles().div_horizontal,
          SizedBox(height: Dimens.minMarginApplication),
          InkWell(
              onTap: () {
                if (_tabController.index == 0) {
                  addOrder(
                      _idCart.toString(),
                      ApplicationConstant.TYPE_DELIVERY_1.toString(),
                      _idAddress.toString(),
                      null,
                      null,
                      ApplicationConstant.PIX.toString(),
                      _itensValue,
                      _freightValue,
                      _totalValue,
                      "");
                } else {
                  // addOrder(
                  //     _idCart.toString(),
                  //     ApplicationConstant.TYPE_DELIVERY_2.toString(),
                  //     null,
                  //     "",
                  //     "",
                  //     ApplicationConstant.PIX.toString(),
                  //     _itensValue,
                  //     _freightValue,
                  //     _totalValue,
                  //     "");
                }


              },
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
                            child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.minRadiusApplication),
                                    child: Image.asset('images/qr_code.png',
                                        height: 50, width: 50))),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "PIX",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize5,
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
                            child:  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.minRadiusApplication),
                                    child: Image.asset('images/credit_card.png',
                                        height: 50, width: 50))),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Novo Cartão de Crédito",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize5,
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
                            child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.minRadiusApplication),
                                    child: Image.asset('images/ticket.png',
                                        height: 50, width: 50))),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Boleto",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize5,
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
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            Dimens.minRadiusApplication),
                                        child: Image.asset('images/calendar.png',
                                            height: 50, width: 50))),
                                Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Boleto à prazo",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: Dimens.textSize5,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: Dimens.minMarginApplication,
                                        ),
                                        Text(
                                          ".",
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
