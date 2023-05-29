import 'dart:convert';

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

  late String _base64;
  late String _qrCodeClipboard;
  final postRequest = PostRequest();


  Future<void> findOrder() async {
    try {
      final body = {
        "id": 16,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.FIND_ORDER, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Order.fromJson(parsedResponse);

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
    data = ModalRoute.of(context)!.settings.arguments as Map;

    _base64 = data['base64'];
    _qrCodeClipboard = data['qrCodeClipboard'];


    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: "Compra finalizada!",
          // isVisibleBackButton: true,
        ),
        body: /*FutureBuilder<List<Map<String, dynamic>>>(
              future: loadProduct(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  final response = Product.fromJson(snapshot.data![0]);

                  return */
        Stack(children: [
          SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(Dimens.marginApplication),
                padding: EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        child: Image.asset(
                          fit: BoxFit.fitWidth,
                          'images/success.png',
                          height: 120,
                        )),
                    SizedBox(height: Dimens.marginApplication),
                    Text(
                      "Detalhes do pedido #0000000",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: Dimens.textSize6,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
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
                    // FutureBuilder<Cart>(
                    //   future:
                    //   listCartItems(_idCart.toString()),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.hasData) {
                    //       return ListView.builder(
                    //         primary: false,
                    //         shrinkWrap: true,
                    //         itemCount: snapshot.data!.itens.length,
                    //         itemBuilder: (context, index) {
                    //
                    //           final response = Item.fromJson(snapshot.data!.itens[index]);
                    //
                    //           return InkWell(
                    //               onTap: () => {
                    //                 Navigator.pushNamed(
                    //                     context, "/ui/product_detail",
                    //                     arguments: {
                    //                       "id_product": response.id,
                    //                     })
                    //               },
                    //               child: Card(
                    //                 shape: RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(
                    //                       Dimens.minRadiusApplication),
                    //                 ),
                    //                 margin: EdgeInsets.all(
                    //                     Dimens.minMarginApplication),
                    //                 child: Container(
                    //                   padding: EdgeInsets.all(
                    //                       Dimens.paddingApplication),
                    //                   child: Row(
                    //                     crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                     children: [
                    //                       Container(
                    //                           margin: EdgeInsets.only(
                    //                               right: Dimens
                    //                                   .minMarginApplication),
                    //                           child: ClipRRect(
                    //                               borderRadius: BorderRadius
                    //                                   .circular(Dimens
                    //                                   .minRadiusApplication),
                    //                               child: Image.network(
                    //                                 ApplicationConstant.URL_PRODUCT_PHOTO + response.url_foto.toString(),
                    //                                 height: 90,
                    //                                 width: 90,
                    //                                 errorBuilder: (context, exception, stackTrack) => Icon(Icons.error, size: 90),
                    //                               ))),
                    //                       Expanded(
                    //                         child: Column(
                    //                           crossAxisAlignment:
                    //                           CrossAxisAlignment.start,
                    //                           children: [
                    //                             Text(
                    //                               response.nome_produto,
                    //                               maxLines: 1,
                    //                               overflow:
                    //                               TextOverflow.ellipsis,
                    //                               style: TextStyle(
                    //                                 fontFamily: 'Inter',
                    //                                 fontSize:
                    //                                 Dimens.textSize6,
                    //                                 fontWeight:
                    //                                 FontWeight.bold,
                    //                                 color: Colors.black,
                    //                               ),
                    //                             ),
                    //                             SizedBox(
                    //                                 height: Dimens
                    //                                     .minMarginApplication),
                    //                             Text(
                    //                               response.valor,
                    //                               style: TextStyle(
                    //                                 fontFamily: 'Inter',
                    //                                 fontSize:
                    //                                 Dimens.textSize6,
                    //                                 color: Colors.black,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ));
                    //         },
                    //       );
                    //     } else if (snapshot.hasError) {
                    //       return Text('${snapshot.error}');
                    //     }
                    //     return Center( child: CircularProgressIndicator());
                    //   },
                    // ),
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
                      Strings.shortLoremIpsum +
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

                    Image.memory(Base64Decoder().convert(_base64.toString()))
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
                        Clipboard.setData(new ClipboardData(text: _qrCodeClipboard));
                        ApplicationMessages(context: context).showMessage("Link Copiado!");
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
          )
        ]));
    /*     } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center( child: CircularProgressIndicator());
              },
            )));*/
  }
}
