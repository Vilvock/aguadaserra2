

import 'global_ws_model.dart';

class Favorite extends GlobalWSModel{
  final String nome;
  final String email;
  final String url_foto;
  final String descricao;
  final String valor;

  Favorite({
    required this.nome,
    required this.email,
    required this.url_foto,
    required this.descricao,
    required this.valor, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      nome: json['nome'],
      email: json['email'],
      url_foto: json['url_foto'],
      descricao: json['descricao'],
      valor: json['valor'],
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
      'status': status,
      'msg': msg,
      'id': id,
      'rows': rows,
    };
  }
}