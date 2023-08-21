import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:apptestewillians/services/http_req.dart';

import '../models/Login.dart';
import '../services/background_service.dart';
import '../services/data_keeped.dart';
import '../services/if_logged.dart';
import 'HomePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apptestewillians/pages/DriveHomePage.dart';
import 'package:mask_shifter/mask_shifter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PrivacyPolicyScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var cpfcnpj = new TextEditingController();
  var senha = new TextEditingController();
  Color cor = Color.fromARGB(255, 0, 100, 220);
  bool tipoUsuario = true;
  bool motorista = true;

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("ERRO CPF/CNPJ"),
          content: new Text("Favor digitar CPF e senha valido!"),
          actions: <Widget>[
            new TextButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      Future<bool> teste = BackGroound.verificarLocalizacaoAparelho();

      teste.then((value) {
        if (!value) {
          BackGroound.stop();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              (Route<dynamic> route) => false);
        } else {
          IfLogged login = IfLogged();
          login.verificarSeLogado(context);
        }
      });
    } catch (e) {
      print(e.toString());
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height, //para altura
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/imgfundoGertran01.jpeg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height, //para altura
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Center(
                      child: Container(
                          width: 200,
                          height: 150,
                          child: Image.asset('assets/images/logogertran.png')),
                    ),
                  ),
                  Divider(),
                  if (tipoUsuario == false)
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: cor, borderRadius: BorderRadius.circular(20)),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            tipoUsuario = true;
                            motorista = true;
                          });
                        },
                        child: Text(
                          'Motorista',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  Divider(),
                  Divider(),
                  if (tipoUsuario == false)
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: cor, borderRadius: BorderRadius.circular(20)),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            tipoUsuario = true;
                            motorista = false;
                          });
                        },
                        child: Text(
                          'Cliente',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  if (tipoUsuario == true)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'CPF',
                              hintText: 'Digite seu CPF'),
                          controller: this.cpfcnpj,
                          inputFormatters: [
                            MaskedTextInputFormatterShifter(
                                maskONE: "XXX.XXX.XXX-XX",
                                maskTWO: "XX.XXX.XXX/XXXX-XX"),
                          ],
                          keyboardType: TextInputType.number),
                    ),
                  if (tipoUsuario == true)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      child: TextField(
                          style: TextStyle(color: Colors.black),
                          obscureText: true,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              labelText: 'Senha',
                              hintText: 'Digite sua senha'),
                          controller: this.senha,
                          keyboardType: TextInputType.number),
                    ),
                  if (tipoUsuario == true)
                    TextButton(
                      onPressed: () {
                        //TODO FORGOT PASSWORD SCREEN GOES HERE
                      },
                      child: Text(
                        'Não sabe a Senha? Favor entrar em contato com a Gertran',
                        style: TextStyle(color: cor, fontSize: 10),
                      ),
                    ),
                  Divider(),
                  if (tipoUsuario == true)
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: cor, borderRadius: BorderRadius.circular(20)),
                      child: TextButton(
                        onPressed: () {
                          if (cpfcnpj.text.length == 14 ||
                              cpfcnpj.text.length == 18) {
                            var filter = (((cpfcnpj.text.replaceAll(".", ""))
                                        .replaceAll(".", ""))
                                    .replaceAll(".", ""))
                                .replaceAll("-", "");
                            final exp = RegExp(r"/");
                            if (exp.hasMatch(filter)) {
                              filter = filter.replaceAll("/", "");
                            }
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => LoginValidate(
                                        cpfcnpj: filter,
                                        senha: senha.text,
                                        motorista: motorista)),
                                (Route<dynamic> route) => false);
                          } else {
                            _showDialog();
                          }
                        },
                        child: Text(
                          'Entrar',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  Divider(),
                  // if (tipoUsuario == true)
                  //   Container(
                  //     height: 50,
                  //     width: 150,
                  //     decoration: BoxDecoration(
                  //         color: Color.fromARGB(255, 165, 33, 66),
                  //         borderRadius: BorderRadius.circular(20)),
                  //     child: TextButton(
                  //       onPressed: () {
                  //         setState(() {
                  //           tipoUsuario = false;
                  //         });
                  //       },
                  //       child: Text(
                  //         'Voltar',
                  //         style: TextStyle(color: Colors.white, fontSize: 25),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LoginValidate extends StatelessWidget {
  LoginValidate(
      {super.key,
      required this.cpfcnpj,
      required this.senha,
      required this.motorista});

  final String cpfcnpj;
  final String senha;
  final bool motorista;
  late String token = "";
  Future<Login>? futureLogin;



  void initState() {
    HttpReq httpReq = new HttpReq();
    futureLogin = httpReq.fetchLogin(cpfcnpj, senha);
  }

  @override
  Widget build(BuildContext context) {
    initState();

    void _showDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("ERRO CPF"),
            content: new Text("Favor digitar CPF  e senha valido!"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return FutureBuilder<Login>(
      future: futureLogin,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const LoginPage();
        } else if (snapshot.hasData) {
          if (motorista) {
            BackGroound.initService();

            return DriveHomePage(
              cpfcnpj: cpfcnpj,
            );
          } else {
            return HomePage(
                HomecountSM: snapshot.data!.countSM,
                Homecountchecklist: snapshot.data!.countchecklist,
                cnpj: cpfcnpj);
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}




                  /*Column( 
              mainAxisAlignment: MainAxisAlignment.end,
               children: <Widget>[
              TextButton(onPressed: (){}, child: Text('Novo usuário? Criar conta', style: TextStyle(color: Colors.white)
              ),
              ),
              ]
            ),*/