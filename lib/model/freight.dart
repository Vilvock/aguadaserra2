import 'global_ws_model.dart';

class Freight extends GlobalWSModel{

  String valor_minimo;
  String total;

  Freight({required this.valor_minimo, required this.total, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Freight.fromJson(Map<String, dynamic> json) {
    return Freight(
      total: json['total'],
      valor_minimo: json['valor_minimo'],
      status: json['status'],
      msg: json['msg'],
      id: json['id'],
      rows: json['rows'],
    );
  }

}