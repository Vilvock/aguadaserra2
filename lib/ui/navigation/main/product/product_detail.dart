import 'dart:convert';

import 'package:app/config/useful.dart';
import 'package:app/model/cart.dart';
import 'package:app/model/favorite.dart';
import 'package:app/model/subcategory.dart';
import 'package:app/res/styles.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../../../config/application_messages.dart';
import '../../../../config/preferences.dart';
import '../../../../global/application_constant.dart';
import '../../../../model/photo.dart';
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
  final TextEditingController quantityController = TextEditingController();

  final postRequest = PostRequest();

  @override
  void initState() {

    quantityController.text = _quantity.toString();
    super.initState();
  }

  @override
  void dispose() {
    quantityController.dispose();
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
          addItemToCart(_id.toString(), unityItemValue, quantity,
              response.carrinho_aberto.toString());
        });
      }
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> addItemToCart(String idProduct, String unityItemValue,
      String quantity, String idCart) async {
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
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          title: "Detalhes da oferta",
          isVisibleBackButton: true, /*isVisibleFavoriteButton: true*/
        ),
        body: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: loadProduct(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final response = Product.fromJson(snapshot.data![0]);

                  var items = <Widget>[];

                  for (var i = 0; i < snapshot.data!.length; i++) {
                    final photo = Photo.fromJson(response.galeria_fotos[i]);
                    items.add(CarouselItemBuilder(image: photo.url));
                  }

                  var buffer = new StringBuffer();

                  for (var i = 0; i < snapshot.data!.length; i++) {
                    final item =
                        SubCategory.fromJson(response.sub_categorias[i]);
                    if (i + 1 == snapshot.data!.length) {
                      buffer.write(item.nome_sub);
                    } else {
                      buffer.write(item.nome_sub + ", ");
                    }
                  }

                  return Stack(children: [
                    SingleChildScrollView(
                        child: Container(
                      padding: EdgeInsets.only(bottom: 100),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CarouselSlider(
                                items: items,
                                options: CarouselOptions(
                                  height: 220,
                                  autoPlay: true,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _pageIndex = index;
                                    });
                                  },
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ...List.generate(
                                          items.length,
                                          (index) => Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 4),
                                                child: DotIndicator(
                                                    isActive:
                                                        index == _pageIndex,
                                                    color: OwnerColors
                                                        .colorPrimary),
                                              )),
                                    ],
                                  )),
                            ],
                          ),
                          // SizedBox(height: Dimens.minMarginApplication),
                          Container(
                              margin: EdgeInsets.all(Dimens.marginApplication),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // SmoothStarRating(
                                  //     allowHalfRating: true,
                                  //     onRated: (v) {},
                                  //     starCount: 5,
                                  //     rating: 2,
                                  //     size: 24.0,
                                  //     isReadOnly: true,
                                  //     color: Colors.amber,
                                  //     borderColor: Colors.amber,
                                  //     spacing: 0.0),
                                  // SizedBox(height: Dimens.minMarginApplication),
                                  Text(
                                    response.nome +
                                        " (Código: " +
                                        response.codigo.toString() +
                                        ")",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: Dimens.textSize7,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: Dimens.minMarginApplication),
                                  Text(
                                    response.nome_categoria +
                                        "(" +
                                        buffer.toString() +
                                        ")" +
                                        "\n",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: Dimens.textSize5,
                                      color: OwnerColors.colorPrimary,
                                    ),
                                  ),
                                  Text(
                                    Useful()
                                        .removeAllHtmlTags(response.descricao),
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
                                      // Text(
                                      //   "Avaliações (xx)",
                                      //   /*maxLines: 2,*/
                                      //   // overflow: TextOverflow.ellipsis,
                                      //   style: TextStyle(
                                      //     fontFamily: 'Inter',
                                      //     fontSize: Dimens.textSize4,
                                      //     color: Colors.black45,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  // SizedBox(height: Dimens.marginApplication),
                                  Text(
                                    response.valor,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: Dimens.textSize7,
                                        color: OwnerColors.darkGreen,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Text(
                                  //   "(50% desconto)",
                                  //   style: TextStyle(
                                  //     fontFamily: 'Inter',
                                  //     fontSize: Dimens.textSize4,
                                  //     color: OwnerColors.colorPrimaryDark,
                                  //   ),
                                  // ),
                                  SizedBox(height: Dimens.marginApplication),
                                  Text(
                                    "Quantidade:",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: Dimens.textSize5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Card(
                                          elevation: 0,
                                          color: OwnerColors.categoryLightGrey,
                                          margin: EdgeInsets.only(
                                              top: Dimens.minMarginApplication),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.minRadiusApplication),
                                          ),
                                          child: Container(
                                              child: Row(children: [
                                            IconButton(
                                              icon: Icon(Icons.remove,
                                                  color: Colors.black),
                                              onPressed: () {
                                                if (_quantity == 1) return;

                                                setState(() {
                                                  _quantity--;

                                                  quantityController.text = _quantity.toString();
                                                });
                                              },
                                            ),
                                            SizedBox(
                                                width: Dimens
                                                    .minMarginApplication),
                                                Container(width: 100, child:
                                                TextField(
                                                  controller: quantityController,
                                                  decoration: InputDecoration(
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: OwnerColors.colorPrimary, width: 1.5),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide(color: Colors.grey, width: 1.0),
                                                    ),
                                                    hintStyle: TextStyle(color: Colors.grey),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(Dimens.radiusApplication),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: Dimens.textSize5,
                                                  ),
                                                )),
                                            // Text(
                                            //   _quantity.toString(),
                                            //   style: TextStyle(
                                            //     fontFamily: 'Inter',
                                            //     fontSize: Dimens.textSize5,
                                            //     color: Colors.black,
                                            //   ),
                                            // ),
                                            SizedBox(
                                                width: Dimens
                                                    .minMarginApplication),
                                            IconButton(
                                              icon: Icon(Icons.add,
                                                  color: Colors.black),
                                              onPressed: () {
                                                setState(() {
                                                  _quantity++;
                                                  quantityController.text = _quantity.toString();
                                                });
                                              },
                                            ),
                                          ])))
                                    ],
                                  )
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
                        Material(
                          elevation: Dimens.elevationApplication,
                          child: Container(
                            height: 2,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(Dimens.minPaddingApplication),
                            color: OwnerColors.colorPrimaryDark,
                            child: IntrinsicHeight(
                                child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(
                                            Dimens.minMarginApplication),
                                        child: Icon(
                                          size: 24,
                                          Icons.favorite_border,
                                          color: Colors.white,
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () => {addFavorite()},
                                          child: Text(
                                            "Favoritar",
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: Dimens.textSize6,
                                              color: Colors.white,
                                            ),
                                          )),
                                    ],
                                  ),
                                )),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: Dimens.minMarginApplication,
                                      bottom: Dimens.minMarginApplication),
                                  child: VerticalDivider(
                                    color: Colors.white,
                                    width: 2,
                                    thickness: 1.5,
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(
                                            Dimens.minMarginApplication),
                                        child: Icon(
                                          color: Colors.white,
                                          size: 24,
                                          Icons.shopping_cart_outlined,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => {
                                          openCart(response.valor,
                                              quantityController.text.toString())
                                        },
                                        child: Text("Adicionar",
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: Dimens.textSize6,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            )))

                        // Container(
                        //     margin: EdgeInsets.all(Dimens.minMarginApplication),
                        //     width: double.infinity,
                        //     child: ElevatedButton(
                        //         onPressed: () {
                        //           openCart(
                        //               response.valor, _quantity.toString());
                        //         },
                        //         style: Styles().styleDefaultButton,
                        //         child: Row(
                        //           children: [
                        //             Icon(Icons.shopping_cart_outlined),
                        //             SizedBox(
                        //                 width: Dimens.minMarginApplication),
                        //             Text(
                        //               "Adicionar ao carrinho",
                        //               textAlign: TextAlign.center,
                        //               style: Styles().styleDefaultTextButton,
                        //             )
                        //           ],
                        //         )))
                      ],
                    )
                  ]);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center(child: CircularProgressIndicator());
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

class CarouselItemBuilder extends StatelessWidget {
  final String image;

  const CarouselItemBuilder({Key? key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.minRadiusApplication),
        ),
        margin: EdgeInsets.all(Dimens.minMarginApplication),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.90,
          child: Image.network(
            ApplicationConstant.URL_PRODUCT_PHOTO + image.toString(),
            // fit: BoxFit.fitWidth,
            height: 220,
            errorBuilder: (context, exception, stackTrack) => Image.asset(
              'images/default.png',
              height: 220,
              width: 220,
            ),
          ),
        ),
      ),
    );
  }
}
