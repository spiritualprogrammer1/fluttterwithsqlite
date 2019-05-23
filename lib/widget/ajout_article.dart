import 'package:flutter/material.dart';
import 'dart:io';
import '../model/Article.dart';
import '../model/databaseClient.dart';
import 'package:image_picker/image_picker.dart';

class Ajout extends StatefulWidget {
  int id;

  Ajout(this.id);

  @override
  AjoutState createState() =>  new AjoutState ();

}

class AjoutState extends State<Ajout>
{
  String image;
  String nom ;
  String magasin;
  String prix ;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("ajouter"),
        actions: <Widget>[
          new FlatButton(onPressed: ()=> ajouter(), child: new Text("Ajouter", style: new TextStyle(color: Colors.white),))
        ],
      ),
      body: new SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: new Column(
          children: <Widget>[
            new Text("Ajouter un article",textScaleFactor: 1.4,style: new TextStyle(color: Colors.red, fontStyle: FontStyle.italic)),
             new Card(
               elevation: 10.0,
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: <Widget>[
                       (image == null) ?
                       new Image.asset("image/img/img.jpg") :
                           /****l on pouvait mettre directement Image.fiel(image) pour afficher mais vu
                            * q'uon a besoin du path de l'image donc on fais new File(image)******/
                       new Image.file(new File(image)),
                   new Row(
                     mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                     children: <Widget>[
                       /**********le boutton pour la camera***************/
                       new IconButton(icon: new Icon(Icons.camera_enhance), onPressed: (()=> getImage(ImageSource.camera))),
                       /*******boutton pour la gallerie*************/
                       new IconButton(icon: new Icon(Icons.photo_library), onPressed: (()=>getImage(ImageSource.gallery))),
                     ],
                   ),
                   /******les differents champs on a utiliser le widget creer textField *********/
                   textField(TypeTextField.nom, "Nom de l article") ,
                   textField(TypeTextField.prix, "Prix "),
                   textField(TypeTextField.magasin, "Magasin "),
                 ],
               ),
             )
          ],
        ),
      ),
    );
  }
  /****on creer un textFields qui aura des parametres ****/
  TextField textField(TypeTextField type, String label)
  {
    return new TextField(
      decoration: new InputDecoration(labelText: label),
      onChanged: (String string) {
        /****ici le type la dependre de ce que l'on rentre****/
        switch(type)
        {
          case TypeTextField.nom :
            nom = string ;
            break ;
          case TypeTextField.prix :
            prix = string ;
            break ;
          case TypeTextField.magasin :
            magasin = string ;
            break ;
        }
      },
    ) ;
  }

  /********Fonction ajouter*****/
  void ajouter ()
  {
    if(nom != null)
      {
        Map<String, dynamic> map = { 'nom': nom , 'item': widget.id } ;
        if(magasin != null)
        {
          map['magasin'] = magasin;
        }
        if(prix != null)
        {
          map['prix'] = prix;
        }
        if(image != null)
        {
          map['image'] = image;
        }

        Article article = new Article() ;
        article.fromMap(map);
        DatabaseClient().upinserArticle(article).then((value) {
          /**********on remet a null tous les donnees************/
           image = null;
           nom =  null;
           magasin = null;
           prix = null;
           Navigator.pop(context);
        }) ;
      }
  }
/************le fonction pour le choix d'image ***********/
  Future getImage(ImageSource source) async {
    /******on pique une image ici********/
    var nouvelleIMage = await ImagePicker.pickImage(source: source) ;
    setState (()  {
      image  = nouvelleIMage.path ;
    }) ;
  }
}


enum TypeTextField {
  nom  , prix , magasin
}