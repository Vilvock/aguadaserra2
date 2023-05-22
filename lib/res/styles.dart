import 'dart:ui';

import 'package:flutter/material.dart';

import 'dimens.dart';
import 'owner_colors.dart';

class Styles {

  var styleDefaultButton = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(
        EdgeInsets.all(Dimens.buttonPaddingApplication)),
    backgroundColor: MaterialStateProperty.all(OwnerColors.colorPrimary),
  );

  var styleDefaultTextButton = TextStyle(
      fontFamily: 'Inter',
      fontSize: Dimens.textSize8,
      color: Colors.white,
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.none);

  var styleTitleText = TextStyle(
    fontFamily: 'Inter',
    fontSize: Dimens.textSize8,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  var styleDescriptionText = TextStyle(
    fontFamily: 'Inter',
    fontSize: Dimens.textSize6,
    color: Colors.black,
  );

  var div_horizontal = Divider(
    color: Colors.black12,
    height: 2,
    thickness: 1.5,
    indent: Dimens.minMarginApplication,
    endIndent: Dimens.minMarginApplication,
  );

  var div_vertical = VerticalDivider(
    color: Colors.black12,
    width: 2,
    thickness: 1.5,
  );
}
