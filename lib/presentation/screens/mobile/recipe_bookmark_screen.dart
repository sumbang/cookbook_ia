import 'package:cookbook_ia/core/setting.dart';
import 'package:cookbook_ia/domain/entities/message.dart';
import 'package:cookbook_ia/domain/entities/recipe.dart';
import 'package:cookbook_ia/presentation/components/view_models/app_view_model.dart';
import 'package:cookbook_ia/presentation/components/widgets/bouton.dart';
import 'package:cookbook_ia/presentation/components/widgets/item_line.dart';
import 'package:cookbook_ia/presentation/screens/mobile/bookmarks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progress_dialog_fork/progress_dialog_fork.dart';
import 'package:share_plus/share_plus.dart';

class RecipeBookmarkScreen extends HookConsumerWidget {

  final Recipe recette;

  _share() {
    Share.share(recette.valueToShare(), subject: recette.name);
  }

  _delete(BuildContext context, WidgetRef ref) async {

    final ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible:false);
    pr.style(message: AppLocalizations.of(context)!.wait_title);
    
    await pr.show();

    Future<Message> retour = ref.read(appViewModelProvider).deleteRecipe(recette);
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

              Navigator.push(context,
                MaterialPageRoute(
                  builder: (_) => BookmarksScreen()),
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

  RecipeBookmarkScreen({super.key, required this.recette});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context,ref) {

      return  PopScope(
     canPop: false, 
      child: Scaffold( 
      backgroundColor: Setting.white,
      key: _scaffoldKey,
      appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.txt_recipe3,  style: TextStyle(color: Colors.white,  fontFamily: 'Candara', fontWeight: FontWeight.bold, fontSize: 18.0), ),
              backgroundColor: Setting.primaryColor,
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              onPressed: () { Navigator.of(_scaffoldKey.currentContext!).pop();  },
              ),
        ),
      body : SingleChildScrollView(
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
                          Expanded(flex: 1, child:  Bouton(background: Setting.marron, couleur: Setting.white, onTap:() { _delete(context, ref); } , texte: AppLocalizations.of(context)!.pic_3,),),
                          Expanded(flex: 1, child:  Bouton(background: Setting.vertColor, couleur: Setting.white, onTap: _share, texte: AppLocalizations.of(context)!.txt_share,),)
                       ],),


                        const SizedBox(height: 10,),
                        

                  ],),
              )))
              
      ));

  }  


}