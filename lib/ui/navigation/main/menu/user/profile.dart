import 'dart:convert';
import 'dart:io';

import 'package:app/res/styles.dart';
import 'package:app/ui/components/alert_dialog_pick_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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

    _passwordVisible = false;
    _passwordVisible2 = false;
    super.initState();
  }

  late bool _passwordVisible;
  late bool _passwordVisible2;

  bool hasPasswordCoPassword = false;
  bool hasUppercase = false;
  bool hasMinLength = false;
  bool visibileOne = false;
  bool visibileTwo = false;

  bool _isLoading = false;
  late Validator validator;
  final postRequest = PostRequest();
  User? _profileResponse;

  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);

      sendPhoto(imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);

      sendPhoto(imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> sendPhoto(File image) async {
    try {
      final json = await postRequest.sendPostRequestMultiPart(
          Links.UPDATE_AVATAR,
          image,
          await Preferences.getUserData()!.id.toString());

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {});
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

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
      // setState(() {
      _profileResponse = response;

      fantasyNameController.text = _profileResponse!.nome.toString();
      emailController.text = _profileResponse!.email.toString();
      documentController.text = _profileResponse!.documento.toString();
      cellphoneController.text = _profileResponse!.celular.toString();
      iEController.text = _profileResponse!.ie.toString();
      // });
      // } else {}

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> updateUserDataRequest(String ie, String name,
      String documentCnpj, String cellphone, String email) async {
    try {
      final body = {
        "id": await Preferences.getUserData()!.id,
        "nome": name,
        "documento": documentCnpj,
        "celular": cellphone,
        "email": email,
        "ie": ie,
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
        setState(() {});
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

        // loadProfileRequest();
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
  final TextEditingController documentController = TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();
  final TextEditingController fantasyNameController = TextEditingController();
  final TextEditingController iEController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    coPasswordController.dispose();
    socialReasonController.dispose();
    documentController.dispose();
    cellphoneController.dispose();
    fantasyNameController.dispose();
    iEController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    validator = Validator(context: context);

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(title: "Meu Perfil", isVisibleBackButton: true),
        body: FutureBuilder<Map<String, dynamic>>(
            future: loadProfileRequest(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final response = User.fromJson(snapshot.data!);

                return Column(children: [
                  Expanded(
                      child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(Dimens.marginApplication),
                      child: Column(
                        children: [
                          Container(
                              height: 128,
                              width: 128,
                              margin: EdgeInsets.only(
                                  right: Dimens.marginApplication),
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                ClipOval(
                                  child: SizedBox.fromSize(
                                    size: Size.fromRadius(72),
                                    // Image radius
                                    child: Image.network(
                                        ApplicationConstant.URL_AVATAR +
                                            response.avatar.toString(),
                                        fit: BoxFit.cover),
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
                                      showModalBottomSheet<dynamic>(
                                          isScrollControlled: true,
                                          context: context,
                                          shape: Styles().styleShapeBottomSheet,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          builder: (BuildContext context) {
                                            return PickImageAlertDialog(
                                                iconCamera: IconButton(
                                                    onPressed: () {
                                                      pickImageCamera();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    icon: Icon(Icons.camera_alt,
                                                        color: Colors.black),
                                                    iconSize: 60),
                                                iconGallery: IconButton(
                                                    onPressed: () {
                                                      pickImageGallery();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    icon: Icon(Icons.photo,
                                                        color: Colors.black),
                                                    iconSize: 60));
                                          });
                                    },
                                  ),
                                )
                              ])),
                          SizedBox(height: Dimens.marginApplication),
                          TextField(
                            controller: fantasyNameController,
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
                              hintText: 'Nome',
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
                          SizedBox(height: Dimens.marginApplication),
                          TextField(
                            readOnly: true,
                            controller: emailController,
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
                              hintText: 'E-mail',
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
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: Dimens.textSize5,
                            ),
                          ),
                          SizedBox(height: Dimens.marginApplication),
                          TextField(
                            readOnly: true,
                            controller: documentController,
                            // inputFormatters: [Masks().cnpjMask()],
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
                              hintText: 'Documento',
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
                          SizedBox(height: Dimens.marginApplication),
                          Visibility(
                              visible: response.tipo_pessoa == 2,
                              child: Column(
                                children: [
                                  TextField(
                                    controller: iEController,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: OwnerColors.colorPrimary,
                                            width: 1.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                      hintText: 'Inscrição Estadual',
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
                                  SizedBox(height: Dimens.marginApplication),
                                ],
                              )),
                          TextField(
                            controller: cellphoneController,
                            inputFormatters: [Masks().cellphoneMask()],
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
                              hintText: 'Celular',
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
                          SizedBox(height: Dimens.marginApplication),
                          Container(
                            margin: EdgeInsets.only(
                                top: Dimens.marginApplication,
                                bottom: Dimens.marginApplication),
                            width: double.infinity,
                            child: ElevatedButton(
                              style: Styles().styleDefaultButton,
                              onPressed: () async {
                                if (!validator.validateGenericTextField(
                                    fantasyNameController.text, "Nome")) return;
                                // if (!validator.validateEmail(emailController.text))
                                //   return;
                                // if (!validator.validateCNPJ(documentController.text))
                                //   return;

                                if (_profileResponse?.tipo_pessoa.toString() ==
                                    "2") {
                                  if (!validator.validateGenericTextField(
                                      iEController.text, "Inscrição Estadual"))
                                    return;
                                }

                                if (!validator.validateCellphone(
                                    cellphoneController.text)) return;

                                setState(() {
                                  _isLoading = true;
                                });

                                await updateUserDataRequest(
                                    iEController.text,
                                    fantasyNameController.text,
                                    documentController.text,
                                    cellphoneController.text,
                                    emailController.text);

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
                                        strokeWidth:
                                            Dimens.buttonIndicatorStrokes,
                                      ))
                                  : Text("Atualizar dados",
                                      style: Styles().styleDefaultTextButton),
                            ),
                          ),
                          SizedBox(height: Dimens.marginApplication),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                bottom: Dimens.marginApplication),
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
                            onChanged: (value) {
                              setState(() {
                                hasPasswordCoPassword = false;
                                visibileOne = true;
                                hasMinLength =
                                    passwordController.text.length >= 8;
                                hasUppercase = passwordController.text
                                    .contains(RegExp(r'[A-Z]'));

                                hasPasswordCoPassword =
                                    coPasswordController.text ==
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
                                    color: OwnerColors.colorPrimary,
                                    width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              hintText: 'Senha',
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
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Dimens.marginApplication),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                visibileTwo = true;
                                hasPasswordCoPassword =
                                    coPasswordController.text ==
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
                                    color: OwnerColors.colorPrimary,
                                    width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              hintText: 'Confirmar Senha',
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
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Dimens.marginApplication),
                          Container(
                            margin:
                                EdgeInsets.only(top: Dimens.marginApplication),
                            width: double.infinity,
                            child: ElevatedButton(
                              style: Styles().styleDefaultButton,
                              onPressed: () async {
                                if (!validator.validatePassword(
                                    passwordController.text)) return;
                                if (!validator.validateCoPassword(
                                    passwordController.text,
                                    coPasswordController.text)) return;

                                setState(() {
                                  _isLoading = true;
                                });

                                await updatePasswordRequest(
                                    passwordController.text);

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
                                        strokeWidth:
                                            Dimens.buttonIndicatorStrokes,
                                      ))
                                  : Text("Atualizar senha",
                                      style: Styles().styleDefaultTextButton),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ]);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
