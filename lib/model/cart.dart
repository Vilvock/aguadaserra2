import 'global_ws_model.dart';

class Cart extends GlobalWSModel{

  dynamic carrinho_aberto;
  List<dynamic> itens;

  Cart({required this.carrinho_aberto, required this.itens, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      itens: json['itens'],
      carrinho_aberto: json['carrinho_aberto'],
      status: json['status'],
      msg: json['msg'],
      id: json['id'],
      rows: json['rows'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'id': id,
      'rows': rows,
    };
  }
}