
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../global/application_constant.dart';

class PostRequest {

  PostRequest();

  Future<String> sendPostRequest(String request, dynamic body) async {
    try {
      print(ApplicationConstant.URL_BASE + request);

      final response = await http.post(
        Uri.parse(ApplicationConstant.URL_BASE + request),

        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Falha na solicitação POST: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro durante a solicitação POST: $e');
    }
  }

  Future<String> getCepRequest(String request) async {
    try {
      print(ApplicationConstant.URL_VIA_CEP + request);

      final response = await http.get(Uri.parse(ApplicationConstant.URL_VIA_CEP + request));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Falha na solicitação GET: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro durante a solicitação GET: $e');
    }
  }
}
