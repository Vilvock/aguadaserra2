import 'dart:convert';

import 'package:app/model/favorite.dart';
import 'package:app/model/item.dart';
import 'package:flutter/material.dart';
import 'package:app/model/cart.dart';
import 'package:lottie/lottie.dart';

import '../../../config/application_messages.dart';
import '../../../config/preferences.dart';
import '../../../global/application_constant.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/strings.dart';
import '../../../res/styles.dart';
import '../../../web_service/links.dart';
import '../../../web_service/service_response.dart';
import '../../components/alert_dialog_change_quantity_item.dart';
import '../../components/alert_dialog_generic.dart';
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
  int _quantity = 1;

  final postRequest = PostRequest();

  final TextEditingController quantityController = TextEditingController();

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> updateItem(String id, String op) async {
    try {
      final body = {"id": id, "op": op, "token": ApplicationConstant.TOKEN};

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.UPDATE_ITEM_CART, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Cart.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {});
      } else {}
      // ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> updateItem2(String id, String value) async {
    try {
      final body = {
        "id": id,
        "op": 1,
        "valor": value,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.UPDATE_ITEM_CART, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Cart.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {});
      } else {}
      // ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> addItemToFavorite(String idProduct) async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "id_produto": idProduct,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.ADD_FAVORITE, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Cart.fromJson(_map[0]);

      if (response.status == "01") {
        // setState(() {});
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
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

  Future<void> deleteCart(String idCart) async {
    try {
      final body = {
        "id_carrinho": idCart, "token": ApplicationConstant.TOKEN};

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.DELETE_CART, body);

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

                            final responseList =
                                Item.fromJson(snapshot.data!.itens[0]);

                            return Stack(children: [
                              ListView.builder(
                                padding: EdgeInsets.only(bottom: 300),
                                itemCount: snapshot.data!.itens.length,
                                itemBuilder: (context, index) {
                                  if (snapshot.hasData) {
                                    final responseList = Item.fromJson(
                                        snapshot.data!.itens[index]);

                                    _quantity = responseList.qtd;

                                    if (responseList.rows != 0) {
                                      return InkWell(
                                          onTap: () => {
                                                Navigator.pushNamed(context,
                                                    "/ui/product_detail",
                                                    arguments: {
                                                      "id_product": responseList
                                                          .id_produto,
                                                    })
                                              },
                                          child: Card(
                                            elevation: 0,
                                            color:
                                                OwnerColors.categoryLightGrey,
                                            margin: EdgeInsets.all(
                                                Dimens.minMarginApplication),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(Dimens
                                                      .minRadiusApplication),
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.all(
                                                  Dimens.paddingApplication),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
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
                                                                responseList
                                                                    .url_foto
                                                                    .toString(),
                                                            height: 90,
                                                            width: 90,
                                                            errorBuilder: (context,
                                                                    exception,
                                                                    stackTrack) =>
                                                                Image.asset(
                                                              'images/default.png',
                                                              height: 90,
                                                              width: 90,
                                                            ),
                                                          ))),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          responseList
                                                              .nome_produto,
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
                                                                .minMarginApplication),
                                                        Text(
                                                          responseList
                                                              .categoria,
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontSize: Dimens
                                                                .textSize4,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: Dimens
                                                                .marginApplication),

                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                                child: Text(
                                                              responseList
                                                                  .valor_uni,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Inter',
                                                                fontSize: Dimens
                                                                    .textSize6,
                                                                color: OwnerColors
                                                                    .darkGreen,
                                                              ),
                                                            )),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Card(
                                                                    elevation:
                                                                        0,
                                                                    color: OwnerColors
                                                                        .categoryLightGrey,
                                                                    margin: EdgeInsets.only(
                                                                        top: Dimens
                                                                            .minMarginApplication),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              Dimens.minRadiusApplication),
                                                                    ),
                                                                    child: Container(
                                                                        child: Row(children: [
                                                                      IconButton(
                                                                        icon: Icon(
                                                                            Icons
                                                                                .remove,
                                                                            color:
                                                                                Colors.black),
                                                                        onPressed:
                                                                            () {
                                                                          if (_quantity ==
                                                                              1)
                                                                            return;
                                                                          updateItem(
                                                                              responseList.id_item.toString(),
                                                                              ApplicationConstant.REMOVE.toString());
                                                                        },
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              Dimens.minMarginApplication),
                                                                      GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            quantityController.text =
                                                                                responseList.qtd.toString();

                                                                            showModalBottomSheet<dynamic>(
                                                                                isScrollControlled: true,
                                                                                context: context,
                                                                                shape: Styles().styleShapeBottomSheet,
                                                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                                builder: (BuildContext context) {
                                                                                  return ChangeQuantityAlertDialog(
                                                                                      quantityController: quantityController,
                                                                                      btnConfirm: Container(
                                                                                          margin: EdgeInsets.only(top: Dimens.marginApplication),
                                                                                          width: double.infinity,
                                                                                          child: ElevatedButton(
                                                                                              style: Styles().styleDefaultButton,
                                                                                              onPressed: () {
                                                                                                if (int.parse(quantityController.text.toString()) <= 0) {
                                                                                                  ApplicationMessages(context: context).showMessage("A quantidade não pode ser menos que 0");
                                                                                                  return;
                                                                                                }

                                                                                                updateItem2(responseList.id_item.toString(), quantityController.text.toString());

                                                                                                Navigator.of(context).pop();
                                                                                              },
                                                                                              child: Text("Alterar quantidade", style: Styles().styleDefaultTextButton))));
                                                                                });
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            _quantity.toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Inter',
                                                                              fontSize: Dimens.textSize5,
                                                                              color: Colors.black,
                                                                            ),
                                                                          )),
                                                                      SizedBox(
                                                                          width:
                                                                              Dimens.minMarginApplication),
                                                                      IconButton(
                                                                        icon: Icon(
                                                                            Icons
                                                                                .add,
                                                                            color:
                                                                                Colors.black),
                                                                        onPressed:
                                                                            () {
                                                                          updateItem(
                                                                              responseList.id_item.toString(),
                                                                              ApplicationConstant.ADD.toString());
                                                                        },
                                                                      ),
                                                                    ])))
                                                              ],
                                                            )
                                                          ],
                                                        ),

                                                        Styles().div_horizontal,
                                                        SizedBox(
                                                            height: Dimens
                                                                .minMarginApplication),
                                                        Container(
                                                            child:
                                                                IntrinsicHeight(
                                                                    child: Row(
                                                          children: [
                                                            Expanded(
                                                                child:
                                                                    Container(
                                                              child: Wrap(
                                                                direction: Axis
                                                                    .horizontal,
                                                                alignment:
                                                                    WrapAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    WrapCrossAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        right: Dimens
                                                                            .minMarginApplication),
                                                                    child: Icon(
                                                                        size:
                                                                            20,
                                                                        Icons
                                                                            .favorite_border),
                                                                  ),
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () =>
                                                                              {
                                                                                addItemToFavorite(responseList.id_produto.toString())
                                                                              },
                                                                      child:
                                                                          Text(
                                                                        "Favoritar",
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Inter',
                                                                          fontSize:
                                                                              Dimens.textSize4,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      )),
                                                                ],
                                                              ),
                                                            )),
                                                            Container(
                                                              child: Styles()
                                                                  .div_vertical,
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    Container(
                                                              child: Wrap(
                                                                direction: Axis
                                                                    .horizontal,
                                                                alignment:
                                                                    WrapAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    WrapCrossAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        right: Dimens
                                                                            .minMarginApplication),
                                                                    child: Icon(
                                                                        size:
                                                                            20,
                                                                        Icons
                                                                            .delete_outline),
                                                                  ),
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () =>
                                                                              {
                                                                                showModalBottomSheet<dynamic>(
                                                                                  isScrollControlled: true,
                                                                                  context: context,
                                                                                  shape: Styles().styleShapeBottomSheet,
                                                                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                                  builder: (BuildContext context) {
                                                                                    return GenericAlertDialog(
                                                                                        title: Strings.attention,
                                                                                        content: "Tem certeza que deseja remover este item do seu carrinho de compras?",
                                                                                        btnBack: TextButton(
                                                                                            child: Text(
                                                                                              Strings.no,
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Inter',
                                                                                                color: Colors.black54,
                                                                                              ),
                                                                                            ),
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop();
                                                                                            }),
                                                                                        btnConfirm: TextButton(
                                                                                            child: Text(Strings.yes),
                                                                                            onPressed: () {
                                                                                              deleteItemCart(responseList.id_item.toString());
                                                                                              Navigator.of(context).pop();
                                                                                            }));
                                                                                  },
                                                                                )
                                                                              },
                                                                      child:
                                                                          Text(
                                                                        "Remover",
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Inter',
                                                                          fontSize:
                                                                              Dimens.textSize4,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      )),
                                                                ],
                                                              ),
                                                            )),
                                                          ],
                                                        )))
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ));
                                    } else {
                                      return Container(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                    child: Lottie.network(
                                                        height: 160,
                                                        'https://assets3.lottiefiles.com/packages/lf20_fzoupjne.json')),
                                                SizedBox(
                                                    height: Dimens
                                                        .marginApplication),
                                                Text(
                                                  Strings.empty_list,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: Dimens.textSize5,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ]));
                                    }
                                  } else if (snapshot.hasError) {
                                    return Text('${snapshot.error}');
                                  }
                                  return Container(
                                      /*width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator())*/);
                                },
                              ),
                              Visibility(
                                visible: responseList.rows != 0,
                                child: Column(
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
                                            // Row(
                                            //   children: [
                                            //     Expanded(
                                            //       child: Text(
                                            //         "Subtotal",
                                            //         style: TextStyle(
                                            //           fontFamily: 'Inter',
                                            //           fontSize: Dimens.textSize5,
                                            //           color: Colors.black45,
                                            //         ),
                                            //       ),
                                            //     ),
                                            //     Text(
                                            //       "-- , --",
                                            //       style: TextStyle(
                                            //         fontFamily: 'Inter',
                                            //         fontSize: Dimens.textSize5,
                                            //         color: Colors.black45,
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                            GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet<dynamic>(
                                                    isScrollControlled: true,
                                                    context: context,
                                                    shape: Styles().styleShapeBottomSheet,
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    builder: (BuildContext context) {
                                                      return GenericAlertDialog(
                                                          title: Strings.attention,
                                                          content: "Tem certeza que deseja remover todos os itens do seu carrinho?",
                                                          btnBack: TextButton(
                                                              child: Text(
                                                                Strings.no,
                                                                style: TextStyle(
                                                                  fontFamily: 'Inter',
                                                                  color: Colors.black54,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              }),
                                                          btnConfirm: TextButton(
                                                              child: Text(Strings.yes),
                                                              onPressed: () {
                                                                deleteCart(_idCart.toString());
                                                                Navigator.of(context).pop();
                                                              }));
                                                    },
                                                  );
                                                },
                                                child: Align(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .bottomEnd,
                                                    child: Container(
                                                      child: Text(
                                                        textAlign:
                                                            TextAlign.end,
                                                        "Limpar carrinho",
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontSize:
                                                              Dimens.textSize6,
                                                          color: OwnerColors.colorPrimary,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ))),
                                            SizedBox(
                                                height:
                                                Dimens.marginApplication),
                                            Divider(
                                              color: Colors.black12,
                                              height: 2,
                                              thickness: 1.5,
                                            ),
                                            SizedBox(
                                                height:
                                                Dimens.marginApplication),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Valor total em produtos",
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize:
                                                          Dimens.textSize6,
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
                                                height:
                                                    Dimens.marginApplication),
                                            Divider(
                                              color: Colors.black12,
                                              height: 2,
                                              thickness: 1.5,
                                            ),
                                            SizedBox(
                                                height:
                                                    Dimens.marginApplication),
                                            Container(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                  style: Styles()
                                                      .styleDefaultButton,
                                                  onPressed: () {
                                                    if (response.qtd_atual <
                                                        response.qtd_minima) {
                                                      ApplicationMessages(
                                                              context: context)
                                                          .showMessage(
                                                              "É necessário atingir a quantidade mínima de itens antes de prosseguir. (Quantidade mínima: " +
                                                                  response
                                                                      .qtd_minima
                                                                      .toString() +
                                                                  ")");
                                                      return;
                                                    }

                                                    if (response
                                                            .valor_minimo_2 >
                                                        response.total_2) {
                                                      ApplicationMessages(
                                                              context: context)
                                                          .showMessage(
                                                              "É necessário atingir o valor mínimo de itens antes de prosseguir. (Valor mínimo: " +
                                                                  response
                                                                      .valor_minimo
                                                                      .toString() +
                                                                  ")");
                                                      return;
                                                    }

                                                    Navigator.pushNamed(context,
                                                        "/ui/method_payment",
                                                        arguments: {
                                                          "id_cart": _idCart,
                                                        });
                                                  },
                                                  child: Text("Avançar",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Styles()
                                                          .styleDefaultTextButton)),
                                            ),
                                          ]),
                                        ))
                                  ],
                                ),
                              ),
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
