import 'package:flutter/material.dart';

import '../../res/dimens.dart';

class AddItemAlertDialog extends StatefulWidget {
  Container? btnConfirm;

  AddItemAlertDialog({
    Key? key,
    this.btnConfirm,
  });

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<AddItemAlertDialog> createState() => _AddItemAlertDialogState();
}

class _AddItemAlertDialogState extends State<AddItemAlertDialog> {
  int _quantity = 1;

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

                      FloatingActionButton(
                        mini: true,
                        child: Icon(Icons.chevron_left,
                            color: Colors.black),
                        backgroundColor: Colors.white,
                        onPressed: () {
                          if (_quantity == 1) return;

                          setState(() {
                            _quantity--;
                          });
                        },
                      ),
                      SizedBox(
                          width: Dimens.minMarginApplication),
                      Text(
                        _quantity.toString(),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: Dimens.textSize5,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                          width: Dimens.minMarginApplication),
                      FloatingActionButton(
                        mini: true,
                        child: Icon(Icons.chevron_right,
                            color: Colors.black),
                        backgroundColor: Colors.white,
                        onPressed: () {

                          setState(() {
                            _quantity++;
                          });

                        },
                      ),

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
