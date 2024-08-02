
// ignore_for_file: non_constant_identifier_names

import 'dart:io' show Platform;
import 'package:cookbook_ia/core/setting.dart';
import 'package:cookbook_ia/presentation/components/widgets/alerte_action.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Future<dynamic> AlerteBox({
  required BuildContext context,
  required String title,
  required String description,
  required List<AlerteAction> actions
}) async {

   if(kIsWeb) {

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,fontFamily: 'Candara', color: Setting.black)),
          content: Text(description,style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0,fontFamily: 'Candara',height: 1.5,  color: Setting.black)),
          actions: actions,
        ),
    );
    

   }

   else {

         
   if(Platform.isIOS)  {

    return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,fontFamily: 'Candara', color: Setting.black)),
          content: Text(description,style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0,fontFamily: 'Candara',height: 1.5,  color: Setting.black)),
          actions: actions,
        ),
    );

   }
   
   else {

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,fontFamily: 'Candara', color: Setting.black)),
          content: Text(description,style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0,fontFamily: 'Candara',height: 1.5,  color: Setting.black)),
          actions: actions,
        ),
    );

   }

   }

}