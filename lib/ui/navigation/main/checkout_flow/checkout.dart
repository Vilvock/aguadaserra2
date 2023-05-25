import 'dart:convert';

import 'package:app/model/cart.dart';
import 'package:app/model/payment.dart';
import 'package:app/res/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../config/application_messages.dart';
import '../../../../config/preferences.dart';
import '../../../../global/application_constant.dart';
import '../../../../model/item.dart';
import '../../../../model/user.dart';
import '../../../../res/dimens.dart';
import '../../../../res/strings.dart';
import '../../../../web_service/links.dart';
import '../../../../web_service/service_response.dart';
import '../../../components/custom_app_bar.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _Checkout();
}

class _Checkout extends State<Checkout> {
  bool _isLoading = false;

  late int _idCart;
  late String _totalValue;

  final postRequest = PostRequest();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Cart> listCartItems(String idCart) async {
    try {
      final body = {"id_carrinho": idCart, "token": ApplicationConstant.TOKEN};

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_CART_ITEMS, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Cart.fromJson(parsedResponse);

      // setState(() {});

      return response;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> payWithCreditCard(String idOrder, String totalValue,
      String idCreditCard) async {
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

      final json = await postRequest.sendPostRequest(Links.ADD_PAYMENT, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {});
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> payWithTicketWithOutAddress(String idOrder,
      String totalValue) async {
    try {
      final body = {
        "id_pedido": idOrder,
        "id_usuario": await Preferences.getUserData()!.id,
        "tipo_pagamento": ApplicationConstant.TICKET_IN_TERM,
        "valor": totalValue,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.ADD_PAYMENT, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {});
      } else {}
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
        "valor": totalValue,
        "cep": "90690-040",
        "estado": "RS",
        "cidade": "Porto Alegre",
        "endereco": "Rua Antonio carlos tibiricça",
        "bairro": "Petroópolis",
        "numero": "7464",
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.ADD_PAYMENT, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {});
      } else {}
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

      final json = await postRequest.sendPostRequest(Links.ADD_PAYMENT, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Payment.fromJson(_map[0]);

      if (response.status == "01") {
        Navigator.pushNamed(context,
          "/ui/success",
          arguments: {
            "id_cart": _idCart,
          });
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = {};
    data = ModalRoute.of(context)!.settings.arguments as Map;

    _idCart = data['id_cart'];
    _totalValue = data['total_value'];

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: "Revisão do pedido",
          isVisibleBackButton: true,),
        body: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: /*FutureBuilder<List<Map<String, dynamic>>>(
              future: loadProduct(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  final response = Product.fromJson(snapshot.data![0]);

                  return */
            Stack(children: [
              SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 100),
                    child: Column(
                      children: [

                        Container(
                            margin: EdgeInsets.all(Dimens.marginApplication),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Resumo",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize6,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: Dimens.minMarginApplication),
                                Text(
                                  "Endereço:",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: Dimens.minMarginApplication),
                                Text(
                                      "Cidade - estado" +
                                      "\n" +
                                      "Endereço e numero 000" +
                                      "\n\n" +
                                      "Complemento: lorem ipsum" ,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize5,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: Dimens.marginApplication),
                                Styles().div_horizontal,
                                SizedBox(height: Dimens.marginApplication),
                                Text(
                                  "Itens:",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                FutureBuilder<Cart>(
                                  future:
                                  listCartItems(_idCart.toString()),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                        primary: false,
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.itens.length,
                                        itemBuilder: (context, index) {

                                          final response = Item.fromJson(snapshot.data!.itens[index]);

                                          return InkWell(
                                              onTap: () => {
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(
                                                      Dimens.minRadiusApplication),
                                                ),
                                                margin: EdgeInsets.all(
                                                    Dimens.minMarginApplication),
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      Dimens.paddingApplication),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          margin: EdgeInsets.only(
                                                              right: Dimens
                                                                  .minMarginApplication),
                                                          child: ClipRRect(
                                                              borderRadius: BorderRadius
                                                                  .circular(Dimens
                                                                  .minRadiusApplication),
                                                              child: Image.network(
                                                                ApplicationConstant.URL_PRODUCT_PHOTO + response.url_foto.toString(),
                                                                height: 90,
                                                                width: 90,
                                                                errorBuilder: (context, exception, stackTrack) => Icon(Icons.error, size: 90),
                                                              ))),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              response.nome_produto,
                                                              maxLines: 1,
                                                              overflow:
                                                              TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontFamily: 'Inter',
                                                                fontSize:
                                                                Dimens.textSize6,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: Dimens
                                                                    .minMarginApplication),
                                                            Text(
                                                              response.valor,
                                                              style: TextStyle(
                                                                fontFamily: 'Inter',
                                                                fontSize:
                                                                Dimens.textSize6,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('${snapshot.error}');
                                    }
                                    return Center( child: CircularProgressIndicator());
                                  },
                                ),

                                SizedBox(height: Dimens.marginApplication),
                                Styles().div_horizontal,
                                SizedBox(height: Dimens.marginApplication),
                                Text(
                                  "Pagamento",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: Dimens.minMarginApplication),
                                Text(
                                  "Tipo de pagamento: PIX",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.all(Dimens.minMarginApplication),
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            payWithPIX(_idCart.toString(), _totalValue);
                          },
                          style: Styles().styleDefaultButton,
                          child: Container(child:
                          Text(
                              "Fazer pedido",
                              textAlign: TextAlign.center,
                              style: Styles().styleDefaultTextButton
                          ))

                      ))
                ],
              )
            ])));
    /*     } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center( child: CircularProgressIndicator());
              },
            )));*/
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;

      _isLoading = false;
    });
  }
}
