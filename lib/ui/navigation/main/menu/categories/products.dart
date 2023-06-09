import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../config/preferences.dart';
import '../../../../../config/useful.dart';
import '../../../../../global/application_constant.dart';
import '../../../../../model/product.dart';
import '../../../../../res/dimens.dart';
import '../../../../../res/owner_colors.dart';
import '../../../../../res/strings.dart';
import '../../../../../web_service/links.dart';
import '../../../../../web_service/service_response.dart';
import '../../../../components/custom_app_bar.dart';
import '../../../../components/progress_hud.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _Products();
}

class _Products extends State<Products> {
  bool _isLoading = false;
  late int _idSub;

  final postRequest = PostRequest();

  Future<List<Map<String, dynamic>>> listProducts(String idSubcategory) async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "id_subcategoria": idSubcategory,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LIST_PRODUCTS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = {};
    data = ModalRoute.of(context)!.settings.arguments as Map;

    _idSub = data['id_sub'];


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Produtos", isVisibleBackButton: true),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: listProducts(_idSub.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final responseItem = Product.fromJson(snapshot.data![0]);

              if (responseItem.rows != 0) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final response = Product.fromJson(snapshot.data![index]);

                    return InkWell(
                        onTap: () => {
                              Navigator.pushNamed(context, "/ui/product_detail",
                                  arguments: {
                                    "id_product": response.id,
                                  })
                            },
                        child: Card(
                          elevation: 0,
                          color: OwnerColors.categoryLightGrey,
                          margin: EdgeInsets.all(
                              Dimens.minMarginApplication),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                Dimens.minRadiusApplication),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(
                                Dimens.minPaddingApplication),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                        right: Dimens
                                            .minMarginApplication),
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
                                          height: Dimens
                                              .minMarginApplication),
                                      Text(
                                        response.nome_categoria,
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
                                          Dimens.marginApplication),
                                      Text(
                                        response.valor,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize6,
                                          color: OwnerColors.darkGreen,
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
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;

      _isLoading = false;
    });
  }
}
