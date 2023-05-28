

import 'global_ws_model.dart';

class Product extends GlobalWSModel{
  final String nome;
  final String email;
  final String url_foto;
  final String descricao;
  final String valor;
  final String url;
  List<dynamic> galeria_fotos;
  final String nome_categoria;

  Product({
    required this.nome,
    required this.email,
    required this.url_foto,
    required this.descricao,
    required this.valor,
    required this.galeria_fotos,
    required this.url,
    required this.nome_categoria, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      nome: json['nome'],
      email: json['email'],
      url_foto: json['url_foto'],
      descricao: json['descricao'],
      valor: json['valor'],
      galeria_fotos: json['galeria_fotos'],
      url: json['url'],
      nome_categoria: json['nome_categoria'],
      status: json['status'],
      msg: json['msg'],
      id: json['id'],
      rows: json['rows'],
    );
  }
}