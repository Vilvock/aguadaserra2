import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../config/application_messages.dart';
import '../../../config/preferences.dart';
import '../../../config/useful.dart';
import '../../../config/validator.dart';
import '../../../global/application_constant.dart';
import '../../../model/product.dart';
import '../../../model/user.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/strings.dart';
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
      backgroundColor: Colors.white,
      selectedItemColor: OwnerColors.colorPrimary,
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

  @override
  void initState() {
    super.initState();

    saveFcm();
  }

  late final validator;
  final postRequest = PostRequest();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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

      final json =
      await postRequest.sendPostRequest(Links.SAVE_FCM, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        await Preferences.saveInstanceTokenFcm("token", currentFcmToken!);
        setState(() {

        });
      } else {

      }
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Início",
        isVisibleBackButton: false,
        isVisibleSearchButton: true,),
      body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: Container(
            child: SingleChildScrollView(
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
                              (index) =>
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: DotIndicator(
                                    isActive: index == _pageIndex,
                                    color: OwnerColors.colorPrimaryDark),
                              )),
                    ],
                  ),
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
                        Text(
                          "Ver mais",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: Dimens.textSize5,
                            color: OwnerColors.colorPrimaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: listHighlightsRequest(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final response = Product.fromJson(
                                snapshot.data![index]);

                            return InkWell(
                                onTap: () =>
                                {
                                  Navigator.pushNamed(
                                      context, "/ui/product_detail",
                                      arguments: {
                                        "id_product": response.id,
                                      })
                                },
                                child: Card(
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
                                                      response.url_foto
                                                          .toString(),
                                                  height: 90,
                                                  width: 90,
                                                  errorBuilder: (context,
                                                      exception, stackTrack) =>
                                                      Icon(Icons.error,
                                                          size: 90),
                                                ))),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                response.nome,
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
                                              SizedBox(
                                                  height: Dimens
                                                      .minMarginApplication),
                                              Text(
                                                Useful().removeAllHtmlTags(
                                                    response.descricao),
                                                maxLines: 2,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize:
                                                  Dimens.textSize5,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                  height: Dimens
                                                      .marginApplication),
                                              Text(
                                                response.valor,
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize:
                                                  Dimens.textSize6,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        FloatingActionButton(
                                          mini: true,
                                          child: Icon(
                                              Icons
                                                  .favorite_border_outlined,
                                              color: Colors.black),
                                          backgroundColor: Colors.white,
                                          onPressed: () {
                                            // Add your onPressed code here!
                                          },
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
                  FutureBuilder<List<Map<String, dynamic>>>(
                      future: listHighlightsRequest(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            child: GridView.count(
                              childAspectRatio: 0.75,
                              primary: false,
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              children: gridlItems,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return Center(child: CircularProgressIndicator());
                      })

                ],
              ),
            ),
          )),
    );
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
          ),
        ),
      ),
    );
  }
}

final List<Widget> gridlItems = [
  GridItemBuilder(image: ''),
  GridItemBuilder(image: ''),
  GridItemBuilder(image: ''),
  GridItemBuilder(image: ''),
  GridItemBuilder(image: ''),
  GridItemBuilder(image: ''),
];

class GridItemBuilder extends StatelessWidget {
  final String image;

  const GridItemBuilder({Key? key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.minRadiusApplication),
        ),
        margin: EdgeInsets.all(Dimens.minMarginApplication),
        child: Container(
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                Dimens.minRadiusApplication),
                            topRight: Radius.circular(
                                Dimens.minRadiusApplication)),
                        child: Image.asset(
                          fit: BoxFit.fitWidth,
                          'images/person.jpg',
                          height: 140,
                        ))),
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
                        Strings.longLoremIpsum,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: Dimens.textSize5,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: Dimens.marginApplication),
                      Text(
                        "50,00",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: Dimens.textSize6,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
