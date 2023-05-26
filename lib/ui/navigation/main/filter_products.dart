import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../config/preferences.dart';
import '../../../../global/application_constant.dart';
import '../../../../res/dimens.dart';
import '../../../../res/owner_colors.dart';
import '../../../../res/strings.dart';
import '../../../../web_service/links.dart';
import '../../../../web_service/service_response.dart';
import '../../../res/styles.dart';
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


  final TextEditingController queryController = TextEditingController();

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

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
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          title: "Pesquisar",
          isVisibleBackButton: true,
        ),
        body: /*FutureBuilder<List<Map<String, dynamic>>>(
              future: loadProduct(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  final response = Product.fromJson(snapshot.data![0]);

                  return */
        Stack(children: [
          SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(Dimens.marginApplication),
                padding: EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    TextField(
                      controller: queryController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: OwnerColors.colorPrimary, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: 'Pesquisa...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(Dimens.radiusApplication),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                        EdgeInsets.all(Dimens.textFieldPaddingApplication),
                      ),
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: Dimens.textSize5,
                      ),
                    ),
                    SizedBox(height: Dimens.marginApplication),

                    Text(
                      "Categoria:",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: Dimens.textSize5,
                        color: Colors.black,
                      ),
                    ),

                    DropdownButton<String>(
                      items: <String>['A', 'B', 'C', 'D'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                    SizedBox(height: Dimens.marginApplication),

                    Text(
                      "Subcategoria:",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: Dimens.textSize5,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: Dimens.marginApplication),

                    Text(
                      "Valor(minímo - máximo):",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: Dimens.textSize5,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Container(
                  margin: EdgeInsets.all(Dimens.minMarginApplication),
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: Styles().styleDefaultButton,
                      child: Container(
                          child: Text("Filtrar",
                              textAlign: TextAlign.center,
                              style: Styles().styleDefaultTextButton))))
            ],
          )
        ]));
  }

}
