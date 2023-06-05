import 'dart:convert';

import 'package:app/res/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

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

class CreditCardAlertDialog extends StatefulWidget {

  Container? btnConfirm;
  TextEditingController nameController;
  TextEditingController cpfController;
  TextEditingController yearController;
  TextEditingController monthController;
  TextEditingController cardNumberController;
  TextEditingController securityCodeController;

  CreditCardAlertDialog({
    Key? key,
    this.btnConfirm,
    required this.nameController,
    required this.cpfController,
    required this.yearController,
    required this.monthController,
    required this.cardNumberController,
    required this.securityCodeController
  });

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<CreditCardAlertDialog> createState() => _CreditCardAlertDialog();
}

class _CreditCardAlertDialog extends State<CreditCardAlertDialog> {
  bool _isLoading = false;

  @override
  void initState() {
    widget.nameController.text = "";
    widget.cpfController.text = "";
    widget.yearController.text = "";
    widget.monthController.text = "";
    widget.cardNumberController.text = "";
    widget.securityCodeController.text = "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                Dimens.paddingApplication,
                Dimens.paddingApplication,
                Dimens.paddingApplication,
                MediaQuery.of(context).viewInsets.bottom +
                    Dimens.paddingApplication),
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
                CreditCardWidget(
                  cardHolderName: widget.nameController.text,
                  cardNumber: widget.cardNumberController.text,
                  expiryDate: widget.monthController.text + " " + widget.yearController.text,
                  cvvCode: widget.securityCodeController.text,
                  showBackView: false,
                  isHolderNameVisible: true,
                  obscureCardCvv: false,
                  onCreditCardWidgetChange:
                      (CreditCardBrand) {}, //true when you want to show cvv(back) view
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "Preencha os dados do cartão:",
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
                  controller: widget.nameController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: OwnerColors.colorPrimary, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: 'Nome completo',
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
                  controller: widget.cpfController,
                  inputFormatters: [Masks().cpfMask()],
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: OwnerColors.colorPrimary, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: 'CPF',
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
                Styles().div_horizontal,
                SizedBox(height: Dimens.marginApplication),
                TextField(
                  maxLength: 16,
                  controller: widget.cardNumberController,
                  decoration: InputDecoration(
                    counter: SizedBox(
                      width: 0,
                      height: 0,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: OwnerColors.colorPrimary, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: 'Número do cartão',
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
                        maxLength: 4,
                        controller: widget.yearController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: OwnerColors.colorPrimary, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          hintText: 'Ano de expiração',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Dimens.radiusApplication),
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
                    SizedBox(width: Dimens.marginApplication),
                    Expanded(
                      child: TextField(
                        maxLength: 2,
                        controller: widget.monthController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: OwnerColors.colorPrimary, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          hintText: 'Mês de expiração',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Dimens.radiusApplication),
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
                  maxLength: 4,
                  controller: widget.securityCodeController,
                  decoration: InputDecoration(
                      counter: SizedBox(
                        width: 0,
                        height: 0,
                      ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: OwnerColors.colorPrimary, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: 'Código de segurança',
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
                widget.btnConfirm!
              ],
            ),
          ),
        ]));
  }
}
