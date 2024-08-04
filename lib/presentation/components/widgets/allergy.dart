import 'package:cookbook_ia/core/setting.dart';
import 'package:cookbook_ia/data/models/responses/allergy_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Allergy extends StatelessWidget {

  final AllergyResponse allergie;

  const Allergy({super.key, required this.allergie});

  @override
  Widget build(BuildContext context) {

      return Padding(
              padding: const EdgeInsets.all(2.0),
              child:  Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Setting.white,
                  border: Border.all(color: Setting.primaryColor),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Column(
                  children: <Widget>[

                       const SizedBox(height: 20,),

                      Row(children: [
                        Expanded(flex: 1, child:   Padding(
                         padding: const EdgeInsets.only(top: 2, left: 5, right: 5, bottom:10),
                         child: Align(alignment: Alignment.centerLeft, child: Text(AppLocalizations.of(context)!.txt_aliment, style: const TextStyle( color: Setting.marron,fontFamily: 'Candara', fontWeight: FontWeight.bold, fontSize: 18.0),textAlign: TextAlign.left,)),
                        )),

                        Expanded(flex: 2, child:  Padding(
                         padding: const EdgeInsets.only(top: 2, left: 5, right: 5, bottom:10),
                         child: Align(alignment: Alignment.centerLeft, child: Text(allergie.name, style: const TextStyle( color: Colors.black,fontFamily: 'Candara', fontWeight: FontWeight.normal, fontSize: 18.0),textAlign: TextAlign.left,)),
                        ))
                       ],),

                      Row(children: [
                        Expanded(flex: 2, child:   Padding(
                         padding: const EdgeInsets.only(top: 2, left: 5, right: 5, bottom:10),
                         child: Align(alignment: Alignment.centerLeft, child: Text(AppLocalizations.of(context)!.txt_prob, style: const TextStyle( color: Setting.marron,fontFamily: 'Candara', fontWeight: FontWeight.bold, fontSize: 18.0),textAlign: TextAlign.left,)),
                        )),

                        Expanded(flex: 1, child:  Padding(
                         padding: const EdgeInsets.only(top: 2, left: 5, right: 5, bottom:10),
                         child: Align(alignment: Alignment.centerLeft, child: Text(allergie.percent, style: const TextStyle( color: Colors.black,fontFamily: 'Candara', fontWeight: FontWeight.normal, fontSize: 18.0),textAlign: TextAlign.left,)),
                        ))
                       ],),

                  ],),
              )
              
      );

  }  


}