

import 'global_ws_model.dart';

class Order extends GlobalWSModel{
  final String nome;
  final String email;
  final String url_foto;
  final String descricao;
  final String valor;
  final String valor_frete;
  final String valor_total;
  final String status_pagamento;
  final int id_ponto;
  final String nome_ponto;
  final String nome_status_pedido;
  final String horario_in;
  final String horario_out;

  Order({
    required this.nome,
    required this.email,
    required this.url_foto,
    required this.descricao,
    required this.valor,
    required this.valor_frete,
    required this.valor_total,
    required this.status_pagamento,
    required this.nome_status_pedido,
    required this.id_ponto,
    required this.nome_ponto,
    required this.horario_in,
    required this.horario_out, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      nome: json['nome'],
      email: json['email'],
      url_foto: json['url_foto'],
      descricao: json['descricao'],
      valor: json['valor'],
      valor_frete: json['valor_frete'],
      valor_total: json['valor_total'],
      status_pagamento: json['status_pagamento'],
      nome_status_pedido: json['nome_status_pedido'],
      id_ponto: json['id_ponto'],
      nome_ponto: json['nome_ponto'],
      horario_in: json['horario_in'],
      horario_out: json['horario_out'],
      status: json['status'],
      msg: json['msg'],
      id: json['id'],
      rows: json['rows'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'url_foto': url_foto,
      'descricao': descricao,
      'valor': valor,
      'valor_frete': valor_frete,
      'valor_total': valor_total,
      'status_pagamento': status_pagamento,
      'nome_status_pedido': nome_status_pedido,
      'status': status,
      'msg': msg,
      'id': id,
      'rows': rows,
    };
  }
}