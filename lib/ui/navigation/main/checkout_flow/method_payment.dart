import 'dart:convert';

import 'package:app/model/freight.dart';
import 'package:app/model/order.dart';
import 'package:app/ui/components/alert_dialog_date_picker.dart';
import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/extension.dart';

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

  var _hasSchedule = false;
  var _schedule = "";
  String _idSchedule = "";

  String _idAddress = "null";
  late int _idCart;
  late String _totalValue;
  late String _freightValue;
  late String _itensValue;

  final postRequest = PostRequest();
  late TabController _tabController;


  User? _profileResponse;
  User? _addressResponse;

  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: 0,
      length: 1,
      vsync: this,
    );
    Preferences.init();
    _idAddress = Preferences.getDefaultAddress().toString();
    print(_idAddress);

    loadProfileRequest();
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void goToCheckout (String typePayment) {

    if (_idAddress == "null") {
      ApplicationMessages(context: context).showMessage("É necessário selecionar um endereço padrão para prosseguir!");

    } else {
      if (_tabController.index == 0) {
        Navigator.pushNamed(context, "/ui/checkout", arguments: {
          "id_cart": _idCart,
          "total_value": _totalValue,
          // "id_order": response.id.toString(),
          "type_payment": typePayment,
          "id_address": _addressResponse?.id.toString(),
          "cep": _addressResponse?.cep.toString(),
          "estado": _addressResponse?.estado.toString(),
          "cidade":_addressResponse?.cidade.toString(),
          "endereco": _addressResponse?.endereco.toString(),
          "bairro": _addressResponse?.bairro.toString(),
          "numero": _addressResponse?.numero.toString(),
          "complemento": _addressResponse?.complemento.toString(),
          "total_items": _itensValue,
          "freight_value": _freightValue,
        });
        // addOrder(
        //     _idCart.toString(),
        //     ApplicationConstant.TYPE_DELIVERY_1.toString(),
        //     _idAddress.toString(),
        //     null,
        //     null,
        //     typePayment,
        //     _itensValue,
        //     _freightValue,
        //     _totalValue,
        //     "");
      } else {
        // addOrder(
        //     _idCart.toString(),
        //     ApplicationConstant.TYPE_DELIVERY_2.toString(),
        //     null,
        //     _idSchedule,
        //     dateController.text.toString(),
        //     typePayment,
        //     _itensValue,
        //     _freightValue,
        //     _totalValue,
        //     "");
      }
    }
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

      setState(() {

        _profileResponse = response;

      });

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

      final json =
          await postRequest.sendPostRequest(Links.FIND_WITHDRAWAL_TIME, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Order.fromJson(_map[0]);

      setState(() {
        if (response.status != "02") {
          _idSchedule = response.id.toString();
          _hasSchedule = true;
          _schedule =
              "De: " + response.horario_in + " Até: " + response.horario_out;
        } else {
          _hasSchedule = false;
          ApplicationMessages(context: context).showMessage(response.msg);
        }
      });
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> findWithdrawal() async {
    try {
      final body = {
        "id_endereco": _idAddress,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.FIND_WITHDRAWAL, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Order.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  // Future<void> addOrder(
  //     String idCart,
  //     String typeDelivery, // 1 tipo entrega no endereco e 2 retirada eu acho
  //     String? idAddress, // quando for tipo entrega 1
  //     String? scheduleWithdrawalId, // quando for tipo retirada 2
  //     String? dateWithdrawal, // quando for tipo retirada 2
  //     String typePayment,
  //     String cartValue,
  //     String freightValue,
  //     String totalValue,
  //     String obs) async {
  //   try {
  //     final body = {
  //       "id_user": await Preferences.getUserData()!.id,
  //       "id_carrinho": idCart,
  //       "tipo_entrega": typeDelivery,
  //       "id_endereco": idAddress,
  //       "hora_retirada_id": scheduleWithdrawalId,
  //       "metodo_pagamento": typePayment,
  //       "data_retirada": dateWithdrawal,
  //       "valor": cartValue,
  //       "valor_frete": freightValue,
  //       "valor_total": totalValue,
  //       "obs": obs,
  //       "token": ApplicationConstant.TOKEN
  //     };
  //
  //     print('HTTP_BODY: $body');
  //
  //     final json = await postRequest.sendPostRequest(Links.ADD_ORDER, body);
  //
  //     List<Map<String, dynamic>> _map = [];
  //     _map = List<Map<String, dynamic>>.from(jsonDecode(json));
  //
  //     print('HTTP_RESPONSE: $_map');
  //
  //     final response = Cart.fromJson(_map[0]);
  //
  //     if (response.status == "01") {
  //       Navigator.pushNamed(context, "/ui/checkout", arguments: {
  //         "id_cart": _idCart,
  //         "total_value": _totalValue,
  //         "id_order": response.id.toString(),
  //         "type_payment": typePayment,
  //         "cep": _addressResponse?.cep.toString(),
  //         "estado": _addressResponse?.estado.toString(),
  //         "cidade":_addressResponse?.cidade.toString(),
  //         "endereco": _addressResponse?.endereco.toString(),
  //         "bairro": _addressResponse?.bairro.toString(),
  //         "numero": _addressResponse?.numero.toString(),
  //         "complemento": _addressResponse?.complemento.toString(),
  //         "total_items": cartValue,
  //         "freight_value": freightValue,
  //       });
  //     } else {
  //
  //       ApplicationMessages(context: context).showMessage(response.msg);
  //     }
  //   } catch (e) {
  //     throw Exception('HTTP_ERROR: $e');
  //   }
  // }

  Future<Map<String, dynamic>> calculeFreightValue() async {
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

      return parsedResponse;
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

      final response = User.fromJson(_map[0]);

      // setState(() {

        _addressResponse = response;

      // });

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
                // Container(
                //     child: Text(
                //   "Retirada no local",
                //   style: TextStyle(
                //     fontFamily: 'Inter',
                //     fontSize: Dimens.textSize6,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ))
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
            child: AutoScaleTabBarView(controller: _tabController, children: <
                Widget>[
              Container(
                  height: 220,
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: findAddress(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final response =
                                    User.fromJson(snapshot.data![0]);

                                if (response.rows != 0) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimens.minRadiusApplication),
                                    ),
                                    margin: EdgeInsets.all(
                                        Dimens.minMarginApplication),
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                                  context, "/ui/user_addresses")
                                              .then((_) => setState(() {
                                                    _idAddress = Preferences
                                                            .getDefaultAddress()
                                                        .toString();
                                                  }));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              Dimens.paddingApplication),
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
                                                        fontSize:
                                                            Dimens.textSize5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: Dimens
                                                            .minMarginApplication),
                                                    Expanded(
                                                        child: Text(
                                                      response
                                                          .endereco_completo,
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize:
                                                            Dimens.textSize5,
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
                                                        fontSize:
                                                            Dimens.textSize4,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                } else {
                                    return Center(child: GestureDetector(onTap: () {
                                      Navigator.pushNamed(
                                          context, "/ui/user_addresses")
                                          .then((_) => setState(() {
                                        _idAddress = Preferences
                                            .getDefaultAddress()
                                            .toString();
                                      }));
                                    },child: Text(
                                        "Selecionar endereço",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize:
                                          Dimens.textSize6,
                                          fontWeight:
                                          FontWeight.bold,
                                          color: OwnerColors
                                              .colorPrimaryDark,
                                        ),)));
                                }
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                              return Center(child: CircularProgressIndicator());
                            }),
                      ),
                      Visibility(visible: _idAddress != "null", child:
                      FutureBuilder<Map<String, dynamic>>(
                          future: calculeFreightValue(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final response = Freight.fromJson(snapshot.data!);

                              return Card(
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
                                            response.valor_frete.toString(),
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: Dimens.textSize6,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                                  ));
                            }

                            return Center();
                          })),
                    ],
                  )),
              // Container(
              //   height: /*_hasSchedule ? */ 360 /*: 236*/,
              //   child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Container(
              //           height: 150,
              //           child: FutureBuilder<List<Map<String, dynamic>>>(
              //               future: findAddress(),
              //               builder: (context, snapshot) {
              //                 if (snapshot.hasData) {
              //                   final response =
              //                       User.fromJson(snapshot.data![0]);
              //
              //                   if (response.rows != 0) {
              //                     return Card(
              //                       shape: RoundedRectangleBorder(
              //                         borderRadius: BorderRadius.circular(
              //                             Dimens.minRadiusApplication),
              //                       ),
              //                       margin: EdgeInsets.all(
              //                           Dimens.minMarginApplication),
              //                       child: InkWell(
              //                           onTap: () {
              //                             Navigator.pushNamed(
              //                                 context, "/ui/user_addresses");
              //                           },
              //                           child: Container(
              //                             padding: EdgeInsets.all(
              //                                 Dimens.paddingApplication),
              //                             child: Row(
              //                               children: [
              //                                 Expanded(
              //                                   child: Column(
              //                                     crossAxisAlignment:
              //                                         CrossAxisAlignment.start,
              //                                     children: [
              //                                       Text(
              //                                         response.nome,
              //                                         style: TextStyle(
              //                                           fontFamily: 'Inter',
              //                                           fontSize:
              //                                               Dimens.textSize5,
              //                                           fontWeight:
              //                                               FontWeight.bold,
              //                                           color: Colors.black,
              //                                         ),
              //                                       ),
              //                                       SizedBox(
              //                                           height: Dimens
              //                                               .minMarginApplication),
              //                                       Expanded(
              //                                           child: Text(
              //                                         response
              //                                             .endereco_completo,
              //                                         style: TextStyle(
              //                                           fontFamily: 'Inter',
              //                                           fontSize:
              //                                               Dimens.textSize5,
              //                                           color: Colors.black,
              //                                         ),
              //                                       )),
              //                                       SizedBox(
              //                                           height: Dimens
              //                                               .minMarginApplication),
              //                                       Styles().div_horizontal,
              //                                       SizedBox(
              //                                           height: Dimens
              //                                               .minMarginApplication),
              //                                       Text(
              //                                         "Alterar endereço",
              //                                         style: TextStyle(
              //                                           fontFamily: 'Inter',
              //                                           fontSize:
              //                                               Dimens.textSize4,
              //                                           fontWeight:
              //                                               FontWeight.bold,
              //                                           color: OwnerColors
              //                                               .colorPrimaryDark,
              //                                         ),
              //                                       ),
              //                                     ],
              //                                   ),
              //                                 )
              //                               ],
              //                             ),
              //                           )),
              //                     );
              //                   }
              //                 } else if (snapshot.hasError) {
              //                   return Text('${snapshot.error}');
              //                 }
              //                 return Center(child: CircularProgressIndicator());
              //               }),
              //         ),
              //         FutureBuilder<Map<String, dynamic>>(
              //             future: findWithdrawal(),
              //             builder: (context, snapshot) {
              //               if (snapshot.hasData) {
              //                 final response = Order.fromJson(snapshot.data!);
              //
              //                 return Container(
              //                     padding: EdgeInsets.all(
              //                         Dimens.minPaddingApplication),
              //                     child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       children: [
              //                         // Text(
              //                         //   "Escolha a data",
              //                         //   style: TextStyle(
              //                         //     fontFamily: 'Inter',
              //                         //     fontSize: Dimens.textSize6,
              //                         //     fontWeight: FontWeight.w300,
              //                         //     color: Colors.black,
              //                         //   ),
              //                         // ),
              //                         // SizedBox(height: Dimens.marginApplication),
              //                         Container(
              //                           width: double.infinity,
              //                           child: ElevatedButton(
              //                               style: Styles().styleDefaultButton,
              //                               onPressed: () {
              //                                 showModalBottomSheet<dynamic>(
              //                                     isScrollControlled: true,
              //                                     context: context,
              //                                     shape: Styles()
              //                                         .styleShapeBottomSheet,
              //                                     clipBehavior: Clip
              //                                         .antiAliasWithSaveLayer,
              //                                     builder:
              //                                         (BuildContext context) {
              //                                       return DatePickerAlertDialog(
              //                                           dateController:
              //                                               dateController,
              //                                           btnConfirm: Container(
              //                                               margin: EdgeInsets.only(
              //                                                   top: Dimens
              //                                                       .marginApplication),
              //                                               width:
              //                                                   double.infinity,
              //                                               child:
              //                                                   ElevatedButton(
              //                                                       style: Styles()
              //                                                           .styleDefaultButton,
              //                                                       onPressed:
              //                                                           () {
              //                                                         findWithdrawalTime(
              //                                                             response
              //                                                                 .id_ponto
              //                                                                 .toString(),
              //                                                             dateController
              //                                                                 .text);
              //
              //                                                         Navigator.of(
              //                                                                 context)
              //                                                             .pop();
              //                                                       },
              //                                                       child: Text(
              //                                                           "Selecionar",
              //                                                           style: Styles()
              //                                                               .styleDefaultTextButton))));
              //                                     });
              //                               },
              //                               child: Text(
              //                                 "Escolher data para retirar",
              //                                 style: Styles()
              //                                     .styleDefaultTextButton,
              //                               )),
              //                         ),
              //
              //                         SizedBox(
              //                             height: Dimens.minMarginApplication),
              //                         Visibility(
              //                             visible: _hasSchedule,
              //                             child: Card(
              //                                 shape: RoundedRectangleBorder(
              //                                   borderRadius:
              //                                       BorderRadius.circular(Dimens
              //                                           .minRadiusApplication),
              //                                 ),
              //                                 child: Container(
              //                                   width: double.infinity,
              //                                   padding: EdgeInsets.all(
              //                                       Dimens.paddingApplication),
              //                                   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //                                     Text(
              //                                         "Horários para retirada nesta data",
              //                                         style: TextStyle(
              //                                           fontFamily: 'Inter',
              //                                           fontSize:
              //                                               Dimens.textSize5,
              //                                           color: Colors.black,
              //                                         ),
              //                                       ),
              //
              //                                     SizedBox(
              //                                         height: Dimens.minMarginApplication),
              //                                     Text(
              //                                       _schedule + "\n\nLocal:\n" + response.nome_ponto,
              //                                       style: TextStyle(
              //                                         fontFamily: 'Inter',
              //                                         fontSize:
              //                                             Dimens.textSize4,
              //                                         color: Colors.black,
              //                                       ),
              //                                     ),
              //                                   ]),
              //                                 )))
              //                       ],
              //                     ));
              //               } else if (snapshot.hasError) {
              //                 return Text('${snapshot.error}');
              //               }
              //               return Center(child: CircularProgressIndicator());
              //             })
              //       ]),
              // )
            ]),
          ),
          SizedBox(height: Dimens.minMarginApplication),
          Styles().div_horizontal,
          SizedBox(height: Dimens.minMarginApplication),
          InkWell(
              onTap: () {
                goToCheckout(ApplicationConstant.PIX.toString());
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
                                    height: 50, width: 50, color: Colors.black54,))),
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
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black38,
                          size: 20,
                        ),
                      ],
                    ),
                  ))),
          InkWell(
              onTap: () {

                goToCheckout(ApplicationConstant.CREDIT_CARD.toString());

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
                                child: Image.asset('images/credit_card.png',
                                    height: 50, width: 50, color: Colors.black54))),
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
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black38,
                          size: 20,
                        ),
                      ],
                    ),
                  ))),
          InkWell(
              onTap: () {

                goToCheckout(ApplicationConstant.TICKET.toString());
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
                                child: Image.asset('images/ticket.png',
                                    height: 50, width: 50, color: Colors.black54))),
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
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black38,
                          size: 20,
                        ),
                      ],
                    ),
                  ))),

          Visibility(visible: _profileResponse?.saldo_aprovado == 1, child:
          InkWell(
              onTap: () {

                goToCheckout(ApplicationConstant.TICKET_IN_TERM.toString());

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
                                child: Image.asset('images/calendar.png',
                                    height: 50, width: 50, color: Colors.black54))),
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
                              "Parcele o valor total da compra.",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize4,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        )),
                         Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black38,
                            size: 20,
                          ),

                      ],
                    ),
                  ))))
        ]))));
  }
}
