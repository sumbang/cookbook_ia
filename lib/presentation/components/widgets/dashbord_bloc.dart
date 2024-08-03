import 'package:cookbook_ia/core/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class DashbordBloc extends StatelessWidget {

final String texte;
final Image image;
final VoidCallback onTap;

  const DashbordBloc({
    required this.texte,
    required this.image,
    required this.onTap
  }): super();
  
  @override
  Widget build(BuildContext context) {
       return Container(
            width: MediaQuery.of(context).size.width,
            height:  MediaQuery.of(context).size.height,
            decoration: BoxDecoration(border: Border.all(color: Setting.vertColor),  
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30)
              ),
            ),
            child: GestureDetector(
              onTap: onTap,
              child : Column(
                      children: <Widget>[
                        Flexible(
                          flex: 4,
                          child: Container(
                                      margin: EdgeInsets.all(0),
                                      padding: EdgeInsets.all(0),
                                      color: Setting.vertColor,
                                      alignment: Alignment.bottomCenter,
                                      child: ClipPath(
                                                clipper: WaveClipperOne(),
                                                child: Container(
                                                  color: Setting.vertColor,
                                                  child: image,
                                                ),
                                              )
                                    ),
                        ),
                        
                        Flexible(
                          flex: 1,
                          child:  Container(
                          child: Center(
                            child:  Text(texte,
                                      style: new TextStyle(
                                      fontFamily: 'Candara',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Setting.loginColor),
                            )
                          ),
                          ),
                        ), 
                      ],
                  )
            ),
          );
  }
  
}