import 'dart:convert';
import 'dart:io';

import 'package:app/ui/components/alert_dialog_add_item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../config/application_messages.dart';
import '../../../config/preferences.dart';
import '../../../config/useful.dart';
import '../../../config/validator.dart';
import '../../../global/application_constant.dart';
import '../../../model/cart.dart';
import '../../../model/favorite.dart';
import '../../../model/item.dart';
import '../../../model/product.dart';
import '../../../model/user.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/strings.dart';
import '../../../res/styles.dart';
import '../../../web_service/links.dart';
import '../../../web_service/service_response.dart';
import '../../components/custom_app_bar.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../components/dot_indicator.dart';
import '../../components/progress_hud.dart';
import 'cart_shopping.dart';
import 'favorites.dart';
import 'main_menu.dart';
import 'orders.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [
    ContainerHome(),
    CartShopping(),
    Orders(),
    Favorites(),
    MainMenu()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar:
          BottomNavBar(currentIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}

class ContainerHome extends StatefulWidget {
  const ContainerHome({Key? key}) : super(key: key);

  @override
  State<ContainerHome> createState() => _ContainerHomeState();
}

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  BottomNavBar({this.currentIndex = 0, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: Dimens.elevationApplication,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: OwnerColors.colorPrimaryDark,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Carrinho',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Meus Pedidos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_outlined),
          label: 'Meus Favoritos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Menu Principal',
        ),
      ],
    );
  }
}

class _ContainerHomeState extends State<ContainerHome> {
  bool _isLoading = false;
  int _pageIndex = 0;
  late int _idCart;

