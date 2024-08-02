import 'package:cookbook_ia/core/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AlerteAction extends StatelessWidget   {

  final String label;
  final VoidCallback onTap;

  const AlerteAction({super.key, 
    required this.label,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
       
       if(kIsWeb) {
        return  TextButton(
            onPressed: onTap,
            child: Text(label,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,fontFamily: 'Candara', color: Setting.black)),
          );
       }

       else {
        if(Platform.isIOS) {
        return  CupertinoDialogAction(
            onPressed: onTap,
            child: Text(label,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,fontFamily: 'Candara', color: Setting.black)),
          );
        }
        else {
         return  TextButton(
            onPressed: onTap,
            child: Text(label,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,fontFamily: 'Candara', color: Setting.black)),
          );
        }
       }
       }

  }