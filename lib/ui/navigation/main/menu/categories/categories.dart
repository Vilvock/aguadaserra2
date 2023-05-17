import 'package:flutter/material.dart';

import '../../../../../res/dimens.dart';
import '../../../../../res/owner_colors.dart';
import '../../../../../res/strings.dart';
import '../../../../components/custom_app_bar.dart';
import '../../../../components/progress_hud.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _Categories();
}

class _Categories extends State<Categories> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Categorias", isVisibleBackButton: true),
      body: ProgressHUD(
        inAsyncCall: _isLoading,
        valueColor: AlwaysStoppedAnimation<Color>(OwnerColors.colorPrimary),
        child: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () =>
                      {Navigator.pushNamed(context, "/ui/subcategories")},
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Dimens.minRadiusApplication),
                    ),
                    margin: EdgeInsets.all(Dimens.minMarginApplication),
                    child: Container(
                      padding: EdgeInsets.all(Dimens.paddingApplication),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  right: Dimens.minMarginApplication),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimens.minRadiusApplication),
                                  child: Image.asset(
                                    'images/person.jpg',
                                    height: 90,
                                    width: 90,
                                  ))),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Strings.shortLoremIpsum,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize6,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: Dimens.minMarginApplication),
                                Text(
                                  Strings.longLoremIpsum,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize5,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: Dimens.marginApplication),
                                Text(
                                  "R\$ 50,00",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: Dimens.textSize6,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: Dimens.minMarginApplication),
                                Divider(
                                  color: Colors.black12,
                                  height: 2,
                                  thickness: 1.5,
                                ),
                                SizedBox(height: Dimens.minMarginApplication),
                                IntrinsicHeight(
                                    child: Row(
                                  children: [
                                    Icon(
                                        size: 20, Icons.shopping_cart_outlined),
                                    Text(
                                      "Adicionar ao carrinho",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: Dimens.textSize4,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                        width: Dimens.minMarginApplication),
                                    VerticalDivider(
                                      color: Colors.black12,
                                      width: 2,
                                      thickness: 1.5,
                                    ),
                                    SizedBox(
                                        width: Dimens.minMarginApplication),
                                    Icon(size: 20, Icons.delete_outline),
                                    Text(
                                      "Remover",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: Dimens.textSize4,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
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
