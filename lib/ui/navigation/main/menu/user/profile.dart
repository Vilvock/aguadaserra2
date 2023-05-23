import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../config/application_messages.dart';
import '../../../../../config/masks.dart';
import '../../../../../config/preferences.dart';
import '../../../../../config/validator.dart';
import '../../../../../global/application_constant.dart';
import '../../../../../model/user.dart';
import '../../../../../res/dimens.dart';
import '../../../../../res/owner_colors.dart';
import '../../../../../web_service/links.dart';
import '../../../../../web_service/service_response.dart';
import '../../../../components/custom_app_bar.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    loadProfileRequest();
    super.initState();
  }

  late Validator validator;
  final postRequest = PostRequest();
  User? _profileResponse;

  Future<Map<String, dynamic>> loadProfileRequest() async {
    try {
      final body = {
        "id": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LOAD_PROFILE, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = User.fromJson(parsedResponse);
      //
      // if (response.status == "01") {
      setState(() {
        _profileResponse = response;

        fantasyNameController.text = _profileResponse!.nome.toString();
        emailController.text = _profileResponse!.email.toString();
        cnpjController.text = _profileResponse!.documento.toString();
        cellphoneController.text = _profileResponse!.celular.toString();
      });
      // } else {}

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> updateUserDataRequest(
      String name, String documentCnpj, String cellphone, String email) async {
    try {
      final body = {
        "id": await Preferences.getUserData()!.id,
        "nome": name,
        "documento": documentCnpj,
        "celular": cellphone,
        "email": email,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.UPDATE_USER_DATA, body);
      // final parsedResponse = jsonDecode(json); // pegar um objeto so

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        loadProfileRequest();
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> updatePasswordRequest(String password) async {
    try {
      final body = {
        "id_usuario": await Preferences.getUserData()!.id,
        "password": password,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.UPDATE_PASSWORD, body);
      // final parsedResponse = jsonDecode(json); // pegar um objeto so

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {
          _profileResponse = response;

          passwordController.text = "";
          coPasswordController.text = "";
        });

        loadProfileRequest();
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController coPasswordController = TextEditingController();
  final TextEditingController socialReasonController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();
  final TextEditingController fantasyNameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    coPasswordController.dispose();
    socialReasonController.dispose();
    cnpjController.dispose();
    cellphoneController.dispose();
    fantasyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    validator = Validator(context: context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(title: "Meu Perfil", isVisibleBackButton: true),
        body: Container(
            child: Container(
          child: Column(children: [
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(Dimens.marginApplication),
                child: Column(
                  children: [
                    FutureBuilder<Map<String, dynamic>>(
                      future: loadProfileRequest(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final response = User.fromJson(snapshot.data!);

                          return Container(
                            height: 128,
                              width: 128,
                              margin: EdgeInsets.only(
                                  right: Dimens.marginApplication),
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                    ClipOval(
                                      child: SizedBox.fromSize(
                                        size: Size.fromRadius(72), // Image radius
                                        child: Image.network(ApplicationConstant.URL_AVATAR +
                                            response.avatar.toString(), /*fit: BoxFit.cover*/),
                                      ),
                                    ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: FloatingActionButton(
                                    mini: true,
                                    child: Icon(Icons.camera_alt,
                                        color: Colors.black),
                                    backgroundColor: Colors.white,
                                    onPressed: () {
                                      // Add your onPressed code here!
                                    },
                                  ),
                                )
                              ]));
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                    SizedBox(height: Dimens.marginApplication),
                    TextField(
                      controller: fantasyNameController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: OwnerColors.colorPrimary, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: 'Nome Fantasia',
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
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: OwnerColors.colorPrimary, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: 'E-mail',
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
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: Dimens.textSize5,
                      ),
                    ),
                    SizedBox(height: Dimens.marginApplication),
                    TextField(
                      controller: cnpjController,
                      inputFormatters: [Masks().cnpjMask()],
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: OwnerColors.colorPrimary, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: 'CNPJ',
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
                    TextField(
                      controller: cellphoneController,
                      inputFormatters: [Masks().cellphoneMask()],
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: OwnerColors.colorPrimary, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: 'Celular',
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
                    Container(
                      margin: EdgeInsets.only(
                          top: Dimens.marginApplication,
                          bottom: Dimens.marginApplication),
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                OwnerColors.colorPrimary),
                          ),
                          onPressed: () {
                            if (!validator.validateGenericTextField(
                                fantasyNameController.text, "Nome fantasia"))
                              return;
                            if (!validator.validateEmail(emailController.text))
                              return;
                            if (!validator.validateCNPJ(cnpjController.text))
                              return;
                            if (!validator.validateCellphone(
                                cellphoneController.text)) return;

                            updateUserDataRequest(
                                fantasyNameController.text,
                                cnpjController.text,
                                cellphoneController.text,
                                emailController.text);
                          },
                          child: Text(
                            "Atualizar dados",
                            style: TextStyle(
                                fontSize: Dimens.textSize8,
                                color: Colors.white,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none),
                          )),
                    ),
                    SizedBox(height: Dimens.marginApplication),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: Dimens.marginApplication),
                      child: Text(
                        "Alterar Senha",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: Dimens.textSize6,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: OwnerColors.colorPrimary, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: 'Nova Senha',
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
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: Dimens.textSize5,
                      ),
                    ),
                    SizedBox(height: Dimens.marginApplication),
                    TextField(
                      controller: coPasswordController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: OwnerColors.colorPrimary, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: 'Confirmar Senha',
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
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: Dimens.textSize5,
                      ),
                    ),
                    SizedBox(height: Dimens.marginApplication),
                    Container(
                      margin: EdgeInsets.only(top: Dimens.marginApplication),
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                OwnerColors.colorPrimary),
                          ),
                          onPressed: () {
                            if (!validator.validatePassword(
                                passwordController.text)) return;
                            if (!validator.validateCoPassword(
                                passwordController.text,
                                coPasswordController.text)) return;

                            updatePasswordRequest(passwordController.text);
                          },
                          child: Text(
                            "Atualizar senha",
                            style: TextStyle(
                                fontSize: Dimens.textSize8,
                                color: Colors.white,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none),
                          )),
                    ),
                  ],
                ),
              ),
            )),
          ]),
        )));
  }
}
