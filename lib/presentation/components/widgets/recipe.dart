import 'package:cookbook_ia/core/setting.dart';
import 'package:cookbook_ia/data/models/requests/recipe_request.dart';
import 'package:cookbook_ia/data/models/responses/recette_response.dart';
import 'package:cookbook_ia/domain/entities/message.dart';
import 'package:cookbook_ia/presentation/components/view_models/app_view_model.dart';
import 'package:cookbook_ia/presentation/components/widgets/bouton.dart';
import 'package:cookbook_ia/presentation/components/widgets/item_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progress_dialog_fork/progress_dialog_fork.dart';
import 'package:share_plus/share_plus.dart';

class Recipe extends HookConsumerWidget {

  final RecetteResponse recette;

  const Recipe({super.key, required this.recette});

  _share() {
    Share.share(recette.valueToShare(), subject: recette.name);
  }

  _save(BuildContext context, WidgetRef ref) async {

      final ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible:false);
      pr.style(message: AppLocalizations.of(context)!.wait_title);
    
      await pr.show();

      RecipeRequest recipeRequest = RecipeRequest(
        name: recette.name,
        ingredients: recette.ingredients,
        instructions: recette.instructions
      );

      Future<Message> retour = ref.read(appViewModelProvider).setRecipe(recipeRequest);
      retour.then((result) {
        
        pr.hide().then((isHidden) {
          print(isHidden);
        });


      Fluttertoast.showToast(
                  msg: Setting.getDynamicMessage(result.message, context),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

      }).catchError((e) {

                  pr.hide().then((isHidden) {
                      print(isHidden);
                    });

                  Fluttertoast.showToast(
                  msg: Setting.getDynamicMessage(e.message, context),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
      });

  }

  @override
  Widget build(BuildContext context,ref) {

      return   SingleChildScrollView(
              child:  Padding(
              padding: const EdgeInsets.all(2.0),
              child:  Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Setting.white,
                  border: Border.all(color: Setting.white),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Column(
                  children: <Widget>[

                       const SizedBox(height: 20,),

                       Padding(
                         padding: const EdgeInsets.only(top: 2, left: 5, right: 5, bottom:10),
                         child: Align(alignment: Alignment.centerLeft, child: Text(recette.name, style: const TextStyle( color: Colors.black,fontFamily: 'Candara', fontWeight: FontWeight.bold, fontSize: 20.0),textAlign: TextAlign.left,)),
                        ) ,

                        const SizedBox(height: 10,),

                        Padding(padding: const EdgeInsets.only(top:5, left: 5, right: 5, bottom: 0),
                          child:  Align(alignment: Alignment.centerLeft, child : Padding(padding: const EdgeInsets.only(left: 5), child : Text(AppLocalizations.of(context)!.txt_recipe1, style: TextStyle(color: Setting.marron,  fontSize: 18, fontFamily: 'Candara', fontWeight: FontWeight.bold),textAlign: TextAlign.left,)))),

                        Padding(padding: const EdgeInsets.only(top:2, left: 5, right: 10, bottom: 10),
                          child:  Align(alignment: Alignment.centerLeft, child : Padding(padding: const EdgeInsets.only(left: 5), child :  SizedBox(width: 60, height: 5, child:  DecoratedBox(decoration:  BoxDecoration(color: Setting.patientColor),)),)),),

                        const SizedBox(height: 10,),

                        Column(children: recette.ingredients.map((e) => ItemLine(item: e,)).toList(),),

                        const SizedBox(height: 10,),

                        Padding(padding: const EdgeInsets.only(top:5, left: 5, right: 5, bottom: 0),
                          child:  Align(alignment: Alignment.centerLeft, child : Padding(padding: const EdgeInsets.only(left: 5), child : Text(AppLocalizations.of(context)!.txt_recipe2, style: TextStyle(color: Setting.marron,  fontSize: 18, fontFamily: 'Candara', fontWeight: FontWeight.bold),textAlign: TextAlign.left,)))),

                        Padding(padding: const EdgeInsets.only(top:2, left: 5, right: 10, bottom: 10),
                          child:  Align(alignment: Alignment.centerLeft, child : Padding(padding: const EdgeInsets.only(left: 5), child :  SizedBox(width: 60, height: 5, child:  DecoratedBox(decoration:  BoxDecoration(color: Setting.patientColor),)),)),),

                        const SizedBox(height: 10,),

                        Column(children: recette.instructions.map((e) => ItemLine(item: e,)).toList(),),

                        const SizedBox(height: 10,),


                       Row(children: [
                          Expanded(flex: 1, child:  Bouton(background: Setting.patientColor, couleur: Setting.white, onTap:() { _save(context, ref); } , texte: AppLocalizations.of(context)!.txt_backup,),),
                          Expanded(flex: 1, child:  Bouton(background: Setting.vertColor, couleur: Setting.white, onTap: _share, texte: AppLocalizations.of(context)!.txt_share,),)
                       ],),


                        const SizedBox(height: 10,),

                        

                  ],),
              )
              
      ));

  }  


}