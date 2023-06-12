import 'package:flutter/material.dart';

import '../../res/dimens.dart';
import '../../res/owner_colors.dart';

class ChangeQuantityAlertDialog extends StatefulWidget {
  Container? btnConfirm;
  TextEditingController quantityController;

  ChangeQuantityAlertDialog({
    Key? key,
    this.btnConfirm,
    required this.quantityController,
  });

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<ChangeQuantityAlertDialog> createState() => _ChangeQuantityAlertDialogState();
}

class _ChangeQuantityAlertDialogState extends State<ChangeQuantityAlertDialog> {
  // int _quantity = 1;

  @override
  void initState() {
    // widget.quantityController.text = _quantity.toString();
    super.initState();
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
               TextField(
                    controller: widget!.quantityController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: OwnerColors.colorPrimary, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      hintText: 'Quantidade',
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

                widget.btnConfirm!
              ],
            ),
          ),
        ]);
  }
}
