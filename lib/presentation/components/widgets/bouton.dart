import 'package:flutter/material.dart';

class Bouton extends StatelessWidget {

final String texte;
final Color background;
final Color couleur;
final VoidCallback onTap;

  const Bouton({
    required this.texte,
    required this.couleur,
    required this.background,
    required this.onTap
  }): super();
  
  @override
  Widget build(BuildContext context) {
    
    return  Padding(
                padding: const EdgeInsets.all(0.0),
                child: new Center(
                  child: new InkWell(
                    onTap: onTap,
                    child: new Container(
                      margin: EdgeInsets.only(left : 15.0, right: 15.0, bottom: 7.0, top: 7.0),
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      decoration: new BoxDecoration(
                        color: background,
                        border: new Border.all(color: Colors.transparent, width: 2.0),
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: new Center(
                        child: new Text(
                          texte,
                          style: new TextStyle(
                              fontFamily: 'Candara',
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: couleur),
                        ),
                      ),
                    ),
                  ),
                ));
  }


}