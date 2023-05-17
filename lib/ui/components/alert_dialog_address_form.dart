import 'package:flutter/material.dart';

import '../../config/masks.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';

class AddressFormAlertDialog extends StatefulWidget {
  AddressFormAlertDialog({
    Key? key,
  });

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<AddressFormAlertDialog> createState() => _AddressFormAlertDialog();
}

class _AddressFormAlertDialog extends State<AddressFormAlertDialog> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController cepController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController nbhController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController complementController = TextEditingController();

  @override
  void dispose() {
    cepController.dispose();
    cityController.dispose();
    stateController.dispose();
    nbhController.dispose();
    addressController.dispose();
    numberController.dispose();
    complementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    TextField(
                      controller: cepController,
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
                                  color: OwnerColors.colorPrimary, width: 1.5),
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
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                OwnerColors.colorPrimary),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Adicionar",
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
            ),
          )
        ]);
  }
}
