

import 'global_ws_model.dart';

class Payment extends GlobalWSModel{
  final String nome;
  final String email;
  final String url_foto;
  final String descricao;
  final String valor;
  final String valor_frete;
  final String valor_total;
  final String status_pagamento;
  final String nome_status_pedido;

  Payment({
    required this.nome,
    required this.email,
    required this.url_foto,
    required this.descricao,
    required this.valor,
    required this.valor_frete,
    required this.valor_total,
    required this.status_pagamento,
    required this.nome_status_pedido, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      nome: json['nome'],
      email: json['email'],
      url_foto: json['url_foto'],
      descricao: json['descricao'],
      valor: json['valor'],
      valor_frete: json['valor_frete'],
      valor_total: json['valor_total'],
      status_pagamento: json['status_pagamento'],
      nome_status_pedido: json['nome_status_pedido'],
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