import 'dart:convert';

import 'package:app/model/product.dart';
import 'package:flutter/material.dart';

import '../../../../../config/preferences.dart';
import '../../../../../global/application_constant.dart';
import '../../../../../res/dimens.dart';
import '../../../../../res/owner_colors.dart';
import '../../../../../res/strings.dart';
import '../../../../../web_service/links.dart';
import '../../../../../web_service/service_response.dart';
import '../../../../res/styles.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/progress_hud.dart';

class FilterProducts extends StatefulWidget {
  const FilterProducts({Key? key}) : super(key: key);

  @override
  State<FilterProducts> createState() => _FilterProducts();
}

class _FilterProducts extends State<FilterProducts> {
  bool _isLoading = false;
  var currentSelectedValue;
  static const deviceTypes = ["Mac", "Windows", "Mobile"];

  final postRequest = PostRequest();

  final TextEditingController queryController = TextEditingController();

  double _startValue = 0;
  double _endValue = 1000.0;

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }


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

  Future<List<Map<String, dynamic>>> listSubCategories(String idCategory) async {
    try {
      final body = {
        "id_categoria": idCategory,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_SUBCATEGORIES, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> filterProducts({String? name, String? idCategory, String? idSubCategory, String? valueFrom, String? valueTo}) async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "nome": name,
        "categoria": idCategory,
        "sub_categoria": idSubCategory,
        "valor_de": valueFrom,
        "valor_ate": valueTo,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.FILTER_PRODUCTS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Product.fromJson(_map[0]);

      if (response.rows != "0") {

        Navigator.pushNamed(context, "/ui/filter_products_results",
            arguments: {
              "filtered_products": json,
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
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: 'Pesquisar pelo nome...',
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
                Container(
                    padding: EdgeInsets.only(top: Dimens.minPaddingApplication, bottom: Dimens.minPaddingApplication),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text("Selecione", style: TextStyle(
                          fontFamily: 'Inter',
                          color: OwnerColors.colorPrimary,
                        ),),
                        value: currentSelectedValue,
                        isDense: true,
                        onChanged: (newValue) {
                          setState(() {
                            currentSelectedValue = newValue;
                          });
                          print(currentSelectedValue);
                        },
                        items: deviceTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(
                            fontFamily: 'Inter',
                              color: OwnerColors.colorPrimary,)),
                          );
                        }).toList(),
                      ),
                    )),
                SizedBox(height: Dimens.marginApplication),
                Text(
                  "Subcategoria:",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: Dimens.textSize5,
                    color: Colors.black,
                  ),
                ),

                Container(
                    padding: EdgeInsets.only(top: Dimens.minPaddingApplication, bottom: Dimens.minPaddingApplication),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text("Selecione", style: TextStyle(
                          fontFamily: 'Inter',
                          color: OwnerColors.colorPrimary,
                        ),),
                        value: currentSelectedValue,
                        isDense: true,
                        onChanged: (newValue) {
                          setState(() {
                            currentSelectedValue = newValue;
                          });
                          print(currentSelectedValue);
                        },
                        items: deviceTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    )),
                SizedBox(height: Dimens.marginApplication),
                Text(
                  "Valor(minímo - máximo):",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: Dimens.textSize5,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: Dimens.marginApplication),

                RangeSlider(
                  min: 0.0,
                  max: 1000.0,
                  divisions: 100,
                  labels: RangeLabels(
                    "R\$ " + _startValue.round().toString(),
                    "R\$ " +_endValue.round().toString(),
                  ),
                  values: RangeValues(_startValue, _endValue),
                  onChanged: (values) {
                    setState(() {
                      _startValue = values.start;
                      _endValue = values.end;
                    });
                  },
                )
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
                  style: Styles().styleDefaultButton,
                  onPressed: () async {

                    setState(() {
                      _isLoading = true;
                    });

                    await filterProducts();

                    setState(() {
                      _isLoading = false;
                    });


                  },
                  child: (_isLoading)
                      ? const SizedBox(
                      width: Dimens.buttonIndicatorWidth,
                      height: Dimens.buttonIndicatorHeight,
                      child: CircularProgressIndicator(
                        color: OwnerColors.colorAccent,
                        strokeWidth: Dimens.buttonIndicatorStrokes,
                      ))
                      : Text("Filtrar",
                      style: Styles().styleDefaultTextButton),
                ),
              ),
            ],
          )
        ]));
  }
}
