import 'package:cookbook_ia/core/setting.dart';
import 'package:cookbook_ia/data/models/requests/account_request.dart';
import 'package:cookbook_ia/domain/entities/account.dart';
import 'package:cookbook_ia/domain/entities/message.dart';
import 'package:cookbook_ia/presentation/components/view_models/app_view_model.dart';
import 'package:cookbook_ia/presentation/components/widgets/bouton.dart';
import 'package:cookbook_ia/presentation/components/widgets/input.dart';
import 'package:cookbook_ia/presentation/components/widgets/textarea.dart';
import 'package:cookbook_ia/presentation/screens/mobile/dashbord_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:progress_dialog_fork/progress_dialog_fork.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulHookConsumerWidget {

  AccountScreen();

  @override
  AccountScreenState createState() => new AccountScreenState();
}

class AccountScreenState extends ConsumerState<AccountScreen> {

  final accountEmailController = TextEditingController();
  final accountNameController = TextEditingController();
  final accountAllergiesController = TextEditingController();
  final accountPreferenceController = TextEditingController();

  Future<void> saveData(BuildContext context,ref) async {

    if(accountNameController.text.isEmpty) {
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

      AccountRequest accountRequest = AccountRequest(
        username: accountEmailController.text.toString(),
        fullname: accountNameController.text.toString(),
        allergies: accountAllergiesController.text.toString(),
        preferences: accountPreferenceController.text.toString()
      );

      Future<Message> retour = ref.read(appViewModelProvider).setUpdate(accountRequest);
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

        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AccountScreen()),
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


  void initName() async {
    
    Future<Account> retour = ref.read(appViewModelProvider).getAccount();
    retour.then((result) { 
      setState(() {
        accountAllergiesController.text = result.allergies;
        accountPreferenceController.text = result.preferences;
      });
    });

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String fullname = prefs.getString("fullname") ?? "";
      String username = prefs.getString("username") ?? "";
      accountEmailController.text = username;
      accountNameController.text = fullname;
    });
     
  }


  @override
  void initState()  {
    initName();
    super.initState();
  }   

  List<String> selectedCuisines = [];

  @override
  Widget build(BuildContext context) {

      return Scaffold(
      backgroundColor: Setting.white,
             appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.txt_menu3,  style: TextStyle(color: Colors.white,  fontFamily: 'Candara', fontWeight: FontWeight.bold, fontSize: 18.0), ),
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
                    MaterialPageRoute(builder: (_) => DashbordScreen()),
                  );
                },
              ),
        ),
 body: SingleChildScrollView(
        child: Container(
            child : Padding(
                              padding: EdgeInsets.all(10),
                              child :  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Input(background: Setting.gris, controller: accountEmailController, icon: const Icon(Icons.email,color: Setting.primaryColor ), label:'${AppLocalizations.of(context)!.txt_email} *', enabled: false,),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Input(background: Setting.gris, controller: accountNameController, icon: const Icon(Icons.person,color: Setting.primaryColor ), label:'${AppLocalizations.of(context)!.txt_name} *', enabled: true,),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Textarea(background: Setting.gris, controller: accountAllergiesController, icon: const Icon(Icons.sick,color: Setting.primaryColor ), label:'${AppLocalizations.of(context)!.txt_alergies} ',),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Textarea(background: Setting.gris, controller: accountPreferenceController, icon: const Icon(Icons.sick,color: Setting.primaryColor ), label:'${AppLocalizations.of(context)!.txt_gastro} ',),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Bouton(background: Setting.primaryColor, couleur: Setting.white, onTap: () { saveData(context, ref); }, texte: AppLocalizations.of(context)!.txt_bt_save,),
                                          const SizedBox(
                                            height: 30.0,
                                          ), 
                                        ],
                                      )
                            )
          ),
        )
      );
  }

}