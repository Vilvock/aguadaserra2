import 'package:flutter/material.dart';

import '../../res/dimens.dart';
import '../../res/owner_colors.dart';

class AddItemAlertDialog extends StatefulWidget {
  Container? btnConfirm;
  TextEditingController quantityController;


  AddItemAlertDialog({
    Key? key,
    this.btnConfirm,
    required this.quantityController,
  });

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<AddItemAlertDialog> createState() => _AddItemAlertDialogState();
}

class _AddItemAlertDialogState extends State<AddItemAlertDialog> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {

    widget.quantityController.text = _quantity.toString();

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Row( children: [
                      Expanded(child:
                      Text(
                        "Quantidade",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: Dimens.textSize5,
                          color: Colors.black,
                        ),
                      )),

                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Card(
                              elevation: 0,
                              color: OwnerColors.categoryLightGrey,
                              margin: EdgeInsets.only(
                                  top: Dimens.minMarginApplication),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimens.minRadiusApplication),
                              ),
                              child: Container(
                                  child: Row(children: [
                                    IconButton(
                                      icon: Icon(
                                          Icons.remove,
                                          color: Colors.black),
                                      onPressed: () {
                                        if (_quantity == 1) return;

                                        setState(() {
                                          _quantity--;
                                          widget.quantityController.text = _quantity.toString();
                                        });
                                      },
                                    ),
                                    SizedBox(
                                        width: Dimens
                                            .minMarginApplication),
                                    Text(
                                      _quantity.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: Dimens.textSize5,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                        width: Dimens
                                            .minMarginApplication),
                                    IconButton(
                                      icon: Icon(
                                          Icons.add,
                                          color: Colors.black),
                                      onPressed: () {
                                        setState(() {
                                          _quantity++;
                                          widget.quantityController.text = _quantity.toString();
                                        });
                                      },
                                    ),
                                  ])))
                        ],
                      )

                    ],),

                     widget.btnConfirm!

                  ],
                ),
              ),
            ),
          )
        ]);
  }
}
