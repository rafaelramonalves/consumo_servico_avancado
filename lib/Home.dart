import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Map> _recuperarPreco() async{
    String url = "https://www.blockchain.com/ticker";
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _recuperarPreco(),
      //Verificar o estado da conexexão
      builder: (context, snapshot){
        String resultado;
        //Dentro do switch é obrigatório se verificar todos os estados de conexão
        switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            resultado="Carregando";
            break;
          case ConnectionState.done:
            if(snapshot.hasError){
              resultado = "Erro ao carregar os dados";
            }else{
              double valor = snapshot.data["BRL"]["buy"];
              resultado = "Preço do bitcoin:  ${valor.toString()}";
            }
            break;
          case ConnectionState.active:
        }
        return Center(
          child: Text(resultado),
        );
      },
    );
  }
}
