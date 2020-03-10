import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'Post.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /* Future<Map> _recuperarPreco() async{
    String url = "https://www.blockchain.com/ticker";
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }*/
  String urlBase = "https://jsonplaceholder.typicode.com";

  Future<List<Post>>_recuperarPostagens() async{
    http.Response response = await http.get(urlBase+"/posts");
    var dadosJson = json.decode(response.body);
    List<Post> postagens = List();
    for(var post in dadosJson){
      Post p = Post(post["userId"],post["id"], post["title"], post["body"]);
      postagens.add(p);
    }
    return postagens;
  }
  //colocar dados na API
  _post() async{

    Post post = new Post(120,null,"Titulo","Corpo da postagem");

    //Pegar o objeto json e tranformar em String
    var corpo = json.encode({
      post.toJson()
      /*
      "userId": 1,
      "id": null, //vai ser gerado automaticamente
      "title": "Titulo",
      "body": "Corpo da postagen"
      */
    });
    http.Response response = await http.post(
      urlBase+"/posts",
      headers:{
        "Content-type": "application/json; charset=UTF-8"
      },
      body:corpo
    );
    print("Resposta: ${response.statusCode}");
    print("Resposta: ${response.body}");
  }

  //alterar dados da API utilizando todos os dados

  _put() async{
    //Pegar o objeto json e tranformar em String
    var corpo = json.encode({
      "userId": 120,
      "id": null, //vai ser gerado automaticamente
      "title": "Titulo alterado",
      "body": "Corpo da postagen alterada"
    });
    http.Response response = await http.put(
        urlBase+"/posts/2",
        headers:{
          "Content-type": "application/json; charset=UTF-8"
        },
        body:corpo
    );
    print("Resposta: ${response.statusCode}");
    print("Resposta: ${response.body}");

  }

  //Atualizar os dados sem precisar enviar todos os
  // dados. Os dados não enviados serão mantidos originalmente

  _patch() async {
    //Pegar o objeto json e tranformar em String
    var corpo = json.encode({
      "userId": 120,
      "body": "Corpo da postagen alterada"
    });
    http.Response response = await http.put(
        urlBase+"/posts/2",
        headers:{
          "Content-type": "application/json; charset=UTF-8"
        },
        body:corpo
    );
    print("Resposta: ${response.statusCode}");
    print("Resposta: ${response.body}");

  }

  //Deletar dados da API
  _delete() async{
    http.Response response = await http.delete(
      urlBase +"/posts/2"
    );
    print("Resposta: ${response.statusCode}");
    print("Resposta: ${response.body}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
         "Consumo de serviço avançado"
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("Salvar"),
                  onPressed: _post,
                ),
                RaisedButton(
                  child: Text("Atualizar"),
                  onPressed: _put,
                ),
                RaisedButton(
                  child: Text("Deletar"),
                  onPressed: _delete,
                )
              ],
            ),
            //O Expanded é necessário para dizer o tamanho do conteudo que
            // irá aparecer, sem esse tamanho o widegt não ira aparecer no fundo
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _recuperarPostagens(),
                //Verificar o estado da conexexão
                builder: (context, snapshot){
                  //Dentro do switch é obrigatório se verificar todos os estados de conexão
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    case ConnectionState.done:
                      if(snapshot.hasError){
                      }else{
                        //  double valor = snapshot.data["BRL"]["buy"];
                        // resultado = "Preço do bitcoin:  ${valor.toString()}";
                        return ListView.builder(
                            itemBuilder: (context, index ){
                              List<Post> lista = snapshot.data;
                              Post post = lista[index];
                              return ListTile(
                                title: Text(post.title),
                                subtitle: Text(post.id.toString()),
                              );
                            },
                            itemCount: snapshot.data.length);
                      }
                      break;
                    case ConnectionState.active:
                  }
                  return null;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
