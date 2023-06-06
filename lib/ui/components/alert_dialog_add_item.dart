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
  void initState() {
    widget.quantityController.text = _quantity.toString();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
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
                Row(
                  children: [
                    Expanded(
                        child: Text(
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
                                icon: Icon(Icons.remove, color: Colors.black),
                                onPressed: () {
                                  if (int.parse(widget.quantityController.text.toString()) == 1) return;

                                  setState(() {
                                    var newQtt = int.parse(widget.quantityController.text.toString());
                                    newQtt--;
                                    widget.quantityController.text = newQtt.toString();
                                  });
                                },
                              ),
                              SizedBox(width: Dimens.minMarginApplication),
                                  Container(width: 100, child:
                                  TextField(
                                    controller: widget.quantityController,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: OwnerColors.colorPrimary, width: 1.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.grey, width: 1.0),
                                      ),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(Dimens.radiusApplication),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: Dimens.textSize5,
                                    ),
                                  )),
                              SizedBox(width: Dimens.minMarginApplication),
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.black),
                                onPressed: () {
                                  setState(() {
                                    var newQtt = int.parse(widget.quantityController.text.toString());
                                    newQtt++;
                                    widget.quantityController.text = newQtt.toString();
                                  });
                                },
                              ),
                            ])))
                      ],
                    )
                  ],
                ),
                widget.btnConfirm!
              ],
            ),
          ),
        ]);
  }
}
