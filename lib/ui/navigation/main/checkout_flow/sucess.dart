import 'package:flutter/material.dart';

import '../../../../res/dimens.dart';
import '../../../../res/owner_colors.dart';
import '../../../../res/strings.dart';
import '../../../../res/styles.dart';
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
        appBar: CustomAppBar(
          title: "Compra finalizada!",
          isVisibleBackButton: true,
        ),
        body: /*FutureBuilder<List<Map<String, dynamic>>>(
              future: loadProduct(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  final response = Product.fromJson(snapshot.data![0]);

                  return */
            Stack(children: [
          SingleChildScrollView(
              child: Container(
            margin: EdgeInsets.all(Dimens.marginApplication),
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    child: Image.asset(
                  fit: BoxFit.fitWidth,
                  'images/sucess.png',
                  height: 120,
                )),
                SizedBox(height: Dimens.marginApplication),
                Text(
                  "Detalhes do pedido #0000000",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: Dimens.textSize6,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: Dimens.minMarginApplication),
                Text(
                  "Itens:",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: Dimens.textSize5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: Dimens.marginApplication),
                Text(
                  "Pagamento",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: Dimens.textSize5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: Dimens.minMarginApplication),
                Text(
                  Strings.shortLoremIpsum +
                      "\n\n" +
                      "Copie este código para pagar" +
                      "\n\n" +
                      "1. Acesse seu Internet Banking ou app de pagamentos." +
                      "\n\n" +
                      "2. Escolha pagar via Pix/QR Code" +
                      "\n\n" +
                      "3. Escaneie o seguinte código:",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: Dimens.textSize5,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  margin: EdgeInsets.all(Dimens.minMarginApplication),
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: Styles().styleAlternativeButton,
                      child: Container(
                          child: Text("Copiar chave",
                              textAlign: TextAlign.center,
                              style: Styles().styleDefaultTextButton)))),
              Container(
                  margin: EdgeInsets.all(Dimens.minMarginApplication),
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: Styles().styleDefaultButton,
                      child: Container(
                          child: Text("Ok",
                              textAlign: TextAlign.center,
                              style: Styles().styleDefaultTextButton))))
            ],
          )
        ]));
    /*     } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center( child: CircularProgressIndicator());
              },
            )));*/
  }
}
