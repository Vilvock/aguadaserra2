import 'dart:convert';

import 'package:app/model/product.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../global/application_constant.dart';
import '../../../../../res/dimens.dart';
import '../../../../../res/owner_colors.dart';
import '../../../../../res/strings.dart';
import '../../../../../web_service/links.dart';
import '../../../../../web_service/service_response.dart';
import '../../../../components/custom_app_bar.dart';
import '../../../../components/progress_hud.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _Categories();
}

class _Categories extends State<Categories> {
  bool _isLoading = false;

  final postRequest = PostRequest();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Categorias", isVisibleBackButton: true),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: listCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final responseItem = Product.fromJson(snapshot.data![0]);

              if (responseItem.rows != 0) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final response = Product.fromJson(snapshot.data![index]);

                    return Card(
                      elevation: 0,
                      color: OwnerColors.categoryLightGrey,
                      margin: EdgeInsets.all(Dimens.minMarginApplication),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimens.minRadiusApplication),
                      ),
                      child: InkWell(
                          onTap: () => {
                                Navigator.pushNamed(
                                    context, "/ui/subcategories",
                                    arguments: {
                                      "id_category": response.id,
                                    })
                              },
                          child: Container(
                            padding: EdgeInsets.all(Dimens.minPaddingApplication),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                        right: Dimens.minMarginApplication),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            Dimens.minRadiusApplication),
                                        child: Image.network(
                                          ApplicationConstant.URL_CATEGORIES + response.url.toString(),
                                          height: 24,
                                          width: 24,
                                          errorBuilder: (context, exception, stackTrack) => Image.asset(
                                            'images/default.png',
                                            height: 24,
                                          ),
                                        ))),
                                SizedBox(
                                    width: Dimens.minMarginApplication),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height: Dimens.minMarginApplication),
                                      Text(
                                        response.nome,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize6,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(
                                          height: Dimens.minMarginApplication),
                                      // Text(
                                      //   response.descricao,
                                      //   maxLines: 2,
                                      //   overflow: TextOverflow.ellipsis,
                                      //   style: TextStyle(
                                      //     fontFamily: 'Inter',
                                      //     fontSize: Dimens.textSize5,
                                      //     color: Colors.black,
                                      //   ),
                                      // ),
                                      // SizedBox(height: Dimens.marginApplication),
                                      // Text(
                                      //   response.valor,
                                      //   style: TextStyle(
                                      //     fontFamily: 'Inter',
                                      //     fontSize: Dimens.textSize6,
                                      //     color: Colors.black,
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //     height: Dimens.minMarginApplication),
                                      // Divider(
                                      //   color: Colors.black12,
                                      //   height: 2,
                                      //   thickness: 1.5,
                                      // ),
                                      // SizedBox(
                                      //     height: Dimens.minMarginApplication),
                                      // IntrinsicHeight(
                                      //     child: Row(
                                      //       children: [
                                      //         Icon(
                                      //             size: 20,
                                      //             Icons.shopping_cart_outlined),
                                      //         Text(
                                      //           "Adicionar ao carrinho",
                                      //           style: TextStyle(
                                      //             fontFamily: 'Inter',
                                      //             fontSize: Dimens.textSize4,
                                      //             color: Colors.black,
                                      //           ),
                                      //         ),
                                      //         SizedBox(
                                      //             width: Dimens.minMarginApplication),
                                      //         VerticalDivider(
                                      //           color: Colors.black12,
                                      //           width: 2,
                                      //           thickness: 1.5,
                                      //         ),
                                      //         SizedBox(
                                      //             width: Dimens.minMarginApplication),
                                      //         Icon(size: 20, Icons.delete_outline),
                                      //         Text(
                                      //           "Remover",
                                      //           style: TextStyle(
                                      //             fontFamily: 'Inter',
                                      //             fontSize: Dimens.textSize4,
                                      //             color: Colors.black,
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                    );
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
