import 'dart:convert';

import 'package:app/config/application_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../../../../global/application_constant.dart';
import '../../../../model/cart.dart';
import '../../../../model/item.dart';
import '../../../../res/dimens.dart';
import '../../../../res/owner_colors.dart';
import '../../../../res/strings.dart';
import '../../../../res/styles.dart';
import '../../../../web_service/links.dart';
import '../../../../web_service/service_response.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/progress_hud.dart';
import '../home.dart';

class Success extends StatefulWidget {
  const Success({Key? key}) : super(key: key);

  @override
  State<Success> createState() => _Success();
}

class _Success extends State<Success> {
  bool _isLoading = false;
  late int _idCart;
  late int _idOrder;
  late String _base64;
  late String _qrCodeClipboard;
  late String _typePaymentName;

  final postRequest = PostRequest();

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

  @override
  Widget build(BuildContext context) {
    Map data = {};
    data = ModalRoute.of(context)!.settings.arguments as Map;

    _idOrder = data['id_order'];
    _idCart = data['id_cart'];
    _base64 = data['base64'];
    _qrCodeClipboard = data['qrCodeClipboard'];

    _typePaymentName = data['payment_type'];

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: "Compra finalizada!",
          // isVisibleBackButton: true,
        ),
        body: Stack(children: [
          SingleChildScrollView(
              child: Container(
            margin: EdgeInsets.all(Dimens.marginApplication),
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Lottie.network(
                        height: 140,
                        'https://assets1.lottiefiles.com/packages/lf20_o3kwwgtn.json')),
                SizedBox(height: Dimens.marginApplication),
                Text(
                  "Detalhes do pedido #$_idOrder",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: Dimens.textSize6,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: Dimens.minMarginApplication),

                Styles().div_horizontal,
                SizedBox(height: Dimens.minMarginApplication),
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
                  future: listCartItems(_idCart.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.itens.length,
                        itemBuilder: (context, index) {
                          final response =
                              Item.fromJson(snapshot.data!.itens[index]);

                          return InkWell(
                              onTap: () => {},
                              child: Card(
                                elevation: 0,
                                color: OwnerColors.categoryLightGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimens.minRadiusApplication),
                                ),
                                margin:
                                    EdgeInsets.all(Dimens.minMarginApplication),
                                child: Container(
                                  padding:
                                      EdgeInsets.all(Dimens.paddingApplication),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(
                                              right:
                                                  Dimens.minMarginApplication),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(Dimens
                                                      .minRadiusApplication),
                                              child: Image.network(
                                                ApplicationConstant
                                                        .URL_PRODUCT_PHOTO +
                                                    response.url_foto
                                                        .toString(),
                                                height: 90,
                                                width: 90,
                                                errorBuilder: (context,
                                                        exception,
                                                        stackTrack) =>
                                                    Icon(Icons.error, size: 90),
                                              ))),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              response.nome_produto,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: Dimens.textSize6,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                                height: Dimens
                                                    .minMarginApplication),
                                            Text(
                                              "Quantidade: " +
                                                  response.qtd.toString(),
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: Dimens.textSize4,
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
                                                fontSize: Dimens.textSize6,
                                                color: OwnerColors.darkGreen,
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
                    return Center(child: CircularProgressIndicator());
                  },
                ),
                SizedBox(height: Dimens.minMarginApplication),

                Styles().div_horizontal,
                SizedBox(height: Dimens.minMarginApplication),
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
                Visibility(
                    visible: _typePaymentName == "PIX",
                    child: Column(
                      children: [
                        Text(
                          "Tipo de pagamento: $_typePaymentName" +
                              "\n\n" +
                              "Copie este código para pagar" +
                              "\n\n" +
                              "1. Acesse seu Internet Banking ou app de pagamentos." +
                              "\n\n" +
                              "2. Escolha pagar via Pix/QR Code" +
                              "\n\n" +
                              "3. Escaneie o seguinte código:",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: Dimens.textSize5,
                            color: Colors.black,
                          ),
                        ),
                        Image.memory(
                            Base64Decoder().convert(_base64.toString()))
                      ],
                    ))
              ],
            ),
          )),
          Visibility(
              visible: _typePaymentName == "PIX",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.all(Dimens.minMarginApplication),
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(
                                new ClipboardData(text: _qrCodeClipboard));
                            ApplicationMessages(context: context)
                                .showMessage("Link Copiado!");
                          },
                          style: Styles().styleAlternativeButton,
                          child: Container(
                              child: Text("Copiar chave",
                                  textAlign: TextAlign.center,
                                  style: Styles().styleDefaultTextButton)))),
                  Container(
                      margin: EdgeInsets.all(Dimens.minMarginApplication),
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                                ModalRoute.withName("/ui/home"));
                          },
                          style: Styles().styleDefaultButton,
                          child: Container(
                              child: Text("Ok",
                                  textAlign: TextAlign.center,
                                  style: Styles().styleDefaultTextButton))))
                ],
              ))
        ]));
  }
}
