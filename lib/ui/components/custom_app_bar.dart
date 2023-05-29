import 'package:app/config/application_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../res/dimens.dart';
import '../../res/styles.dart';
import 'alert_dialog_address_form.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  bool isVisibleBackButton;
  bool isVisibleFavoriteButton;
  bool isVisibleAddressButton;
  bool isVisibleSearchButton;
  bool isVisibleNotificationsButton;

  CustomAppBar({this.title: "", this.isVisibleBackButton = false,
    this.isVisibleFavoriteButton = false, this.isVisibleAddressButton = false, this.isVisibleSearchButton = false, this.isVisibleNotificationsButton = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: _returnIcons(this.isVisibleFavoriteButton, this.isVisibleAddressButton, this.isVisibleSearchButton, this.isVisibleNotificationsButton, context),
      automaticallyImplyLeading: this.isVisibleBackButton,
      leading: _returnBackIcon(this.isVisibleBackButton, context),
      backgroundColor: Colors.white,
      elevation: 0,
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

  List<Widget> _returnIcons(bool isVisibleFavoriteButton, bool isVisibleAddressButton, bool isVisibleSearchButton, bool isVisibleNotificationsButton, BuildContext context) {

    List<Widget> _widgetList = <Widget>[];

    if (isVisibleFavoriteButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.favorite_border_outlined,
          color: Colors.black54,
        ),
        onPressed: () {
          // do something
        },
      ));
    }

    if (isVisibleAddressButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.add_location_alt_outlined,
          color: Colors.black54,
        ),
        onPressed: () async {

          final result = await showModalBottomSheet<dynamic>(
            isScrollControlled: true,
            context: context,
            shape: Styles().styleShapeBottomSheet,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            builder: (BuildContext context) {
              return AddressFormAlertDialog();}
          );
          if(result == true){
            Navigator.popUntil(
              context,
              ModalRoute.withName('/ui/home'),
            );
            Navigator.pushNamed(context, "/ui/user_addresses");
          }
        },
      ));
    }

    if (isVisibleSearchButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.black54,
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/ui/filter_products");
        },
      ));
    }

    if (isVisibleNotificationsButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.notifications_none,
          color: Colors.black54,
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/ui/notifications");
        },
      ));
    }

    return _widgetList;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
