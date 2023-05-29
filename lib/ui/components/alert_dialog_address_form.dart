import 'dart:convert';

import 'package:app/res/styles.dart';
import 'package:flutter/material.dart';

import '../../config/application_messages.dart';
import '../../config/masks.dart';
import '../../config/preferences.dart';
import '../../config/validator.dart';
import '../../global/application_constant.dart';
import '../../model/user.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';

class AddressFormAlertDialog extends StatefulWidget {
  AddressFormAlertDialog({
    Key? key,
  });

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<AddressFormAlertDialog> createState() => _AddressFormAlertDialog();
}

class _AddressFormAlertDialog extends State<AddressFormAlertDialog> {


  late Validator validator;
  final postRequest = PostRequest();

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController nbhController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController complementController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    cepController.dispose();
    cityController.dispose();
    stateController.dispose();
    nbhController.dispose();
    addressController.dispose();
    numberController.dispose();
    complementController.dispose();
    super.dispose();
  }

  Future<void> saveAddress(String nameAddress,
      String cep,
      String state,
      String city,
      String address,
      String nbh,
      String number,
      String complement) async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "nome": nameAddress,
        "cep": cep,
        "estado": state,
        "cidade": city,
        "endereco": address,
        "bairro": nbh,
        "numero": number,
        "complemento": complement,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.SAVE_ADDRESS, body);
      // final parsedResponse = jsonDecode(json); // pegar um objeto so

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "1") {

        Navigator.of(context).pop(true);

      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> getCepInfo(String cep) async {
    try {

      final json = await postRequest.getCepRequest("$cep/json/");

      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = User.fromJson(parsedResponse);

      setState(() {

        cityController.text = response.localidade;
        stateController.text = response.uf;
        nbhController.text = response.bairro;
        addressController.text = response.logradouro;

        // "cep": "91250-310",
        // "logradouro": "Avenida Adelino Ferreira Jardim",
        // "complemento": "",
        // "bairro": "Rubem Berta",
        // "localidade": "Porto Alegre",
        // "uf": "RS",
        // "ibge": "4314902",
        // "gia": "",
        // "ddd": "51",
        // "siafi": "8801"
      });

    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    validator = Validator(context: context);

    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            child: Card(
              color: Colors.white,
              margin: EdgeInsets.all(Dimens.marginApplication),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.radiusApplication),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Dimens.paddingApplication),
                child: Column(
                  children: [
                    Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Adicione um novo endereço",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: Dimens.textSize6,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimens.marginApplication),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: OwnerColors.colorPrimary,
                                width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          hintText: 'Nome do local',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                Dimens.radiusApplication),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(
                              Dimens.textFieldPaddingApplication),
                        ),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: Dimens.textSize5,
                        ),
                      ),
                    ),]),
                    SizedBox(height: Dimens.marginApplication),
                    Styles().div_horizontal,
                    SizedBox(height: Dimens.marginApplication),
                    TextField(
                      onChanged: (value){

                        if (value.length > 8) {
                          getCepInfo(value);
                        }
                      },
                      controller: cepController,
                      inputFormatters: [Masks().cepMask()],
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: OwnerColors.colorPrimary, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: 'CEP',
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
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: Dimens.textSize5,
                      ),
                    ),
                    SizedBox(height: Dimens.marginApplication),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: cityController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: OwnerColors.colorPrimary,
                                    width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              hintText: 'Cidade',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimens.radiusApplication),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.all(
                                  Dimens.textFieldPaddingApplication),
                            ),
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: Dimens.textSize5,
                            ),
                          ),
                        ),
                        SizedBox(width: Dimens.marginApplication),
                        Expanded(
                          child: TextField(
                            controller: stateController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: OwnerColors.colorPrimary,
                                    width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              hintText: 'Estado',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimens.radiusApplication),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.all(
                                  Dimens.textFieldPaddingApplication),
                            ),
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: Dimens.textSize5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimens.marginApplication),
                    TextField(
                      controller: nbhController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: OwnerColors.colorPrimary, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: 'Bairro',
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
                    Row(
                      children: [
                        Expanded(
                            child: TextField(
                              controller: addressController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: OwnerColors.colorPrimary,
                                      width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                                ),
                                hintText: 'Endereço',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimens.radiusApplication),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.all(
                                    Dimens.textFieldPaddingApplication),
                              ),
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: Dimens.textSize5,
                              ),
                            )),
                        SizedBox(width: Dimens.marginApplication),
                        Expanded(
                          child: TextField(
                            controller: numberController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: OwnerColors.colorPrimary,
                                    width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              hintText: 'Número',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimens.radiusApplication),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.all(
                                  Dimens.textFieldPaddingApplication),
                            ),
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: Dimens.textSize5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimens.marginApplication),
                    TextField(
                      controller: complementController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: OwnerColors.colorPrimary, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: 'Complemento(opcional)',
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
                    Container(
                      margin: EdgeInsets.only(top: Dimens.marginApplication),
                      width: double.infinity,
                      child: ElevatedButton(
                          style: Styles().styleDefaultButton,
                          onPressed: () {

                            if (!validator.validateGenericTextField(nameController.text, "Nome do local")) return;
                            if (!validator.validateCEP(cepController.text)) return;
                            if (!validator.validateGenericTextField(cityController.text, "Cidade")) return;
                            if (!validator.validateGenericTextField(stateController.text, "Estado")) return;
                            if (!validator.validateGenericTextField(nbhController.text, "Bairro")) return;
                            if (!validator.validateGenericTextField(addressController.text, "Endereço")) return;
                            if (!validator.validateGenericTextField(numberController.text, "Número")) return;

                            saveAddress(
                                nameController.text.toString(),
                                cepController.text.toString(),
                                stateController.text.toString(),
                                cityController.text.toString(),
                                addressController.text.toString(),
                                nbhController.text.toString(),
                                numberController.text.toString(),
                                complementController.text.toString());
                          },
                          child: Text(
                            "Adicionar",
                            style: Styles().styleDefaultTextButton,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]);
  }
}
