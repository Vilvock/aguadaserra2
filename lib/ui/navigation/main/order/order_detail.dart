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

  String _base64 = "iVBORw0KGgoAAAANSUhEUgAABWQAAAVkAQAAAAB79iscAAAIrElEQVR42u3dXW7sNhIGUO6A+9+ldqBBgMm9LdZXbCcIMBPx6MGwrZZ42G+F+uG4\/0XXNWhpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlpaWlp\/3ntWK\/5x\/\/mrxtz87nlLX+8ePz+La3x3xvXrxdcv5ZsX09LS0tLS0tLS0tLS\/t27bLs75c8AAW\/LPHnY+luxi\/axKClpaWlpaWlpaWlpT1FuwSQ6ak20FwiwfwVPK7PXTWBKy0tLS0tLS0tLS0tLW3z2xL\/JUVzo0Sg6QctLS0tLS0tLS0tLS1tiA7LEuNZKjm\/xZjLQqUS86alpaWlpaWlpaWlpT1dm\/CfXW53IRfFfPbF7Uovc7Pd364RpaWlpaWlpaWlpaWl\/bdrR+l3+5\/8GLntjpaWlpaWlpaWlpaW9u3afC2JvRGGlswQWd7PnF4bNl7lI1sLLS0tLS0tLS0tLS3tu7Wpe+3OMx5Lxq8+W0aVXKWAM2UBU40nLS0tLS0tLS0tLS3tOdry57VpUkvbWKozP48FuHN4uandLCBaWlpaWlpaWlpaWtrXa3Pod+f83fK\/VKy5fC6hUrKvMGhpaWlpaWlpaWlpac\/R1oH+OTCcOdps83w593c9J5dc4S4tLS0tLS0tLS0tLe0p2s8gcHSB3OKZpfQybSgFlYWX5kgOWlpaWlpaWlpaWlrak7SfnxhdCeSVyyfLi+v70pHZqdqzxKw3LS0tLS0tLS0tLS3tIdolYVeuWfDtWJK2ty0NKClVl5s0Ii0tLS0tLS0tLS0t7bu1I0zhH7lDrpDns0TzysWVKSmYdz9paWlpaWlpaWlpaWmP06bSy5x0a7rh2mXTNtrPpcpOWlpaWlpaWlpaWlraQ7TNkdRlsTToMf12d+dmp7rKR+CaD8WmpaWlpaWlpaWlpaV9t3aDurtZ\/mObtUtRZA1Dlw0tB7dta0RpaWlpaWlpaWlpaWlfpU0j9r\/VWjYFkiVN1\/bAjRI75i+NlpaWlpaWlpaWlpb2AG0+znrkCsuC32+j6albtpYKPWlpaWlpaWlpaWlpaU\/S1nVy\/WVtXFvupuxeq0j4AqWlpaWlpaWlpaWlpT1Cm46frsP7c9qvNsKl6swUhpYv6H6uO2lpaWlpaWlpaWlpaU\/Slp618QwlEz7l5dqE3cxVlwU\/\/sKUElpaWlpaWlpaWlpa2ndoU56vXTsHkGl4\/93l6u780nantLS0tLS0tLS0tLS0R2hL2FgCuWaqyO5HiRPTDJMr98rR0tLS0tLS0tLS0tIeq81llqPL+M0uxfcon0zpvHwM2\/WlG46WlpaWlpaWlpaWlvaN2ivn4ErCrh6WViZK\/g45m1knbVS6PSCAlpaWlpaWlpaWlpb2zdp0LvVnNu6nU0VSr1yqpmym+ufFaWlpaWlpaWlpaWlpj9COzfP5z\/mskqzxX57q35xz3W6IlpaWlpaWlpaWlpb2CG06Ni2981sqcJZtlMgynaw2No11tLS0tLS0tLS0tLS0h2hTIm52QWUaUDJCTHhteU37W\/6WaGlpaWlpaWlpaWlp366tB56VoSVfo8MlJizuO++grfakpaWlpaWlpaWlpaU9TjvyeMcy7bEOI1mqMxdKessmW3j9pOqSlpaWlpaWlpaWlpb2Vdp0iHWul0zVmfusXY0sP8PGGQaUpCdoaWlpaWlpaWlpaWkP0C59cSWy3F\/XZmspf1c+spwDcNHS0tLS0tLS0tLS0h6nLRP8659LiLg5Me0RIiZZHj\/5o6pLWlpaWlpaWlpaWlra92k\/Q8krZ\/LKOqOgluxeSfbd4TCAR+Caw0taWlpaWlpaWlpaWtpztE3lZI4Y72dQWZN9yxPpqIC85xlzjrS0tLS0tLS0tLS0tG\/WJt6mP+3aHGJdAsirmy3ZxI7LhmhpaWlpaWlpaWlpaY\/Q5sa1WVrd0pTJMj1yhua4lEG8t1WXg5aWlpaWlpaWlpaW9iRt6UBrxu5\/BoYpa9d++Mp5w1TP+eOp\/rS0tLS0tLS0tLS0tG\/TlnXuMLd\/di++Ntr2fLZSdTnDN0dLS0tLS0tLS0tLS3uKdjNBJM3ob464Tmt\/rjFCKrBtu6OlpaWlpaWlpaWlpT1HO3IOrkwVWQC1ty29tPTP1T\/\/WhRJS0tLS0tLS0tLS0v7Pu18rpTa35rfkrG8r760bOgu38OXqktaWlpaWlpaWlpaWtpXaXezREo1ZQola\/lkW5OZHtvjaWlpaWlpaWlpaWlp369dutzucPTZ+D6bZDzjxFpDmWadJCgtLS0tLS0tLS0tLe1h2lR6mYeWNEMiM7RN9l052syxKC0tLS0tLS0tLS0t7RHaZsT+cnbaZzi4vHhsWt1yjHkHbdNYR0tLS0tLS0tLS0tL+37tnQE\/2EYbNpZ03lJ1mfY8c6aRlpaWlpaWlpaWlpb27dp9H9sm7TdDN1xOzjUVm1+PD6ClpaWlpaWlpaWlpT1Jm\/J3bTyZFA25hJJ3OF+7jSdpaWlpaWlpaWlpaWkP0KYrVUmW7F5NCi6Ndemx5WTsNB3le9UlLS0tLS0tLS0tLS3tq7Sb5FyKHeuuUmCYKiwLfhdtfo95aWlpaWlpaWlpaWlp36OdT0B6tN3GLrJcRpCUlOH9t6JIWlpaWlpaWlpaWlraV2pLSDeenrr2stNvlZPt15JC2LGbUkJLS0tLS0tLS0tLS3uQ9nEtpZK\/g8AU\/6UZ\/WkQ5SZwpaWlpaWlpaWlpaWlPVs7y919AFlkS0w4yt3lHLeUX6SlpaWlpaWlpaWlpT1H2352v1j7gnIMWzPpP9+9aWlpaWlpaWlpaWlpz9LWwsclYZe7165uGMn1bHqrCcDNWdpXYdDS0tLS0tLS0tLS0r5d+\/9\/0dLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tL+Y9r\/APoZr4LXMwaVAAAAAElFTkSuQmCC";
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
    data = ModalRoute.of(context)!.settings.arguments as Map;

    // _base64 = data['base64'];
    // _qrCodeClipboard = data['qrCodeClipboard'];
    _id = data['id'];

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: "Detalhe do pedido",
          isVisibleBackButton: true,
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: findOrder(_id.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // final response = Order.fromJson(snapshot.data![0]);

              return Stack(children: [
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
                        "Detalhes do pedido #" + _id.toString(),
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
                  ],
                )
              ]);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
