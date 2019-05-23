class Item {
  int id;
  String nom ;
  Item();
   /*****on creer une fonction qui prendra en parametre une map de type string et dynamique*******/
  void fromMap(Map<String,dynamic> map)
  {
    this.id = map['id'];
    this.nom = map['nom'];
  }

  /******retourne un map****/
  Map<String, dynamic> toMap() {
     Map<String , dynamic> map = {
       'nom': this.nom
     } ;
     if(id != null)
       {
        map['id'] = this.id ;
       }
       return map;
  }
}