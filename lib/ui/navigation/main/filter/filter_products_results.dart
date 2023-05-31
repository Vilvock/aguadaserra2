import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../config/preferences.dart';
import '../../../../global/application_constant.dart';
import '../../../../model/product.dart';
import '../../../../res/dimens.dart';
import '../../../../res/owner_colors.dart';
import '../../../../res/strings.dart';
import '../../../../web_service/links.dart';
import '../../../../web_service/service_response.dart';
import '../../../components/custom_app_bar.dart';

class FilterProductsResults extends StatefulWidget {
  const FilterProductsResults ({Key? key}) : super(key: key);

  @override
  State<FilterProductsResults> createState() => _FilterProductsResults();
}

class _FilterProductsResults extends State<FilterProductsResults> {
  bool _isLoading = false;
  late String _results;

  final postRequest = PostRequest();


  @override
  Widget build(BuildContext context) {
    Map data = {};
    data = ModalRoute.of(context)!.settings.arguments as Map;

    _results = data['filtered_products'];

    List<Map<String, dynamic>> _map = [];
    _map = List<Map<String, dynamic>>.from(jsonDecode(_results));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(title: "Produtos filtrados", isVisibleBackButton: true),
        body: ListView.builder(
              itemCount: _map.length,
              itemBuilder: (context, index) {

                final response = Product.fromJson(_map[index]);

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
