import 'dart:convert';

import 'package:app/model/favorite.dart';
import 'package:app/model/item.dart';
import 'package:flutter/material.dart';
import 'package:app/model/cart.dart';

import '../../../config/application_messages.dart';
import '../../../config/preferences.dart';
import '../../../global/application_constant.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/strings.dart';
import '../../../res/styles.dart';
import '../../../web_service/links.dart';
import '../../../web_service/service_response.dart';
import '../../components/custom_app_bar.dart';
import '../../components/progress_hud.dart';

class CartShopping extends StatefulWidget {
  const CartShopping({Key? key}) : super(key: key);

  @override
  State<CartShopping> createState() => _CartShopping();
}

class _CartShopping extends State<CartShopping> {
  bool _isLoading = false;
  late int? _idCart = null;

  final postRequest = PostRequest();

  @override
  void initState() {
    super.initState();
  }

  Future<List<Map<String, dynamic>>> openCart() async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.OPENED_CART, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Cart.fromJson(_map[0]);

      _idCart = response.carrinho_aberto;

      return _map;
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

  Future<void> deleteItemCart(String idProduct) async {
    try {
      final body = {"id": idProduct, "token": ApplicationConstant.TOKEN};

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.DELETE_ITEM_CART, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Cart.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {});
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: openCart(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final response = Cart.fromJson(snapshot.data![0]);

            return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar:
                    CustomAppBar(title: "Carrinho", isVisibleBackButton: false),
                body: Container(
                    height: double.infinity,
                    child: RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: FutureBuilder<Cart>(
                        future:
                            listCartItems(response.carrinho_aberto.toString()),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {

                            final response = snapshot.data!;

                            return Stack(children: [
                              ListView.builder(
                                padding: EdgeInsets.only(bottom: 300),
                                itemCount: snapshot.data!.itens.length,
                                itemBuilder: (context, index) {
                                  final responseList =
                                      Item.fromJson(snapshot.data!.itens[index]);

                                  if (responseList.rows != 0) {
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
                                                          responseList.url_foto
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
                                                    responseList.nome_produto,
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
                                                  // SizedBox(
                                                  //     height: Dimens
                                                  //         .minMarginApplication),
                                                  // Text(
                                                  //   Strings.longLoremIpsum,
                                                  //   maxLines: 2,
                                                  //   overflow:
                                                  //       TextOverflow.ellipsis,
                                                  //   style: TextStyle(
                                                  //     fontFamily: 'Inter',
                                                  //     fontSize: Dimens.textSize5,
                                                  //     color: Colors.black,
                                                  //   ),
                                                  // ),
                                                  SizedBox(
                                                      height: Dimens
                                                          .marginApplication),
                                                  Text(
                                                    responseList.valor_uni,
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize:
                                                          Dimens.textSize6,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: Dimens
                                                          .minMarginApplication),
                                                  Divider(
                                                    color: Colors.black12,
                                                    height: 2,
                                                    thickness: 1.5,
                                                  ),
                                                  SizedBox(
                                                      height: Dimens
                                                          .minMarginApplication),
                                                  IntrinsicHeight(
                                                      child: Row(
                                                    children: [
                                                      Icon(
                                                          size: 20,
                                                          Icons
                                                              .favorite_border_outlined),
                                                      Text(
                                                        "Mover para os favoritos",
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontSize:
                                                              Dimens.textSize4,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: Dimens
                                                              .minMarginApplication),
                                                      VerticalDivider(
                                                        color: Colors.black12,
                                                        width: 2,
                                                        thickness: 1.5,
                                                      ),
                                                      SizedBox(
                                                          width: Dimens
                                                              .minMarginApplication),
                                                      GestureDetector(
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                                size: 20,
                                                                Icons
                                                                    .delete_outline),
                                                            Text(
                                                              "Remover",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Inter',
                                                                fontSize: Dimens
                                                                    .textSize4,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        onTap: () => {
                                                          deleteItemCart(
                                                              responseList.id_item
                                                                  .toString())
                                                        },
                                                      )
                                                    ],
                                                  ))
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('${snapshot.error}');
                                  }
                                  return Container(/*width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator())*/);
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
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
                                                  "Subtotal",
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: Dimens.textSize5,
                                                    color: Colors.black45,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "-- , --",
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: Dimens.textSize5,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Total",
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: Dimens.textSize6,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                response.total,
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: Dimens.textSize6,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: Dimens.marginApplication),
                                          Divider(
                                            color: Colors.black12,
                                            height: 2,
                                            thickness: 1.5,
                                          ),
                                          SizedBox(
                                              height: Dimens.marginApplication),
                                          Container(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                                style: Styles().styleDefaultButton,
                                                onPressed: () {
                                                  Navigator.pushNamed(context,
                                                      "/ui/method_payment",
                                                      arguments: {
                                                        "id_cart": _idCart,
                                                      });
                                                },
                                                child: Text(
                                                  "Avançar",
                                                  textAlign: TextAlign.center,
                                                  style: Styles().styleDefaultTextButton
                                                )),
                                          ),
                                        ]),
                                      ))
                                ],
                              )
                            ]);
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                    )));
          } else {
            return Center(/*child: CircularProgressIndicator()*/);
          }
        });
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;

      _isLoading = false;
    });
  }
}
