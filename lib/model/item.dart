import 'global_ws_model.dart';

class Item extends GlobalWSModel {
  final int qtd;
  final String valor_uni;
  final String valor;
  final String nome_produto;
  final String url_foto;
  final int id_produto;
  final int id_item;
  final String categoria;

  Item({
    required this.qtd,
    required this.valor_uni,
    required this.valor,
    required this.nome_produto,
    required this.url_foto,
    required this.id_produto,
    required this.id_item,
    required this.categoria,
    required super.status,
    required super.msg,
    required super.id,
    required super.rows,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      qtd: json['qtd'],
      valor_uni: json['valor_uni'],
      valor: json['valor'],
      nome_produto: json['nome_produto'],
      url_foto: json['url_foto'],
      id_produto: json['id_produto'],
      id_item: json['id_item'],
      categoria: json['categoria'],
      status: json['status'],
      msg: json['msg'],
      id: json['id'],
      rows: json['rows'],
    );
  }

}
