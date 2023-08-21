import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/Login.dart';
import 'data_keeped.dart';

class HttpReq {
  Future<void> fetchPosicion(
      final String latitude, final String longitude, final String token) async {
    String url = 'https://api.gertran.zayit.com.br/v1/drivers/mobile/position/';

    Map<String, String> data = {
      'latitude': latitude,
      'longitude': longitude,
      'token': token,
    };
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: data,
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('Resposta 2: ${response.body}');
      } else {
        print(response.body);
        //throw Exception('Falha para envira a posição');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Login> fetchLogin(final String cnpjcpf, final String senha) async {
    DataKeeped dataKeeped = DataKeeped();

    String url = '';
    // if (motorista) {
    url = 'https://api.gertran.zayit.com.br/v1/drivers/mobile/login/';
    // } else {
    //   url = 'https://api.gertran.zayit.com.br/v1/drivers/mobile/login/';
    // }

    Map<String, String> data = {'cpf': cnpjcpf, 'password': senha};

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: data,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        String token = json.decode(response.body)["access_token"];
        dataKeeped.saveToken('token', token);
        dataKeeped.saveToken('cpf', cnpjcpf);
        dataKeeped.saveToken('senha', senha);
      } else {
        throw Exception('Failed to load Login');
      }
      return Login.fromJson(json.decode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }
}
