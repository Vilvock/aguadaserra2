import 'global_ws_model.dart';

class SubCategory extends GlobalWSModel {
  final String nome_sub;

  SubCategory({
    required this.nome_sub,
    required super.status,
    required super.msg,
    required super.id,
    required super.rows,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      nome_sub: json['nome_sub'],
      status: json['status'],
      msg: json['msg'],
      id: json['id'],
      rows: json['rows'],
    );
  }

}
