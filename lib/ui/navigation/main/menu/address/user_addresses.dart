import 'package:flutter/material.dart';

import '../../../../../res/dimens.dart';
import '../../../../../res/owner_colors.dart';
import '../../../../../res/strings.dart';
import '../../../../components/custom_app_bar.dart';
import '../../../../components/progress_hud.dart';


class UserAddresses extends StatefulWidget {
  const UserAddresses({Key? key}) : super(key: key);

  @override
  State<UserAddresses> createState() => _UserAddresses();
}

class _UserAddresses extends State<UserAddresses> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Meus Endereços", isVisibleBackButton: true, isVisibleAddressButton: true),
      body: ProgressHUD(
        inAsyncCall: _isLoading,
        valueColor: AlwaysStoppedAnimation<Color>(OwnerColors.colorPrimary),
        child: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(Dimens.minRadiusApplication),
                ),
                margin: EdgeInsets.all(Dimens.minMarginApplication),
                child: Container(
                  padding: EdgeInsets.all(Dimens.paddingApplication),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Radio(
                            value: "radio value",
                            groupValue: "group value",
                            onChanged: (value) {
                            }),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Endereço selecionado",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize4,
                                fontWeight: FontWeight.bold,
                                color: OwnerColors.colorPrimaryDark,
                              ),
                            ),
                            SizedBox(height: Dimens.minMarginApplication),
                            Text(
                              Strings.longLoremIpsum,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize5,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: Dimens.minMarginApplication),
                            Divider(
                              color: Colors.black12,
                              height: 2,
                              thickness: 1.5,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sending Message"),
      ));
      _isLoading = false;
    });
  }
}
