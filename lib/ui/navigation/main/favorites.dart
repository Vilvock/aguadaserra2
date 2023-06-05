import 'dart:convert';

import 'package:app/config/useful.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../config/application_messages.dart';
import '../../../config/preferences.dart';
import '../../../config/validator.dart';
import '../../../global/application_constant.dart';
import '../../../model/cart.dart';
import '../../../model/favorite.dart';
import '../../../model/user.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/strings.dart';
import '../../../res/styles.dart';
import '../../../web_service/links.dart';
import '../../../web_service/service_response.dart';
import '../../components/alert_dialog_generic.dart';
import '../../components/custom_app_bar.dart';
import '../../components/progress_hud.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _Favorites();
}

class _Favorites extends State<Favorites> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  final postRequest = PostRequest();

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
        setState(() {});
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
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
        // setState(() {});
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Meus Favoritos", isVisibleBackButton: false),
      body: ProgressHUD(
        inAsyncCall: _isLoading,
        valueColor: AlwaysStoppedAnimation<Color>(OwnerColors.colorPrimary),
        child: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: listFavorites(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final responseItem = Favorite.fromJson(snapshot.data![0]);

                if (responseItem.rows != 0) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final response = Favorite.fromJson(snapshot.data![index]);

                      return InkWell(
                          onTap: () => {
                                Navigator.pushNamed(
                                    context, "/ui/product_detail",
                                    arguments: {
                                      "id_product": response.id_produto,
                                    })
                              },
                          child: Card(
                            elevation: 0,
                            color: OwnerColors.categoryLightGrey,
                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimens.minRadiusApplication),
                            ),
                            child: Container(
                              padding:
                                  EdgeInsets.all(Dimens.paddingApplication),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                          right: Dimens.minMarginApplication),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Dimens.minRadiusApplication),
                                          child: Image.network(
                                            ApplicationConstant
                                                    .URL_PRODUCT_PHOTO +
                                                response.url_foto.toString(),
                                            height: 90,
                                            width: 90,
                                            errorBuilder: (context, exception,
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
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          response.nome,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: Dimens.textSize5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                Dimens.minMarginApplication),
                                        Text(
                                          response.categoria,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: Dimens.textSize4,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                            Dimens.minMarginApplication),
                                        Text(
                                          response.valor,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: Dimens.textSize6,
                                            color: OwnerColors.darkGreen,
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                Dimens.minMarginApplication),
                                        Divider(
                                          color: Colors.black12,
                                          height: 2,
                                          thickness: 1.5,
                                        ),
                                        SizedBox(
                                            height:
                                                Dimens.minMarginApplication),
                                        Container(
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
                                                    margin: EdgeInsets.only(
                                                        right: Dimens
                                                            .minMarginApplication),
                                                    child: Icon(
                                                        size: 20,
                                                        Icons.shopping_cart_outlined),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () => {
                                                            openCart(
                                                                response
                                                                    .id_produto
                                                                    .toString(),
                                                                response.valor,
                                                                1.toString())
                                                          },
                                                      child: Text(
                                                        "Adicionar",
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontSize:
                                                              Dimens.textSize4,
                                                          color: Colors.black,
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            )),
                                            Container(
                                              child: Styles().div_vertical,
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
                                                    margin: EdgeInsets.only(
                                                        right: Dimens
                                                            .minMarginApplication),
                                                    child: Icon(
                                                        size: 20,
                                                        Icons.delete_outline),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () => {
                                                            showModalBottomSheet<
                                                                dynamic>(
                                                              isScrollControlled:
                                                                  true,
                                                              context: context,
                                                              shape: Styles()
                                                                  .styleShapeBottomSheet,
                                                              clipBehavior: Clip
                                                                  .antiAliasWithSaveLayer,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return GenericAlertDialog(
                                                                    title: Strings
                                                                        .attention,
                                                                    content:
                                                                        "Tem certeza que deseja remover este produto dos favoritos?",
                                                                    btnBack:
                                                                        TextButton(
                                                                            child:
                                                                                Text(
                                                                              Strings.no,
                                                                              style: TextStyle(
                                                                                fontFamily: 'Inter',
                                                                                color: Colors.black54,
                                                                              ),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            }),
                                                                    btnConfirm:
                                                                        TextButton(
                                                                            child:
                                                                                Text(Strings.yes),
                                                                            onPressed: () {
                                                                              removeFavorite(response.id.toString());
                                                                              Navigator.of(context).pop();
                                                                            }));
                                                              },
                                                            )
                                                          },
                                                      child: Text(
                                                        "Remover",
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontSize:
                                                              Dimens.textSize4,
                                                          color: Colors.black,
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            )),
                                          ],
                                        )))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                  );
                } else {
                  return Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Lottie.network(
                                    height: 160,
                                    'https://assets3.lottiefiles.com/private_files/lf30_cgfdhxgx.json')),
                            SizedBox(height: Dimens.marginApplication),
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
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      // listFavorites();
      _isLoading = false;
    });
  }
}
