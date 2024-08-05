import 'package:cookbook_ia/core/setting.dart';
import 'package:cookbook_ia/core/sizeconfig.dart';
import 'package:cookbook_ia/presentation/components/widgets/bouton.dart';
import 'package:cookbook_ia/presentation/screens/mobile/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResetSuccessScreen extends HookConsumerWidget {

  ResetSuccessScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
     return Scaffold(
      backgroundColor: Setting.white,
        appBar: AppBar(
              title: const Text( "",  style: TextStyle(color: Colors.white), ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading:  IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomePageScreen()),
                  );
                },
              ),
        ),
      body: SingleChildScrollView(child:  Container(
        margin: EdgeInsets.only(top : 10 * SizeConfig.heightMultiplier,),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(10),
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
                const SizedBox(height: 15,),
                Center(child:Icon(Icons.check,color: Setting.vertColor, size: 150, ),),
                const SizedBox(height: 10,),
                Center(child: Padding(padding: const EdgeInsets.all(10), child :  Text(
                                AppLocalizations.of(context)!.reset_sent,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18.0,
                                    fontFamily: 'Candara',
                                    height: 1.5,
                                    color: Setting.black),
                                textAlign: TextAlign.center,
                              ))
                ), 
                const SizedBox(height: 10,),  
                Bouton(background: Setting.vertColor, couleur: Setting.white, onTap: () {  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomePageScreen()),
                  ); }, texte: AppLocalizations.of(context)!.txt_next,),
                const SizedBox(
                  height: 30.0,
                ), 
             ]
          )
        )
      )
      )
     );
  }
}