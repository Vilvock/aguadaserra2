import 'package:flutter/material.dart';

import '../../../../res/owner_colors.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/progress_hud.dart';

class Sucess extends StatefulWidget {
  const Sucess({Key? key}) : super(key: key);

  @override
  State<Sucess> createState() => _Sucess();
}

class _Sucess extends State<Sucess> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar:
        CustomAppBar(title: "Sucesso", isVisibleBackButton: false),
        body: ProgressHUD(
            inAsyncCall: _isLoading,
            valueColor: AlwaysStoppedAnimation<Color>(OwnerColors.colorPrimary),
            child:
            RefreshIndicator(onRefresh: _pullRefresh, child: Container())));
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;

      _isLoading = false;
    });
  }
}
