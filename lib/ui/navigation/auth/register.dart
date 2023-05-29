import 'dart:convert';
import 'dart:ffi';

import 'package:app/res/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../config/application_messages.dart';
import '../../../config/masks.dart';
import '../../../config/preferences.dart';
import '../../../config/validator.dart';
import '../../../global/application_constant.dart';
import '../../../model/user.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../web_service/links.dart';
import '../../../web_service/service_response.dart';
import '../../components/alert_dialog_sucess.dart';
import '../../components/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/custom_app_bar.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late bool _passwordVisible;
  late bool _passwordVisible2;

  bool hasPasswordCoPassword = false;
  bool hasUppercase = false;
  bool hasMinLength = false;
  bool visibileOne = false;
  bool visibileTwo = false;

  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _passwordVisible2 = false;
  }

  late Validator validator;
  final postRequest = PostRequest();
  User? _registerResponse;

  Future<void> registerRequest(
      String email,
      String password,
      String fantasyName,
      String socialReason,
      String cnpj,
      String cellphone,
      String latitude,
      String longitude) async {
    try {
      final body = {
        "razao_social": socialReason,
        "nome_fantasia": fantasyName,
        "cnpj": cnpj,
        "email": email,
        "celular": cellphone,
        "password": password,
        "latitude": latitude,
        "longitude": longitude,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.REGISTER, body);
      // final parsedResponse = jsonDecode(json); // pegar um objeto so

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        showModalBottomSheet<dynamic>(
          isScrollControlled: true,
          context: context,
          shape: Styles().styleShapeBottomSheet,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          builder: (BuildContext context) {
            return SucessAlertDialog(
                content: response.msg,
                btnConfirm: Container(
                    margin: EdgeInsets.only(top: Dimens.marginApplication),
                    width: double.infinity,
                    child: ElevatedButton(
                        style: Styles().styleDefaultButton,
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text("Ok",
                            style: Styles().styleDefaultTextButton))));
          },
        );
      } else {
        ApplicationMessages(context: context).showMessage(response.msg);
      }
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> saveUserToPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = user.toJson();
    await prefs.setString('user', jsonEncode(userData));
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
        resizeToAvoidBottomInset: true,
        // appBar: CustomAppBar(),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            OwnerColors.gradientFirstColor,
            OwnerColors.gradientSecondaryColor,
            OwnerColors.gradientThirdColor
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Column(children: [
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(Dimens.marginApplication),
                child: Column(
                  children: [
                    SizedBox(height: 36),
                    Image.asset(
                      'images/main_logo_1.png',
                      height: 70,
                    ),
                    SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Olá, \nCrie uma conta",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: Dimens.textSize8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    TextField(
                      controller: socialReasonController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: OwnerColors.colorPrimary, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: 'Razão Social',
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
                      onChanged: (value) {
                        setState(() {
                          hasPasswordCoPassword = false;
                          visibileOne = true;
                          hasMinLength = passwordController.text.length >= 8;
                          hasUppercase = passwordController.text
                              .contains(RegExp(r'[A-Z]'));

                          hasPasswordCoPassword = coPasswordController.text ==
                              passwordController.text;

                          if (hasMinLength && hasUppercase) {
                            visibileOne = false;
                          }
                        });
                      },
                      controller: passwordController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: OwnerColors.colorPrimary,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            }),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: OwnerColors.colorPrimary, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: 'Senha',
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
                      obscureText: !_passwordVisible,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: Dimens.textSize5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Visibility(
                      visible: passwordController.text.isNotEmpty,
                      child: Row(
                        children: [
                          Icon(
                            hasMinLength
                                ? Icons.check_circle
                                : Icons.check_circle,
                            color: hasMinLength
                                ? Colors.green
                                : OwnerColors.lightGrey,
                          ),
                          Text(
                            'Deve ter no mínimo 8 carácteres',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: passwordController.text.isNotEmpty,
                      child: Row(
                        children: [
                          Icon(
                            hasUppercase
                                ? Icons.check_circle
                                : Icons.check_circle,
                            color: hasUppercase
                                ? Colors.green
                                : OwnerColors.lightGrey,
                          ),
                          Text(
                            'Deve ter uma letra maiúscula',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimens.marginApplication),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          visibileTwo = true;
                          hasPasswordCoPassword = coPasswordController.text ==
                              passwordController.text;

                          if (hasPasswordCoPassword) {
                            visibileTwo = false;
                          }
                        });
                      },
                      controller: coPasswordController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisible2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: OwnerColors.colorPrimary,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisible2 = !_passwordVisible2;
                              });
                            }),
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
                      obscureText: !_passwordVisible2,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: Dimens.textSize5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Visibility(
                      visible: coPasswordController.text.isNotEmpty,
                      child: Row(
                        children: [
                          Icon(
                            hasPasswordCoPassword
                                ? Icons.check_circle
                                : Icons.check_circle,
                            color: hasPasswordCoPassword
                                ? Colors.green
                                : OwnerColors.lightGrey,
                          ),
                          Text(
                            'As senhas fornecidas são idênticas',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimens.marginApplication,),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimens.textSize5,
                          fontFamily: 'Inter',
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Ao clicar no botão Criar conta, você aceita os'),
                          TextSpan(
                              text: ' Termos de uso',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimens.textSize5,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {

                                  Navigator.pushNamed(context, "/ui/pdf_viewer");
                                }),

                          TextSpan(text: ' do aplicativo.'),

                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: Dimens.marginApplication),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: Styles().styleDefaultButton,
                        onPressed: () async {
                          if (!validator.validateGenericTextField(
                              socialReasonController.text, "Razão social"))
                            return;
                          if (!validator.validateGenericTextField(
                              fantasyNameController.text, "Nome fantasia"))
                            return;
                          if (!validator.validateCNPJ(cnpjController.text))
                            return;
                          if (!validator.validateCellphone(
                              cellphoneController.text)) return;
                          if (!validator.validateEmail(emailController.text))
                            return;
                          if (!validator.validatePassword(
                              passwordController.text)) return;
                          if (!validator.validateCoPassword(
                              passwordController.text,
                              coPasswordController.text)) return;

                          setState(() {
                            _isLoading = true;
                          });

                          await registerRequest(
                              emailController.text,
                              passwordController.text,
                              fantasyNameController.text,
                              socialReasonController.text,
                              cnpjController.text,
                              cellphoneController.text,
                              "432432432",
                              "432423423");

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
                            : Text("Criar conta",
                            style: Styles().styleDefaultTextButton),
                      ),
                    ),
                    SizedBox(height: Dimens.marginApplication),

                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimens.textSize5,
                        fontFamily: 'Inter',
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Já possui uma conta? '),
                        TextSpan(
                            text: 'Entre aqui',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimens.textSize5,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {

                                Navigator.of(context).pop();
                              }),

                      ],
                    ),
                  )
                  ],
                ),
              ),
            )),
          ]),
        ));
  }
}
