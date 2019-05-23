import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import './Article.dart';

class DatabaseClient {
  Database _database ;

  Future<Database> get database async {

    if(_database != null)
      {
        return _database ;
      }
      else {
      /***creer la base de donner****/
      _database = await create() ;
      return _database ;
    }
  }

    Future create() async {
      Directory directory = await getApplicationDocumentsDirectory();
      String database_directory = join(directory.path,'database.db');
      var bdd = await openDatabase(database_directory, version: 1, onCreate: _onCreate) ;
      return bdd;
    }

    Future _onCreate(Database db, int version) async {
    /****on cree la table item***/
    await db.execute('''
    CREATE TABLE item 
    (id INTEGER PRIMARY KEY, 
    nom TEXT NOT NULL)
    ''') ;

    await db.execute('''
    CREATE TABLE article 
    (id INTEGER PRIMARY KEY, 
    nom TEXT NOT NULL,
    item INTEGER,
    prix TEXT,
    magasin TEXT,
    image TEXT
    )
    ''') ;


    }

    /*****ECRITURE DE DONNEES*****/

  Future<Item> ajoutItem(Item item) async {
   Database madatabase = await database ;
   /******faire une inseetion et retourne un id******/
   item.id = await madatabase.insert('item', item.toMap());
   return item;
  }
  /******update de données***********/
  Future<int> updateItem(Item item) async {
    Database madatabase = await database ;
    return  madatabase.update('item', item.toMap(),where: 'id = ?', whereArgs: [item.id]) ;
  }
  /***faire la mise a jour ou inserer en fonction de ce qu'on a *****/
  Future<Item> upsertItem(Item item) async {
    Database madatabase = await database ;
    if(item.id == null) {
      item.id = await madatabase.insert('item', item.toMap());
    }
    else {
      await madatabase.update('item', item.toMap(), where: 'id= ?', whereArgs: [item.id]) ;
    }
    return item ;
  }
  /****on injecte comme paramete le id et la table*****/
  Future <int> delete(int id, String table) async {
    Database madatabase = await database ;
    /************supprimer aussi les element de la table article lier a un item****************/
    await madatabase.delete('artcile', where: 'item = ?', whereArgs: [id]) ;
    return await madatabase.delete(table,where: 'id=?', whereArgs: [id]);
  }

  /*****Lecture de donnee*****/

  Future<List<Item>> allItem() async {
    Database madatabase = await database ;
    /**
     * On creer une variable resultat qui a pour type une map de type string et dynamic
     */
    List<Map<String,dynamic>> resultat = await madatabase.rawQuery("Select * FROM item") ;
    List<Item> items = [];
    /********on parcoure les resultat*******/
    resultat.forEach((map){
      Item item = new Item();
      item.fromMap(map);
      /***on ajoute les element au tableau****/
      items.add(item);
    });
    /**on retourne le tableau**/
    return items ;
  }


  /*********Fonction ajout et update Article***********/
   Future<Article> upinserArticle(Article article) async {
     Database madatabase = await database ;
     (article.id == null)?
         article.id = await madatabase.insert("article", article.toMap())
         : await madatabase.update("article", article.toMap(), where: 'id=?', whereArgs: [article.id]) ;
   }
   /************Liste des Articles**********/
          Future<List<Article>> allArticles(int item) async  {
            Database madatabase = await database ;
            /*******ici on recupere les articles qui ont un item precis avec la condition***********/
            List<Map<String, dynamic>> resultat  = await madatabase.query('article', where: 'item =  ?', whereArgs: [item]);
            List<Article> articles = [] ;
            /****on parcour l ensemblre des resultats******/
            resultat.forEach((map) {
              /***on creer un nouvel article******/
              Article article = new Article();
              /*****on ajoute dans la map*****/
              article.fromMap(map) ;
              /*****puis on ajoute au tableau*******/
              articles.add(article);
            });

            return articles ;
          }


}