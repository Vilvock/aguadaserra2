import 'dart:convert';

import 'package:flutter/material.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Produtos", isVisibleBackButton: true),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: listProducts("1"),
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
                                                'images/no_picture.png',
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
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize6,
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
                                          fontSize: Dimens.textSize5,
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
              }
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
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
