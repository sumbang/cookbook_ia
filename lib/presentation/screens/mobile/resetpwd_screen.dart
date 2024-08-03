import 'package:cookbook_ia/core/setting.dart';
import 'package:cookbook_ia/data/models/requests/reset_request.dart';
import 'package:cookbook_ia/domain/entities/message.dart';
import 'package:cookbook_ia/presentation/components/view_models/app_view_model.dart';
import 'package:cookbook_ia/presentation/components/widgets/bouton.dart';
import 'package:cookbook_ia/presentation/components/widgets/input.dart';
import 'package:cookbook_ia/presentation/screens/mobile/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:progress_dialog_fork/progress_dialog_fork.dart';

class ResetpwdScreen extends StatefulHookConsumerWidget {

  ResetpwdScreen();

  @override
  ResetpwdScreenState createState() => new ResetpwdScreenState();
}

class ResetpwdScreenState extends ConsumerState<ResetpwdScreen> {

  final resetLoginController = TextEditingController(); 

  Future<void> _makeReset(BuildContext context,ref) async {

    if(resetLoginController.text.isEmpty) {
       Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.empty_txt,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
    }    
    
    else {

      final ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible:false);
      pr.style(message: AppLocalizations.of(context)!.wait_title);
    
      await pr.show();

      ResetRequest resetRequest = ResetRequest(
        username: resetLoginController.text.toString()
      );

      Future<Message> retour = ref.read(appViewModelProvider).setReset(resetRequest);
      retour.then((result) {
        
        pr.hide().then((isHidden) {
          print(isHidden);
        });

        resetLoginController.clear();
        
        Fluttertoast.showToast(
                  msg: Setting.getDynamicMessage(result.message, context),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

        Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HomePageScreen()),
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


  }

  @override
  Widget build(BuildContext context) {
      
      return Scaffold(
      backgroundColor: Setting.white,
             appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.txt_change_pwd,  style: TextStyle(color: Colors.white,  fontFamily: 'Candara', fontWeight: FontWeight.bold, fontSize: 18.0), ),
              backgroundColor: Setting.primaryColor,
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomePageScreen()),
                  );
                },
              ),
        ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10.0,
            ),
            Text(AppLocalizations.of(context)!.txt_reset_screen, style: TextStyle(  fontWeight: FontWeight.normal, fontSize: 15.0,  fontFamily: 'Candara', color: Setting.black), textAlign: TextAlign.center ),
             const SizedBox(
              height: 10.0,
            ),
            Input(background: Setting.gris, controller: resetLoginController, icon: const Icon(Icons.email,color: Setting.primaryColor ), label:'${AppLocalizations.of(context)!.txt_email} *', enabled: true,),
            const SizedBox(height: 10.0,),
            Bouton(background: Setting.primaryColor, couleur: Setting.white, onTap: () { _makeReset(context, ref); }, texte: AppLocalizations.of(context)!.txt_next,),
            const SizedBox(height: 30.0,), 
          ])
          ),
        )
      );
  }

}