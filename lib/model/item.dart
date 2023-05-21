import 'global_ws_model.dart';

class Item extends GlobalWSModel{


  Item({required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
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