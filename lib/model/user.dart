
import 'global_ws_model.dart';

class User extends GlobalWSModel{
  final String nome;
  final String email;
  final String documento;
  final String celular;
  final String avatar;

  User({
    required this.nome,
    required this.email,
    required this.documento,
    required this.celular,
    required this.avatar, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nome: json['nome'],
      email: json['email'],
      documento: json['documento'],
      celular: json['celular'],
      avatar: json['avatar'],
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
      'documento': documento,
      'celular': celular,
      'avatar': avatar,
      'status': status,
      'msg': msg,
      'id': id,
      'rows': rows,
    };
  }
}