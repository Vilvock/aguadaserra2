import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../res/dimens.dart';
import 'alert_dialog_address_form.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  bool isVisibleBackButton;
  bool isVisibleFavoriteButton;
  bool isVisibleAddressButton;
  bool isVisibleSearchButton;

  CustomAppBar({this.title: "", this.isVisibleBackButton = false,
    this.isVisibleFavoriteButton = false, this.isVisibleAddressButton = false, this.isVisibleSearchButton = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: _returnFavoriteIcon(this.isVisibleFavoriteButton, this.isVisibleAddressButton, this.isVisibleSearchButton, context),
      automaticallyImplyLeading: this.isVisibleBackButton,
      leading: _returnBackIcon(this.isVisibleBackButton, context),
      backgroundColor: Colors.white,
      elevation: Dimens.elevationApplication,
      titleSpacing: 0,
      title: Row(
        children: [
          // Container(
          //   margin: EdgeInsets.only(left: Dimens.minMarginApplication),
          //   child: Image.asset(
          //     'images/main_logo_2.png',
          //     height: AppBar().preferredSize.height,
          //   ),
          // ),
          Container(
            margin: EdgeInsets.only(left: Dimens.minMarginApplication),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: Dimens.textSize6,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }

  IconButton? _returnBackIcon(bool isVisible, BuildContext context) {
    if (isVisible) {
      return IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.black54),
        onPressed: () => {
          if (Navigator.of(context).canPop())
            {Navigator.of(context).pop()}
          else
            {SystemNavigator.pop()}
        },
      );
    }

    return null;
  }

  List<Widget> _returnFavoriteIcon(bool isVisibleFavoriteButton, bool isVisibleAddressButton, bool isVisibleSearchButton, BuildContext context) {

    List<Widget> _widgetList = <Widget>[];

    if (isVisibleFavoriteButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.favorite_border_outlined,
          color: Colors.black,
        ),
        onPressed: () {
          // do something
        },
      ));
    }

    if (isVisibleAddressButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.add_location_alt,
          color: Colors.black,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddressFormAlertDialog();
            },
          );
        },
      ));
    }

    if (isVisibleSearchButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.black,
        ),
        onPressed: () {

        },
      ));
    }

    return _widgetList;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
