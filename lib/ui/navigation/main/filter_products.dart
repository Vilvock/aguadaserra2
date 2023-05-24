import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../config/preferences.dart';
import '../../../../global/application_constant.dart';
import '../../../../res/dimens.dart';
import '../../../../res/owner_colors.dart';
import '../../../../res/strings.dart';
import '../../../../web_service/links.dart';
import '../../../../web_service/service_response.dart';
import '../../components/custom_app_bar.dart';
import '../../components/progress_hud.dart';

class FilterProducts extends StatefulWidget {
  const FilterProducts ({Key? key}) : super(key: key);

  @override
  State<FilterProducts> createState() => _FilterProducts();
}

class _FilterProducts extends State<FilterProducts> {
  bool _isLoading = false;

  final postRequest = PostRequest();

  Future<List<Map<String, dynamic>>> filterProducts() async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "id_subcategoria": 1,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.FILTER_PRODUCTS, body);

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
      appBar: CustomAppBar(title: "Pesquisar", isVisibleBackButton: true),


    );
  }

}
