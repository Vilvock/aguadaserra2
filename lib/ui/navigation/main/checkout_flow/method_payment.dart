import 'package:flutter/material.dart';

import '../../../../res/dimens.dart';
import '../../../../res/owner_colors.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/progress_hud.dart';

class MethodPayment extends StatefulWidget {
  const MethodPayment({Key? key}) : super(key: key);

  @override
  State<MethodPayment> createState() => _MethodPayment();
}

class _MethodPayment extends State<MethodPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
            title: "Escolha um Método de pagamento", isVisibleBackButton: true),
        body: Container(
            child: SingleChildScrollView(
                child: Column(children: [
          InkWell(
              onTap: () {},
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimens.minRadiusApplication),
                  ),
                  margin: EdgeInsets.all(Dimens.minMarginApplication),
                  child: Container(
                    padding: EdgeInsets.all(Dimens.minPaddingApplication),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                            child: Material(
                                borderRadius: BorderRadius.circular(
                                    Dimens.minRadiusApplication),
                                elevation: Dimens.elevationApplication,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.minRadiusApplication),
                                    child: Image.asset('images/qr_code.png',
                                        height: 70, width: 70)))),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "PIX",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize6,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: Dimens.minMarginApplication,
                            ),
                            Text(
                              "Liberação das moedas de forma instantânea.",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize4,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        )),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black38,
                            size: 20,
                          ),
                          onPressed: () => {},
                        )
                      ],
                    ),
                  ))),
          InkWell(
              onTap: () {},
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimens.minRadiusApplication),
                  ),
                  margin: EdgeInsets.all(Dimens.minMarginApplication),
                  child: Container(
                    padding: EdgeInsets.all(Dimens.minPaddingApplication),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                            child: Material(
                                borderRadius: BorderRadius.circular(
                                    Dimens.minRadiusApplication),
                                elevation: Dimens.elevationApplication,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.minRadiusApplication),
                                    child: Image.asset('images/credit_card.png',
                                        height: 70, width: 70)))),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Novo Cartão de Crédito",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize6,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: Dimens.minMarginApplication,
                            ),
                            Text(
                              "Pagamento de forma segura e instantânea.",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize4,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        )),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black38,
                            size: 20,
                          ),
                          onPressed: () => {},
                        )
                      ],
                    ),
                  ))),
          InkWell(
              onTap: () {},
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimens.minRadiusApplication),
                  ),
                  margin: EdgeInsets.all(Dimens.minMarginApplication),
                  child: Container(
                    padding: EdgeInsets.all(Dimens.minPaddingApplication),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                            child: Material(
                                borderRadius: BorderRadius.circular(
                                    Dimens.minRadiusApplication),
                                elevation: Dimens.elevationApplication,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.minRadiusApplication),
                                    child: Image.asset('images/ticket.png',
                                        height: 70, width: 70)))),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Boleto",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize6,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: Dimens.minMarginApplication,
                            ),
                            Text(
                              "Será aprovado em 1 a 2 dias úteis.",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize4,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        )),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black38,
                            size: 20,
                          ),
                          onPressed: () => {},
                        )
                      ],
                    ),
                  )))
        ]))));
  }
}
