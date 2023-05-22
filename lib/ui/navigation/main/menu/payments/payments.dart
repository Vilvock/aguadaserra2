import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../../config/application_messages.dart';
import '../../../../../config/preferences.dart';
import '../../../../../global/application_constant.dart';
import '../../../../../model/user.dart';
import '../../../../../res/dimens.dart';
import '../../../../../res/owner_colors.dart';
import '../../../../../res/strings.dart';
import '../../../../../res/styles.dart';
import '../../../../../web_service/links.dart';
import '../../../../../web_service/service_response.dart';
import '../../../../components/custom_app_bar.dart';
import '../../../../components/progress_hud.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _Payment();
}

class _Payment extends State<Payment> {
  bool _isLoading = false;

  final postRequest = PostRequest();

  Future<List<Map<String, dynamic>>> listPayments() async {
    try {
      final body = {
        "id_usuario": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.LIST_PAYMENTS, body);

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
      appBar: CustomAppBar(
          title: "Meus Pagamentos",
          isVisibleBackButton: true),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: listPayments(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final firstItem = User.fromJson(snapshot.data![0]);

              if (firstItem.rows != 0) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {

                    final response = User.fromJson(snapshot.data![index]);
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimens.minRadiusApplication),
                      ),
                      margin: EdgeInsets.all(Dimens.minMarginApplication),
                      child: Container(
                        padding: EdgeInsets.all(Dimens.paddingApplication),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Endereço selecionado",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: Dimens.textSize4,
                                      fontWeight: FontWeight.bold,
                                      color: OwnerColors.colorPrimaryDark,
                                    ),
                                  ),
                                  SizedBox(height: Dimens.minMarginApplication),
                                  Text(
                                    response.endereco_completo,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: Dimens.textSize5,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: Dimens.minMarginApplication),

                                  Styles().div_horizontal
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
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;

      _isLoading = false;
    });
  }
}
