import 'global_ws_model.dart';

class Cart extends GlobalWSModel{
  int qtd_atual;
  int qtd_minima;
  String valor_minimo;
  String total;
  dynamic carrinho_aberto;
  List<dynamic> itens;

  Cart({required this.valor_minimo,
    required this.total,
    required this.carrinho_aberto,
    required this.itens,
    required this.qtd_minima,
    required this.qtd_atual, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      total: json['total'],
      valor_minimo: json['valor_minimo'],
      itens: json['itens'],
      qtd_minima: json['qtd_minima'],
      qtd_atual: json['qtd_atual'],
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