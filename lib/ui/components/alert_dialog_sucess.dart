import 'package:flutter/material.dart';

import '../../res/dimens.dart';

class SucessAlertDialog extends StatefulWidget {
  Container btnConfirm;
  String? content;

  SucessAlertDialog({
    Key? key,
    required this.btnConfirm,
    this.content,
  });

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<SucessAlertDialog> createState() => _SucessAlertDialogState();
}

class _SucessAlertDialogState extends State<SucessAlertDialog> {
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
                        child: Image.asset(
                          fit: BoxFit.fitWidth,
                          'images/admin.png',
                          height: 100,
                        )),
                    SizedBox(height: Dimens.marginApplication),
                    Text(
                      widget.content!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: Dimens.textSize5,
                          fontFamily: 'Inter',
                          color: Colors.black),
                    ),
                    widget.btnConfirm,
                  ],
                ),
              ),
            ),
          )
        ]);
  }
}
