import 'package:flutter/material.dart';

class DonnesVides extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(
      child: new Text("Aucune donnes n est presente",
      textScaleFactor: 2.5,
      textAlign: TextAlign.center,
      style: new TextStyle(
        color: Colors.white,
        fontStyle: FontStyle.italic
      ),
      )
    );
  }

}