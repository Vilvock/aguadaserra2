import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
import '../../../../components/alert_dialog_address_form.dart';
import '../../../../components/alert_dialog_generic.dart';
import '../../../../components/custom_app_bar.dart';
import '../../../../components/progress_hud.dart';

class UserAddresses extends StatefulWidget {
  const UserAddresses({Key? key}) : super(key: key);

  @override
  State<UserAddresses> createState() => _UserAddresses();
}

class _UserAddresses extends State<UserAddresses> {
  bool _isLoading = false;

  @override
  void initState() {
    Preferences.init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final postRequest = PostRequest();

  Future<List<Map<String, dynamic>>> listAddresses() async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.LIST_ADDRESSES, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> saveAddress(
      String nameAddress,
      String name,
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
        "estado": State,
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

      if (response.status == "01") {
        setState(() {});

        listAddresses();
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> updateAddress(
      String idAddress,
      String nameAddress,
      String name,
      String cep,
      String state,
      String city,
      String address,
      String nbh,
      String number,
      String complement) async {
    try {
      final body = {
        "id_endereco": idAddress,
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

      final json =
          await postRequest.sendPostRequest(Links.UPDATE_ADDRESS, body);
      // final parsedResponse = jsonDecode(json); // pegar um objeto so

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {});

        listAddresses();
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> deleteAddress(String idAddress) async {
    try {
      final body = {
        "id_endereco": idAddress,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.DELETE_ADDRESS, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = User.fromJson(parsedResponse);
      if (response.status == "01") {
        setState(() {});
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> findAddress(String idAddress) async {
    try {
      final body = {
        "id_endereco": idAddress,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.FIND_ADDRESS, body);

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
          title: "Meus Endereços",
          isVisibleBackButton: true,
          isVisibleAddressButton: true),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: listAddresses(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final firstItem = User.fromJson(snapshot.data![0]);

              if (firstItem.rows != 0) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final response = User.fromJson(snapshot.data![index]);
                    return InkWell(
                        onTap: () async {
                          final result = await showModalBottomSheet<dynamic>(
                              isScrollControlled: true,
                              context: context,
                              shape: Styles().styleShapeBottomSheet,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              builder: (BuildContext context) {
                                return AddressFormAlertDialog(
                                    id: response.id.toString(),
                                    name: response.nome,
                                    cep: response.cep,
                                    city: response.cidade,
                                    state: response.estado,
                                    nbh: response.bairro,
                                    address: response.endereco,
                                    number: response.numero,
                                    complement: response.complemento);
                              });
                          if (result == true) {
                            Navigator.of(context)
                                .pop();
                            // setState(() {
                            //
                            // });
                            // Navigator.popUntil(
                            //   context,
                            //   ModalRoute.withName('/ui/home'),
                            // );
                            Navigator.pushNamed(context, "/ui/user_addresses");
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                Dimens.minRadiusApplication),
                          ),
                          margin: EdgeInsets.all(Dimens.minMarginApplication),
                          child: Container(
                            padding: EdgeInsets.all(Dimens.paddingApplication),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible: response.id.toString() ==
                                            Preferences.getDefaultAddress()
                                                .toString(),
                                        child: Text(
                                          "Endereço selecionado",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: Dimens.textSize4,
                                            fontWeight: FontWeight.bold,
                                            color: OwnerColors.colorPrimaryDark,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: Dimens.minMarginApplication),
                                      Text(
                                        response.nome,
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: Dimens.textSize5,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                          height: Dimens.minMarginApplication),
                                      Text(
                                        response.endereco_completo,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize5,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                          height: Dimens.minMarginApplication),
                                      Styles().div_horizontal,
                                      SizedBox(
                                          height: Dimens.minMarginApplication),
                                      Visibility(
                                        visible: response.id.toString() !=
                                            Preferences.getDefaultAddress()
                                                .toString(),
                                        child: GestureDetector(
                                          onTap: () async {
                                            await Preferences.init();
                                            await Preferences.setDefaultAddress(
                                                response.id.toString());

                                            setState(() {});
                                          },
                                          child: Text("Definir endereço padrão",
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: Dimens.textSize4,
                                                fontWeight: FontWeight.bold,
                                                color: OwnerColors.colorPrimary,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                    visible: response.id.toString() !=
                                        Preferences.getDefaultAddress()
                                            .toString(),
                                    child: Align(
                                        alignment: AlignmentDirectional.topEnd,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            showModalBottomSheet<dynamic>(
                                              isScrollControlled: true,
                                              context: context,
                                              shape: Styles()
                                                  .styleShapeBottomSheet,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              builder: (BuildContext context) {
                                                return GenericAlertDialog(
                                                    title: Strings.attention,
                                                    content:
                                                        "Tem certeza que deseja remover este endereço salvo?",
                                                    btnBack: TextButton(
                                                        child: Text(
                                                          Strings.no,
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }),
                                                    btnConfirm: TextButton(
                                                        child:
                                                            Text(Strings.yes),
                                                        onPressed: () {
                                                          deleteAddress(response
                                                              .id
                                                              .toString());
                                                          Navigator.of(context)
                                                              .pop();
                                                        }));
                                              },
                                            );
                                          },
                                        ))),
                              ],
                            ),
                          ),
                        ));
                  },
                );
              } else {
                return Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Lottie.network(
                                  height: 160,
                                  'https://assets3.lottiefiles.com/private_files/lf30_cgfdhxgx.json')),
                          SizedBox(height: Dimens.marginApplication),
                          Text(
                            Strings.empty_list,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: Dimens.textSize5,
                              color: Colors.black,
                            ),
                          ),
                        ]));
              }
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
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
