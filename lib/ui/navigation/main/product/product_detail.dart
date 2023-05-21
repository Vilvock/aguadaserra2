import 'dart:convert';

import 'package:app/model/cart.dart';
import 'package:app/model/favorite.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../../../config/application_messages.dart';
import '../../../../config/preferences.dart';
import '../../../../global/application_constant.dart';
import '../../../../model/product.dart';
import '../../../../res/dimens.dart';
import '../../../../res/owner_colors.dart';
import '../../../../res/strings.dart';
import '../../../../web_service/links.dart';
import '../../../../web_service/service_response.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/dot_indicator.dart';
import '../../../components/progress_hud.dart';
import '../home.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetail();
}

class _ProductDetail extends State<ProductDetail> {
  bool _isLoading = false;
  int _pageIndex = 0;

  late int _id;
  int _quantity = 1;

  final postRequest = PostRequest();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> openCart(String unityItemValue, String quantity) async {
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

      if (response.carrinho_aberto.toString().isNotEmpty) {
        setState(() {

          addItemToCart(_id.toString(), unityItemValue, quantity, response.carrinho_aberto.toString());

        });
      }
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> addItemToCart(String idProduct, String unityItemValue, String quantity, String idCart) async {
    try {
      final body = {
        "id_carrinho": idCart,
        "id_produto": idProduct,
        "valor_uni": unityItemValue,
        "qtd": quantity,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.ADD_ITEM_CART, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Favorite.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {});
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> addFavorite() async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "id_produto": _id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.ADD_FAVORITE, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Favorite.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {});
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> loadProduct() async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "id": _id,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LOAD_PRODUCT, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      // final response = Product.fromJson(_map[0]);
      //
      // if (response.status == "01") {
      //   setState(() {
      //     _product = response;
      //   });
      // } else {}

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = {};
    data = ModalRoute.of(context)!.settings.arguments as Map;

    _id = data['id_product'];

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
            title: "Detalhes da oferta",
            isVisibleBackButton: true,
            isVisibleFavoriteButton: true),
        body: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: loadProduct(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  final response = Product.fromJson(snapshot.data![0]);

                  return Stack(children: [
                    SingleChildScrollView(
                        child: Container(
                      padding: EdgeInsets.only(bottom: 100),
                      child: Column(
                        children: [
                          CarouselSlider(
                            items: carouselItems,
                            options: CarouselOptions(
                              height: 160,
                              autoPlay: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _pageIndex = index;
                                });
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...List.generate(
                                  carouselItems.length,
                                  (index) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: DotIndicator(
                                            isActive: index == _pageIndex,
                                            color:
                                                OwnerColors.colorPrimaryDark),
                                      )),
                            ],
                          ),
                          SizedBox(height: Dimens.minMarginApplication),
                          Container(
                              margin: EdgeInsets.all(Dimens.marginApplication),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SmoothStarRating(
                                      allowHalfRating: true,
                                      onRated: (v) {},
                                      starCount: 5,
                                      rating: 2,
                                      size: 24.0,
                                      isReadOnly: true,
                                      color: Colors.amber,
                                      borderColor: Colors.amber,
                                      spacing: 0.0),
                                  SizedBox(height: Dimens.minMarginApplication),
                                  Text(
                                    response.nome,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: Dimens.textSize6,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: Dimens.marginApplication),
                                  Text(
                                    response.descricao,
                                    /*maxLines: 2,*/
                                    // overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: Dimens.textSize5,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: Dimens.minMarginApplication),
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: Dimens.minMarginApplication),
                                      Text(
                                        "Avaliações (xx)",
                                        /*maxLines: 2,*/
                                        // overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize4,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Dimens.marginApplication),
                                  Text(
                                    response.valor,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: Dimens.textSize8,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "(50% desconto)",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: Dimens.textSize4,
                                      color: OwnerColors.colorPrimaryDark,
                                    ),
                                  ),
                                  SizedBox(height: Dimens.marginApplication),
                                  Row(children: [
                                    Text(
                                      "Quantidade",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: Dimens.textSize5,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                        width: Dimens.minMarginApplication),
                                    FloatingActionButton(
                                      mini: true,
                                      child: Icon(Icons.chevron_left,
                                          color: Colors.black),
                                      backgroundColor: Colors.white,
                                      onPressed: () {
                                        if (_quantity == 1) return;

                                        setState(() {
                                          _quantity--;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                        width: Dimens.minMarginApplication),
                                    Text(
                                      _quantity.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: Dimens.textSize5,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                        width: Dimens.minMarginApplication),
                                    FloatingActionButton(
                                      mini: true,
                                      child: Icon(Icons.chevron_right,
                                          color: Colors.black),
                                      backgroundColor: Colors.white,
                                      onPressed: () {

                                        setState(() {
                                          _quantity++;
                                        });

                                      },
                                    ),
                                  ])
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

                                  openCart(response.valor, _quantity.toString());

                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      OwnerColors.colorPrimary),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.shopping_cart_outlined),
                                    SizedBox(
                                        width: Dimens.minMarginApplication),
                                    Text(
                                      "Adicionar ao carrinho",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: Dimens.textSize8,
                                          color: Colors.white,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.none),
                                    )
                                  ],
                                )))
                      ],
                    )
                  ]);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center( child: CircularProgressIndicator());
              },
            )));
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;

      _isLoading = false;
    });
  }
}
