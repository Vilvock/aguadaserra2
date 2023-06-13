import 'dart:convert';

import 'package:app/model/cart.dart';
import 'package:app/model/payment.dart';
import 'package:app/res/styles.dart';
import 'package:app/ui/components/alert_dialog_credit_card_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../config/application_messages.dart';
import '../../../../config/preferences.dart';
import '../../../../global/application_constant.dart';
import '../../../../model/item.dart';
import '../../../../model/user.dart';
import '../../../../res/dimens.dart';
import '../../../../res/owner_colors.dart';
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
  bool _isLoadingDialog = false;

  late int _idCart;
  late String _totalValue;
  late String _typePayment;

  late String _idAddress;
  late String _cep;
  late String _city;
  late String _state;
  late String _nbh;
  late String _address;
  late String _number;
  late String _complement;

  late String _cartValue;
  late String _freightValue;

  final postRequest = PostRequest();

  var _typePaymentName;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController securityCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    cpfController.dispose();
    yearController.dispose();
    monthController.dispose();
    cardNumberController.dispose();
    securityCodeController.dispose();
    super.dispose();
  }

  Future<void> createTokenCreditCard(
      String idOrder,
      String cardNumber,
      String expirationMonth,
      String expirationYear,
      String securityCode,
      String name,
      String document) async {
    try {
      final body = {
        "card_number": cardNumber,
        "expiration_month": expirationMonth,
        "expiration_year": expirationYear,
        "security_code": securityCode,
        "nome": name,
        "cpf": document,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.CREATE_TOKEN_CARD, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Payment.fromJson(parsedResponse);

      if (response.status == 400) {
        ApplicationMessages(context: context)
            .showMessage("Não foi possível autenticar este cartão!");
      } else {
        payWithCreditCard(idOrder, _totalValue, response.id);
      }

      // setState(() {});
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
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

  Future<void> payWithCreditCard(
      String idOrder, String totalValue, String idCreditCard) async {
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

      final response = Payment.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {
          Navigator.pushNamedAndRemoveUntil(
              context, "/ui/success", (route) => false,
              arguments: {
                "id_cart": _idCart,
                "payment_type": _typePaymentName,
                "id_order": idOrder,
                "cep": _cep.toString(),
                "estado": _state.toString(),
                "cidade": _city.toString(),
                "endereco": _address.toString(),
                "bairro": _nbh.toString(),
                "numero": _number.toString(),
                "complemento": _complement.toString(),
                "total_items": _cartValue,
                "freight_value": _freightValue,
                "total_value": _totalValue,
              });
        });
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> payWithTicketWithOutAddress(
      String idOrder, String totalValue) async {
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

      final response = Payment.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {
          Navigator.pushNamedAndRemoveUntil(
              context, "/ui/success", (route) => false,
              arguments: {
                "id_cart": _idCart,
                "payment_type": _typePaymentName,
                "id_order": idOrder,
                "cep": _cep.toString(),
                "estado": _state.toString(),
                "cidade": _city.toString(),
                "endereco": _address.toString(),
                "bairro": _nbh.toString(),
                "numero": _number.toString(),
                "complemento": _complement.toString(),
                "total_items": _cartValue,
                "freight_value": _freightValue,
                "total_value": _totalValue,
              });
        });
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> payWithTicket(
      String idOrder,
      String totalValue,
      String cep,
      String state,
      String city,
      String address,
      String nbh,
      String number) async {
    try {
      final body = {
        "id_pedido": idOrder,
        "id_usuario": await Preferences.getUserData()!.id,
        "tipo_pagamento": ApplicationConstant.TICKET,
        "valor": totalValue,
        "cep": cep,
        "estado": state,
        "cidade": city,
        "endereco": address,
        "bairro": nbh,
        "numero": number,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.ADD_PAYMENT, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Payment.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {
          Navigator.pushNamedAndRemoveUntil(
              context, "/ui/success", (route) => false,
              arguments: {
                "id_cart": _idCart,
                "payment_type": _typePaymentName,
                "id_order": idOrder,
                "barCode": response.cod_barras,
                "cep": _cep.toString(),
                "estado": _state.toString(),
                "cidade": _city.toString(),
                "endereco": _address.toString(),
                "bairro": _nbh.toString(),
                "numero": _number.toString(),
                "complemento": _complement.toString(),
                "total_items": _cartValue,
                "freight_value": _freightValue,
                "total_value": _totalValue,
              });
        });
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
        Navigator.pushNamedAndRemoveUntil(
            context, "/ui/success", (route) => false,
            arguments: {
              "id_cart": _idCart,
              "base64": response.qrcode_64,
              "qrCodeClipboard": response.qrcode,
              "payment_type": _typePaymentName,
              "id_order": idOrder,
              "cep": _cep.toString(),
              "estado": _state.toString(),
              "cidade": _city.toString(),
              "endereco": _address.toString(),
              "bairro": _nbh.toString(),
              "numero": _number.toString(),
              "complemento": _complement.toString(),
              "total_items": _cartValue,
              "freight_value": _freightValue,
              "total_value": _totalValue,
            });
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
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
        var _idOrder = response.id.toString();

        if (_typePayment == ApplicationConstant.PIX.toString()) {
          await payWithPIX(_idOrder.toString(), _totalValue);
        } else if (_typePayment == ApplicationConstant.CREDIT_CARD.toString()) {

          var _formattedCardNumber = cardNumberController.text.replaceAll(
              new RegExp(r'[^0-9]'),
              '');

          await createTokenCreditCard(
              _idOrder.toString(),
              _formattedCardNumber.toString(),
              monthController.text.toString(),
              yearController.text.toString(),
              securityCodeController.text.toString(),
              nameController.text.toString(),
              cpfController.text.toString());

        } else if (_typePayment == ApplicationConstant.TICKET.toString()) {
          await payWithTicket(_idOrder.toString(),
              _totalValue,
              _cep,
              _state,
              _city,
              _address,
              _nbh,
              _number);
        } else {
          await payWithTicketWithOutAddress(_idOrder.toString(), _totalValue);
        }

      } else {
        ApplicationMessages(context: context).showMessage(response.msg);
      }
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
    // _idOrder = data['id_order'];
    _typePayment = data['type_payment'];

    _idAddress = data['id_address'];
    _cep = data['cep'];
    _city = data['cidade'];
    _state = data['estado'];
    _nbh = data['bairro'];
    _address = data['endereco'];
    _number = data['numero'];
    _complement = data['complemento'];

    _cartValue = data['total_items'];
    _freightValue = data['freight_value'];

    switch (_typePayment) {
      case "1":
        _typePaymentName = "Cartão de crédito";
        break;
      case "2":
        _typePaymentName = "Boleto bancário";
        break;
      case "3":
        _typePaymentName = "PIX";
        break;
      case "4":
        _typePaymentName = "Boleto à prazo";
        break;
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: "Revisão do pedido",
          isVisibleBackButton: true,
        ),
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
                            // Text(
                            //   "Resumo",
                            //   style: TextStyle(
                            //     fontFamily: 'Inter',
                            //     fontSize: Dimens.textSize6,
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.black,
                            //   ),
                            // ),
                            // SizedBox(height: Dimens.minMarginApplication),
                            Text(
                              "Endereço para entrega:",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: Dimens.minMarginApplication),
                            Text(
                              "$_city - $_state" +
                                  "\n" +
                                  "$_nbh, $_address $_number" +
                                  "\n\n" +
                                  "$_complement",
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
                              "Produtos:",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            FutureBuilder<Cart>(
                              future: listCartItems(_idCart.toString()),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.itens.length,
                                    itemBuilder: (context, index) {
                                      final response = Item.fromJson(
                                          snapshot.data!.itens[index]);

                                      return InkWell(
                                          onTap: () => {},
                                          child: Card(
                                            elevation: 0,
                                            color:
                                                OwnerColors.categoryLightGrey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(Dimens
                                                      .minRadiusApplication),
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
                                                            ApplicationConstant
                                                                    .URL_PRODUCT_PHOTO +
                                                                response
                                                                    .url_foto
                                                                    .toString(),
                                                            height: 90,
                                                            width: 90,
                                                            errorBuilder: (context,
                                                                    exception,
                                                                    stackTrack) =>
                                                                Icon(
                                                                    Icons.error,
                                                                    size: 90),
                                                          ))),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          response.nome_produto,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontSize: Dimens
                                                                .textSize5,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: Dimens
                                                                .minMarginApplication),
                                                        Text(
                                                          "Quantidade: " +
                                                              response.qtd
                                                                  .toString(),
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontSize: Dimens
                                                                .textSize4,
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
                                                            fontSize: Dimens
                                                                .textSize6,
                                                            color: OwnerColors
                                                                .darkGreen,
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
                                return Center(
                                    child: CircularProgressIndicator());
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
                              "Tipo de pagamento: $_typePaymentName",
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
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                Dimens.minRadiusApplication),
                          ),
                          child: Container(
                              padding:
                                  EdgeInsets.all(Dimens.paddingApplication),
                              child: Column(children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Frete",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize5,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _freightValue,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: Dimens.textSize5,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Dimens.minMarginApplication),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Valor total em produtos",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize5,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _cartValue,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: Dimens.textSize5,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Dimens.minMarginApplication),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Valor total com a entrega",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize6,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _totalValue,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize6,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Dimens.marginApplication),
                                Container(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: Styles().styleDefaultButton,
                                      onPressed: _isLoading
                                          ? null
                                          : () async {
                                              setState(() {
                                                _isLoading = true;
                                              });

                                              if (_typePayment ==
                                                  ApplicationConstant
                                                      .CREDIT_CARD
                                                      .toString()) {
                                                /*final result = */ await showModalBottomSheet<
                                                        dynamic>(
                                                    isScrollControlled: true,
                                                    context: context,
                                                    shape: Styles()
                                                        .styleShapeBottomSheet,
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CreditCardAlertDialog(
                                                        cardNumberController:
                                                            cardNumberController,
                                                        cpfController:
                                                            cpfController,
                                                        monthController:
                                                            monthController,
                                                        nameController:
                                                            nameController,
                                                        securityCodeController:
                                                            securityCodeController,
                                                        yearController:
                                                            yearController,
                                                        btnConfirm: Container(
                                                          margin: EdgeInsets.only(
                                                              top: Dimens
                                                                  .marginApplication),
                                                          width:
                                                              double.infinity,
                                                          child: ElevatedButton(
                                                            style: Styles()
                                                                .styleDefaultButton,
                                                            onPressed:
                                                                _isLoadingDialog
                                                                    ? null
                                                                    : () async {
                                                                        setState(
                                                                            () {
                                                                          _isLoadingDialog =
                                                                              true;
                                                                        });

                                                                        await addOrder(
                                                                            _idCart.toString(),
                                                                            ApplicationConstant
                                                                                .TYPE_DELIVERY_1
                                                                                .toString(),
                                                                            _idAddress.toString(),
                                                                            null,
                                                                            null,
                                                                            _typePayment,
                                                                            _cartValue,
                                                                            _freightValue,
                                                                            _totalValue,
                                                                            "");

                                                                        setState(
                                                                            () {
                                                                          _isLoadingDialog =
                                                                              false;
                                                                        });

                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                            child:
                                                                (_isLoadingDialog)
                                                                    ? const SizedBox(
                                                                        width: Dimens
                                                                            .buttonIndicatorWidth,
                                                                        height: Dimens
                                                                            .buttonIndicatorHeight,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color:
                                                                              OwnerColors.colorAccent,
                                                                          strokeWidth:
                                                                              Dimens.buttonIndicatorStrokes,
                                                                        ))
                                                                    : Text(
                                                                        "Realizar pedido",
                                                                        style: Styles()
                                                                            .styleDefaultTextButton),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                                // if(result == true){
                                                //   Navigator.popUntil(
                                                //     context,
                                                //     ModalRoute.withName('/ui/home'),
                                                //   );
                                                //   Navigator.pushNamed(context, "/ui/user_addresses");
                                                // }
                                                //
                                                // await payWithCreditCard(
                                                //     _idOrder.toString(),
                                                //     _totalValue,
                                                //     "");
                                              } else {
                                                await addOrder(
                                                    _idCart.toString(),
                                                    ApplicationConstant
                                                        .TYPE_DELIVERY_1
                                                        .toString(),
                                                    _idAddress.toString(),
                                                    null,
                                                    null,
                                                    typePayment,
                                                    _itensValue,
                                                    _freightValue,
                                                    _totalValue,
                                                    "");
                                              }

                                              setState(() {
                                                _isLoading = false;
                                              });
                                            },
                                      child: (_isLoading)
                                          ? const SizedBox(
                                              width:
                                                  Dimens.buttonIndicatorWidth,
                                              height:
                                                  Dimens.buttonIndicatorHeight,
                                              child: CircularProgressIndicator(
                                                color: OwnerColors.colorAccent,
                                                strokeWidth: Dimens
                                                    .buttonIndicatorStrokes,
                                              ))
                                          : Text(
                                              _typePaymentName ==
                                                      "Cartão de crédito"
                                                  ? "Inserir dados do cartão"
                                                  : "Realizar pedido",
                                              style: Styles()
                                                  .styleDefaultTextButton),
                                    )),
                              ]))),
                    )
                  ])
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
