import 'package:flutter/material.dart';
import'../model/item.dart';
import '../model/Article.dart';
import './donnes_vides.dart' ;
import './ajout_article.dart';
import '../model/databaseClient.dart';
/*****pour les images****/
import 'dart:io';

class ItemDetail extends StatefulWidget
{
  Item item;

  ItemDetail(this.item);

  @override
  _ItemDetailState createState () => new _ItemDetailState();

}


class _ItemDetailState extends State<ItemDetail> {
  List<Article> articles ;

   /***permer d'initialiser******/
  void initState() {
    super.initState();
    /****on recupere ici l'ensemble des articles ********/
    DatabaseClient().allArticles(widget.item.id).then((liste) {
      setState(() {
        articles = liste ;
      }) ;
    }) ;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        /***********donner le nom de l item selectionner a l appbar**********/
        title: new Text(widget.item.nom),
        actions: <Widget>[
          new FlatButton(onPressed: (){
            Navigator.push(context, new MaterialPageRoute(builder: (BuildContext buildContext) {
              /*******on recupere l'id de l(item selectionner**************/
              return new Ajout(widget.item.id);
              /****on faire le then pour recuprer le resultat de maniere asynchrone , autnomatiquement apres l'ajout de l article********/
            })).then((value) {
              print("je suis de retour") ;
              DatabaseClient().allArticles(widget.item.id).then((liste) {
                setState(() {
                  articles = liste ;
                }) ;
              }) ;
            });
          }, child: new Text("Ajouter", style: new TextStyle(color: Colors.white),))
        ],
      ),
      body: (articles == null || articles.length == 0) ?
       new Center(
         child: new Text("Aucune donner exsite merci."),
       ) :
          new GridView.builder(
            /*************************/
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
               itemCount: articles.length,
              itemBuilder: (context , i) {
                /***on recupere un artcile en fonction de l'item****/
                Article article = articles[i];
               return  new Card(
                 child: new Column(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: <Widget>[
                     new Text(article.nom , textScaleFactor: 1.5,),
                     new Container(
                       height: MediaQuery.of(context).size.height /2.5,
                       child:   (article.image == null) ?
                       new Image.asset("image/img/img.jpg")
                           : new Image.file(new File(article.image)) ,
                     ),
                     new Text((article.prix == null) ? " Aucun  prix renseigner": " Prix : ${article.prix}"),
                     new Text((article.magasin == null) ? " Aucun  prix renseigner": " Prix : ${article.magasin}")

                   ],
                 ),
               ) ;

              })
      ,
    );
  }

}