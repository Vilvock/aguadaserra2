import 'dart:convert';

import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:app/model/favorite.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../../../config/application_messages.dart';
import '../../../../config/preferences.dart';
import '../../../../global/application_constant.dart';
import '../../../../model/cart.dart';
import '../../../../model/item.dart';
import '../../../../model/order.dart';
import '../../../../model/product.dart';
import '../../../../model/user.dart';
import '../../../../res/dimens.dart';
import '../../../../res/owner_colors.dart';
import '../../../../res/strings.dart';
import '../../../../res/styles.dart';
import '../../../../web_service/links.dart';
import '../../../../web_service/service_response.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/dot_indicator.dart';
import '../../../components/progress_hud.dart';
import '../home.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key}) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetail();
}

class _OrderDetail extends State<OrderDetail> {
  bool _isLoading = false;

  late int _id;

  String _base64 = "";
  String _qrCodeClipboard = "";
  final postRequest = PostRequest();

  Future<Map<String, dynamic>> findOrder(String idOrder) async {
    try {
      final body = {"id": idOrder, "token": ApplicationConstant.TOKEN};

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.FIND_ORDER, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      // final response = Order.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map data = {};
    data = ModalRoute
        .of(context)!
        .settings
        .arguments as Map;

    // _base64 = data['base64'];
    // _qrCodeClipboard = data['qrCodeClipboard'];
    _id = data['id'];

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: "Detalhes do pedido #$_id",
          isVisibleBackButton: true,
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: findOrder(_id.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final response = Order.fromJson(snapshot.data!);

              final responseAddress = User.fromJson(Order.fromJson(snapshot.data!).endereco[0]);

              return Stack(children: [
                SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(Dimens.marginApplication),
                      padding: EdgeInsets.only(bottom: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            responseAddress.cidade.toString() + " - " + responseAddress.estado.toString() +
                                "\n" +
                                responseAddress.bairro.toString() + ", " + responseAddress.endereco.toString() + " " + responseAddress.numero.toString()+
                                "\n\n" +
                                responseAddress.complemento.toString(),
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
                          ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: response.itens_carrinho.length,
                            itemBuilder: (context, index) {
                              final response =
                              Item.fromJson(Order.fromJson(snapshot.data!).itens_carrinho[index]);

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
                                                        Icon(Icons.error,
                                                            size: 90),
                                                  ))),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  response.nome_produto,
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis,
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
                          Visibility(
                              visible: response.tipo_pagamento ==
                                  "Cartão Online",
                              child: Column(
                                children: [
                                  Text(
                                    "Tipo de pagamento: " +
                                        response.tipo_pagamento,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: Dimens.textSize5,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )),
                          Visibility(
                              visible: response.tipo_pagamento ==
                                  "Boleto",
                              child: Column(
                                children: [
                                  Text(
                                    "Tipo de pagamento: " +
                                        response.tipo_pagamento /*+
                                        "\n\n" +
                                        "Para pagar pelo Internet Banking. copie a linha digitável ou escaneie o código de barras." +
                                        "\n\n" +
                                        "Se o pagamento é feito de segunda a sexta, é creditado no dia seguinte. Se você pagar no fim de semana, será creditado na terça-feira."*/,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: Dimens.textSize5,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )),
                          Visibility(
                              visible: response.tipo_pagamento == "PIX",
                              child: Column(
                                children: [
                                  Text(
                                    "Tipo de pagamento: " +
                                        response.tipo_pagamento /*+
                                        "\n\n" +
                                        "Copie este código para pagar" +
                                        "\n\n" +
                                        "1. Acesse seu Internet Banking ou app de pagamentos." +
                                        "\n\n" +
                                        "2. Escolha pagar via Pix/QR Code" +
                                        "\n\n" +
                                        "3. Escaneie o seguinte código:"*/,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: Dimens.textSize5,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // Image.memory(
                                  //     Base64Decoder().convert(
                                  //         _base64.toString()))
                                ],
                              )),
                          Visibility(
                              visible: response.tipo_pagamento ==
                                  "Boleto Parcelado",
                              child: Column(
                                children: [
                                  Text(
                                    "Tipo de pagamento: " +
                                        response.tipo_pagamento,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: Dimens.textSize5,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(height: Dimens.marginApplication),
                          Styles().div_horizontal,
                          SizedBox(height: Dimens.marginApplication),
                          Text(
                            "Status da entrega:",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: Dimens.textSize5,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 40),
                          AnotherStepper(
                              stepperDirection: Axis.horizontal,
                              iconWidth: 20,
                              iconHeight: 20,
                              activeBarColor: Colors.green,
                              inActiveBarColor: Colors.grey,
                              verticalGap: 30,
                              activeIndex: response.status_pedido,
                              barThickness: 4,
                              stepperList: [
                                StepperData(
                                    title: StepperText("Recebido",
                                        textStyle: const TextStyle(color: Colors.grey, fontSize: Dimens.textSize4)),
                                    iconWidget: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: response.status_pedido > 0 ? Colors.green : Colors.grey,
                                          borderRadius: BorderRadius.all(Radius.circular(30))),
                                    )),
                                StepperData(
                                    title: StepperText("Em separação",
                                        textStyle: const TextStyle(color: Colors.grey, fontSize: Dimens.textSize4)),
                                    iconWidget: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: response.status_pedido > 1 ? Colors.green : Colors.grey,
                                          borderRadius: BorderRadius.all(Radius.circular(30))),
                                    )),
                                StepperData(
                                    title: StepperText("Faturado",
                                        textStyle: const TextStyle(color: Colors.grey, fontSize: Dimens.textSize4)),
                                    iconWidget: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: response.status_pedido > 2 ? Colors.green : Colors.grey,
                                          borderRadius: BorderRadius.all(Radius.circular(30))),
                                    )),
                                StepperData(
                                    title: StepperText("Enviado",
                                        textStyle: const TextStyle(color: Colors.grey, fontSize: Dimens.textSize4)),
                                    iconWidget: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: response.status_pedido > 3 ? Colors.green : Colors.grey,
                                          borderRadius: BorderRadius.all(Radius.circular(30))),
                                    )),
                                StepperData(
                                    title: StepperText("Entregue",
                                        textStyle: const TextStyle(color: Colors.grey, fontSize: Dimens.textSize4)),
                                    iconWidget: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: response.status_pedido > 4 ? Colors.green : Colors.grey,
                                          borderRadius: BorderRadius.all(Radius.circular(30))),
                                    )),
                                StepperData(
                                    title: StepperText("Cancelado",
                                        textStyle: const TextStyle(color: Colors.grey, fontSize: Dimens.textSize4)),
                                    iconWidget: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: response.status_pedido > 5 ? Colors.green : Colors.grey,
                                          borderRadius: BorderRadius.all(Radius.circular(30))),
                                    )),

                              ],
                            ),

                        ],
                      ),
                    )),

            // Visibility(
            // visible: response.tipo_pagamento == "PIX",
            // child:
            // Column(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       mainAxisSize: MainAxisSize.max,
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         Container(
            //             margin: EdgeInsets.all(Dimens.minMarginApplication),
            //             width: double.infinity,
            //             child: ElevatedButton(
            //                 onPressed: () {
            //                   Clipboard.setData(
            //                       new ClipboardData(text: _qrCodeClipboard));
            //                   ApplicationMessages(context: context)
            //                       .showMessage("Link Copiado!");
            //                 },
            //                 style: Styles().styleAlternativeButton,
            //                 child: Container(
            //                     child: Text("Copiar chave",
            //                         textAlign: TextAlign.center,
            //                         style: Styles().styleDefaultTextButton)))),
            //       ],
            //     ))
              ]);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