  late final validator;
  final postRequest = PostRequest();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    saveFcm();
  }

  final TextEditingController quantityController = TextEditingController();

  @override
  void dispose() {
    quantityController.dispose();
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

  Future<List<Map<String, dynamic>>> listFavorites() async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.LIST_FAVORITES, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> removeFavorite(String idFavorite) async {
    try {
      final body = {"id": idFavorite, "token": ApplicationConstant.TOKEN};

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.DELETE_FAVORITE, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Favorite.fromJson(_map[0]);

      if (response.status == "01") {
        // setState(() {});
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
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
        setState(() {});
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> listCategories() async {
    try {
      final body = {"token": ApplicationConstant.TOKEN};

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.LIST_CATEGORIES, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> openCart(
      String idProduct, String unityItemValue, String quantity) async {
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
        // setState(() {

        addItemToCart(idProduct, unityItemValue, quantity,
            response.carrinho_aberto.toString());

        // });
      }
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> openCart2() async {
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

      final response = Cart.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {});
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> listHighlightsRequest() async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "qtd_lista": 0,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.LIST_HIGHLIGHTS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> saveFcm() async {
    try {
      await Preferences.init();
      String? savedFcmToken = await Preferences.getInstanceTokenFcm();
      String? currentFcmToken = await _firebaseMessaging.getToken();
      if (savedFcmToken != null && savedFcmToken == currentFcmToken) {
        print('FCM: não salvou');
        return;
      }

      var _type = "";

      if (Platform.isAndroid) {
        _type = ApplicationConstant.FCM_TYPE_ANDROID;
      } else if (Platform.isIOS) {
        _type = ApplicationConstant.FCM_TYPE_IOS;
      } else {
        return;
      }

      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "type": _type,
        "registration_id": currentFcmToken,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.SAVE_FCM, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        await Preferences.saveInstanceTokenFcm("token", currentFcmToken!);
        setState(() {});
      } else {}
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: openCart2(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final response = Cart.fromJson(snapshot.data![0]);

            return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: CustomAppBar(
                  title: "Início",
                  isVisibleBackButton: false,
                  isVisibleSearchButton: true,
                  isVisibleNotificationsButton: true,
                ),
                body: Container(
                    height: double.infinity,
                    child: RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: FutureBuilder<Cart>(
                        future:
                            listCartItems(response.carrinho_aberto.toString()),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {

                            final responseCartList = snapshot.data!.itens;

                            return FutureBuilder<List<Map<String, dynamic>>>(
                              future: listFavorites(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final responseFavoriteList = snapshot.data!;

                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            CarouselSlider(
                                              items: carouselItems,
                                              options: CarouselOptions(
                                                height: 190,
                                                autoPlay: false,
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
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ...List.generate(
                                                        carouselItems.length,
                                                        (index) => Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 4),
                                                              child: DotIndicator(
                                                                  isActive: index ==
                                                                      _pageIndex,
                                                                  color: OwnerColors
                                                                      .colorPrimary),
                                                            )),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        FutureBuilder<
                                                List<Map<String, dynamic>>>(
                                            future: listCategories(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final responseItem =
                                                    Product.fromJson(
                                                        snapshot.data![0]);

                                                if (responseItem.rows != 0) {
                                                  return Container(
                                                    height: 120,
                                                    child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          snapshot.data!.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final response = Product
                                                            .fromJson(snapshot
                                                                .data![index]);
                                                        return InkWell(
                                                            onTap: () => {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      "/ui/subcategories",
                                                                      arguments: {
                                                                        "id_category":
                                                                            response.id,
                                                                      })
                                                                },
                                                            child: Column(
                                                                children: [
                                                            Container(
                                                            margin:  EdgeInsets.all(
                                                                Dimens
                                                                    .minMarginApplication),
                                                          child: ClipOval(
                                                            child: SizedBox.fromSize(
                                                              size: Size.fromRadius(38), // Image radius
                                                              child: Image.network(

                                                                ApplicationConstant.URL_CATEGORIES + response.url.toString(),
                                                                fit: BoxFit.cover,
                                                                  errorBuilder: (context, exception, stackTrack) => Image.asset(
                                                                    'images/default.png',
                                                                  )/*fit: BoxFit.cover*/
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                                  Text(
                                                                    response
                                                                        .nome,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Inter',
                                                                      fontSize:
                                                                          Dimens
                                                                              .textSize4,
                                                                    ),
                                                                  ),
                                                                ]));
                                                      },
                                                    ),
                                                  );
                                                }
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    '${snapshot.error}');
                                              }
                                              return const CircularProgressIndicator();
                                            }),
                                        SizedBox(
                                            height: Dimens.marginApplication),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: Dimens.marginApplication,
                                              right: Dimens.marginApplication),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Destaques",
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: Dimens.textSize6,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              // Text(
                                              //   "Ver mais",
                                              //   style: TextStyle(
                                              //     fontFamily: 'Inter',
                                              //     fontSize: Dimens.textSize5,
                                              //     color: OwnerColors.colorPrimaryDark,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        FutureBuilder<
                                            List<Map<String, dynamic>>>(
                                          future: listHighlightsRequest(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return ListView.builder(
                                                primary: false,
                                                shrinkWrap: true,
                                                itemCount:
                                                    snapshot.data!.length,
                                                itemBuilder: (context, index) {
                                                  final response =
                                                      Product.fromJson(snapshot
                                                          .data![index]);

                                                  var _isFavorite = false;

                                                  for (var i = 0;
                                                      i <
                                                          responseFavoriteList
                                                              .length;
                                                      i++) {
                                                    final favorite =
                                                        Favorite.fromJson(
                                                            responseFavoriteList[
                                                                i]);

                                                    if (favorite.id_produto ==
                                                        response.id) {
                                                      _isFavorite = true;
                                                    }
                                                  }

                                                  var _isCart = false;

                                                  for (var i = 0;
                                                  i <
                                                      responseCartList
                                                          .length;
                                                  i++) {
                                                    final item =
                                                    Item.fromJson(
                                                        responseCartList[
                                                        i]);

                                                    if (item.id_produto ==
                                                        response.id) {
                                                      _isCart = true;
                                                    }
                                                  }

                                                  return InkWell(
                                                      onTap: () => {
                                                            Navigator.pushNamed(
                                                                context,
                                                                "/ui/product_detail",
                                                                arguments: {
                                                                  "id_product":
                                                                      response
                                                                          .id,
                                                                })
                                                          },
                                                      child: Card(
                                                        elevation: 0,
                                                        color: OwnerColors
                                                            .categoryLightGrey,
                                                        margin: EdgeInsets.all(
                                                            Dimens
                                                                .minMarginApplication),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(Dimens
                                                                  .minRadiusApplication),
                                                        ),
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .all(Dimens
                                                                  .minPaddingApplication),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                  margin: EdgeInsets.only(
                                                                      right: Dimens
                                                                          .minMarginApplication),
                                                                  child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(Dimens.minRadiusApplication),
                                                                      child: Image.network(
                                                                        ApplicationConstant.URL_PRODUCT_PHOTO +
                                                                            response.url_foto.toString(),
                                                                        height:
                                                                            90,
                                                                        width:
                                                                            90,
                                                                        errorBuilder: (context,
                                                                                exception,
                                                                                stackTrack) =>
                                                                            Image.asset(
                                                                          'images/default.png',
                                                                          height:
                                                                              90,
                                                                          width:
                                                                              90,
                                                                        ),
                                                                      ))),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      response
                                                                          .nome,
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Inter',
                                                                        fontSize:
                                                                            Dimens.textSize6,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            Dimens.minMarginApplication),
                                                                    Text(
                                                                      response
                                                                          .nome_categoria,
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Inter',
                                                                        fontSize:
                                                                            Dimens.textSize5,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            Dimens.marginApplication),
                                                                    Text(
                                                                      response
                                                                          .valor,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Inter',
                                                                        fontSize:
                                                                            Dimens.textSize6,
                                                                        color: OwnerColors
                                                                            .darkGreen,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Column(
                                                                children: [
                                                                  IconButton(
                                                                    icon: Icon(
                                                                      _isFavorite
                                                                          ? Icons
                                                                              .favorite
                                                                          : Icons
                                                                              .favorite,
                                                                      color: _isFavorite
                                                                          ? Colors
                                                                              .red
                                                                          : OwnerColors
                                                                              .darkGrey,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      addItemToFavorite(
                                                                          response
                                                                              .id
                                                                              .toString());
                                                                    },
                                                                  ),
                                                                  IconButton(
                                                                      icon: Icon(
                                                                        _isCart
                                                                            ? Icons
                                                                            .shopping_cart
                                                                            : Icons
                                                                            .shopping_cart,
                                                                        color: _isCart
                                                                            ? OwnerColors.colorPrimary
                                                                            : OwnerColors
                                                                            .darkGrey,
                                                                      ),
                                                                      onPressed:
                                                                          () =>
                                                                              {
                                                                                showModalBottomSheet<dynamic>(
                                                                                    isScrollControlled: true,
                                                                                    context: context,
                                                                                    shape: Styles().styleShapeBottomSheet,
                                                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                                    builder: (BuildContext context) {
                                                                                      return AddItemAlertDialog(
                                                                                          quantityController: quantityController,
                                                                                          btnConfirm: Container(
                                                                                              margin: EdgeInsets.only(top: Dimens.marginApplication),
                                                                                              width: double.infinity,
                                                                                              child: ElevatedButton(
                                                                                                  style: Styles().styleDefaultButton,
                                                                                                  onPressed: () {
                                                                                                    openCart(response.id.toString(), response.valor, quantityController.text);
                                                                                                    Navigator.of(context).pop();
                                                                                                  },
                                                                                                  child: Text("Adicionar ao carrinho", style: Styles().styleDefaultTextButton))));
                                                                                    })
                                                                              }),
                                                                ],
                                                              )
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
                                                /*child: CircularProgressIndicator()*/);
                                          },
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: Dimens.marginApplication,
                                              left: Dimens.marginApplication,
                                              right: Dimens.marginApplication),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Outras ofertas",
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: Dimens.textSize6,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        FutureBuilder<
                                                List<Map<String, dynamic>>>(
                                            future: listHighlightsRequest(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                var gridItems = <Widget>[];

                                                for (var i = 0;
                                                    i < snapshot.data!.length;
                                                    i++) {
                                                  final response =
                                                      Product.fromJson(
                                                          snapshot.data![i]);
                                                  gridItems.add(GridItemBuilder(
                                                      category: response
                                                          .nome_categoria,
                                                      image: response.url_foto,
                                                      name: response.nome,
                                                      value: response.valor,
                                                      id: response.id,
                                                      responseFavoriteList: responseFavoriteList,
                                                      responseCartList: responseCartList,));
                                                }

                                                return Container(
                                                  child: GridView.count(
                                                    childAspectRatio: 0.70,
                                                    primary: false,
                                                    shrinkWrap: true,
                                                    crossAxisCount: 2,
                                                    children: gridItems,
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    '${snapshot.error}');
                                              }
                                              return Center(
                                                  /*child: CircularProgressIndicator()*/);
                                            })
                                      ],
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return Center(
                                    /*child: CircularProgressIndicator()*/);
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          return Center(/*child: CircularProgressIndicator()*/);
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
      // listHighlightsRequest();
      _isLoading = false;
    });
  }
}

final List<Widget> carouselItems = [
  CarouselItemBuilder(image: 'images/banner1_image.jpg'),
  CarouselItemBuilder(image: 'images/banner2_image.jpg'),
];

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
          /*width: MediaQuery.of(context).size.width * 0.90,*/
          child: Image.asset(
            image,
            height: 190,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}

class GridItemBuilder extends StatelessWidget {
  final int id;
  final String image;
  final String name;
  final String value;
  final String category;
  final List<Map<String, dynamic>> responseFavoriteList;
  final List<dynamic> responseCartList;

  GridItemBuilder(
      {Key? key,
      required this.category,
      required this.image,
      required this.name,
      required this.value,
      required this.id, required this.responseCartList, required this.responseFavoriteList});

  final TextEditingController quantityController = TextEditingController();

  final postRequest = PostRequest();

  Future<void> addItemToFavorite(String idProduct, BuildContext context) async {
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

  Future<void> openCart(String idProduct, String unityItemValue,
      String quantity, BuildContext context) async {
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
        // setState(() {

        addItemToCart(idProduct, unityItemValue, quantity,
            response.carrinho_aberto.toString(), context);

        // });
      }
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> addItemToCart(String idProduct, String unityItemValue,
      String quantity, String idCart, BuildContext context) async {
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

      final response = Cart.fromJson(_map[0]);

      if (response.status == "01") {
        // setState(() {});
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    var _isFavorite = false;

    for (var i = 0;
    i <
        responseFavoriteList
            .length;
    i++) {
      final favorite =
      Favorite.fromJson(
          responseFavoriteList[
          i]);

      if (favorite.id_produto ==
          id) {
        _isFavorite = true;
      }
    }

    var _isCart = false;

    for (var i = 0;
    i <
        responseCartList
            .length;
    i++) {
      final item =
      Item.fromJson(
          responseCartList[
          i]);

      if (item.id_produto ==
          id) {
        _isCart = true;
      }
    }

    return Scaffold(
      body: Card(
        elevation: 0,
        color: OwnerColors.categoryLightGrey,
        margin: EdgeInsets.all(Dimens.minMarginApplication),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.minRadiusApplication),
        ),
        child: InkWell(
            onTap: () => {
                  Navigator.pushNamed(context, "/ui/product_detail",
                      arguments: {
                        "id_product": id,
                      })
                },
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    Container(
                        width: double.infinity,
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    Dimens.minRadiusApplication),
                                topRight: Radius.circular(
                                    Dimens.minRadiusApplication)),
                            child: Image.network(
                              ApplicationConstant.URL_PRODUCT_PHOTO +
                                  image.toString(),
                              fit: BoxFit.fitWidth,
                              height: 140,
                              errorBuilder: (context, exception, stackTrack) =>
                                  Image.asset(
                                'images/default.png',
                                height: 140,
                                width: 140,
                              ),
                            ))),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isFavorite
                                ? Icons
                                .favorite
                                : Icons
                                .favorite,
                            color: _isFavorite
                                ? Colors
                                .red
                                : OwnerColors
                                .darkGrey,
                          ),
                          onPressed: () {
                            addItemToFavorite(id.toString(), context);
                          },
                        ),
                        IconButton(
                            icon: Icon(
                              _isCart
                                  ? Icons
                                  .shopping_cart
                                  : Icons
                                  .shopping_cart,
                              color: _isCart
                                  ? OwnerColors.colorPrimary
                                  : OwnerColors
                                  .darkGrey,
                            ),
                            onPressed: () => {
                                  showModalBottomSheet<dynamic>(
                                      isScrollControlled: true,
                                      context: context,
                                      shape: Styles().styleShapeBottomSheet,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      builder: (BuildContext context) {
                                        return AddItemAlertDialog(
                                            quantityController:
                                                quantityController,
                                            btnConfirm: Container(
                                                margin: EdgeInsets.only(
                                                    top: Dimens
                                                        .marginApplication),
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                    style: Styles()
                                                        .styleDefaultButton,
                                                    onPressed: () {
                                                      openCart(
                                                          id.toString(),
                                                          value,
                                                          quantityController
                                                              .text,
                                                          context);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                        "Adicionar ao carrinho",
                                                        style: Styles()
                                                            .styleDefaultTextButton))));
                                      })
                                }),
                      ],
                    )
                  ],
                ),
                SizedBox(height: Dimens.minMarginApplication),
                Container(
                  padding: EdgeInsets.all(Dimens.minPaddingApplication),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SmoothStarRating(
                      //     allowHalfRating: true,
                      //     onRated: (v) {},
                      //     starCount: 5,
                      //     rating: 2,
                      //     size: 16.0,
                      //     isReadOnly: true,
                      //     color: Colors.amber,
                      //     borderColor: Colors.amber,
                      //     spacing: 0.0),
                      // SizedBox(height: Dimens.minMarginApplication),
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: Dimens.textSize6,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: Dimens.minMarginApplication),
                      Text(
                        category,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: Dimens.textSize5,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: Dimens.marginApplication),
                      Text(
                        value,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: Dimens.textSize6,
                          color: OwnerColors.darkGreen,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ))),
      ),
    );
  }
}
