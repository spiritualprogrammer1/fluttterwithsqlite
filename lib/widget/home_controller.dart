import 'package:flutter/material.dart';
import 'dart:async';
import '../model/item.dart';
import './donnes_vides.dart';
import 'package:sqflite/sqflite.dart';
import '../model/databaseClient.dart' ;
import './ItemDetail.dart';
class HomeController extends StatefulWidget {
  HomeController({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomeControllerState createState() => _MyHomeControllerState();
}

class _MyHomeControllerState extends State<HomeController> {
  int _counter = 0;
  String nouvelleListe ;
  List<Item> items;

  @override
  void initState(){
    super.initState();
    recuperer();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: <Widget>[
          new FlatButton(onPressed: (()=>ajouter(null)), child: Text("Ajouter", style: new TextStyle(color: Colors.white),))
        ],
      ),
//body: Center(
//  child: new Text("hello"),
//)
      body: (items == null || items.length ==0)
          ? new DonnesVides() :
            new ListView.builder(
            itemCount: items.length,
             itemBuilder: (context, i) {
                Item item = items[i];
                return new ListTile(
                  title: new Text(item.nom),
                  trailing: new IconButton(
                      icon: new Icon(Icons.delete),
                      onPressed: () {
                        DatabaseClient().delete(item.id, 'item').then((int){
                          print("L int recuperer est $int");
                          recuperer();
                        });
                      }),
                  leading: new IconButton(icon: new Icon(Icons.edit), onPressed: (()=> ajouter(item))),
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext buildContext) {
                         return new ItemDetail(item);
                    })) ;
                  },
                ) ;
    })
      ,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<Null> ajouter(Item item) async
  {
    await showDialog(context: context,
        barrierDismissible: false, // empecher de fermer lorsquon clique dehors
        builder: (BuildContext buildcontext) {
          return new AlertDialog(
            title: new Text("ajouter une liste souahiter"),
            content: new TextField(
              decoration: new InputDecoration(
                  labelText: "Liste :",
                  hintText :(item== null) ? "ex: mes prochains jeux videos" : item.nom
              ),
              onChanged: (String str) {
                nouvelleListe = str ;
              },
            ),
            actions: <Widget>[
              new FlatButton(onPressed: (() {
                Navigator.pop(buildcontext) ;
              }), child: Text("Annuler")) ,
              new FlatButton(onPressed: () {
                if(nouvelleListe != null)
                  {
                    if(item == null )
                      {
                        item = new Item();
                        //Ajouter le code de pouvoir
                        Map<String, dynamic> map = {'nom': nouvelleListe} ;
                        item.fromMap(map) ;
                      }
                      else {
                        item.nom = nouvelleListe ;
                    }
                    /*****on faire la mise a jour puis ou on creer un nouvelle element on execute la fonction recupere*******/
                    DatabaseClient().upsertItem(item).then((i)=> recuperer());
                    nouvelleListe = null;
                  }

                Navigator.pop(buildcontext) ;
              }, child: Text("Valider",style: new TextStyle(color: Colors.blue),))
            ],
          ) ;
        });
  }

  void recuperer ()
  {
    DatabaseClient().allItem().then((items) {
     setState(() {
       this.items = items ;
     });
    }) ;
  }
}
