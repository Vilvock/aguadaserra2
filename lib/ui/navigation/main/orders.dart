import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import '../../../config/application_messages.dart';
import '../../../config/preferences.dart';
import '../../../config/validator.dart';
import '../../../global/application_constant.dart';
import '../../../model/order.dart';
import '../../../model/user.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../web_service/links.dart';
import '../../../web_service/service_response.dart';
import '../../components/custom_app_bar.dart';
import '../../components/progress_hud.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _Orders();
}

class _Orders extends State<Orders> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  final postRequest = PostRequest();

  Future<List<Map<String, dynamic>>> listOrders() async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LIST_ORDERS, body);

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
        appBar: CustomAppBar(title: "Meus Pedidos", isVisibleBackButton: false),
        body: ProgressHUD(
          inAsyncCall: _isLoading,
          valueColor: AlwaysStoppedAnimation<Color>(OwnerColors.colorPrimary),
          child: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: listOrders(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final responseItem = Order.fromJson(snapshot.data![0]);

                  if (responseItem.rows != 0) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {

                        final response = Order.fromJson(snapshot.data![index]);

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                Dimens.minRadiusApplication),
                          ),
                          margin: EdgeInsets.all(Dimens.minMarginApplication),
                          child: Container(
                            padding: EdgeInsets.all(Dimens.paddingApplication),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Container(
                                //     margin: EdgeInsets.only(
                                //         right: Dimens.minMarginApplication),
                                //     child: ClipRRect(
                                //         borderRadius: BorderRadius.circular(
                                //             Dimens.minRadiusApplication),
                                //         child: Image.asset(
                                //           'images/person.jpg',
                                //           height: 90,
                                //           width: 90,
                                //         ))),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pedido: #" + response.id.toString() ,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize6,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                          height: Dimens.minMarginApplication),
                                      Text(
                                        "Status do pagamento: " + response.status_pagamento+
                                        "\nValor total: " + response.valor_total,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize5,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                          height: Dimens.marginApplication),
                                      Text(
                                        "Ver detalhes",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize5,
                                          color: OwnerColors.colorPrimaryDark,
                                        ),
                                      ),
                                      SizedBox(
                                          height: Dimens.minMarginApplication),
                                      Divider(
                                        color: Colors.black12,
                                        height: 2,
                                        thickness: 1.5,
                                      ),
                                      SizedBox(
                                          height: Dimens.minMarginApplication),
                                      Text(
                                        response.nome_status_pedido,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize5,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
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
        ));
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      _isLoading = false;
    });
  }
}
