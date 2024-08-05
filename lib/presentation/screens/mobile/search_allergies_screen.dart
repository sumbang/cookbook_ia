import 'dart:convert';
import 'dart:io';

import 'package:cookbook_ia/core/image_compress_service.dart';
import 'package:cookbook_ia/core/setting.dart';
import 'package:cookbook_ia/data/models/responses/prompt_response_allergy.dart';
import 'package:cookbook_ia/domain/entities/account.dart';
import 'package:cookbook_ia/presentation/components/view_models/app_view_model.dart';
import 'package:cookbook_ia/presentation/components/widgets/alerte_action.dart';
import 'package:cookbook_ia/presentation/components/widgets/alerte_box.dart';
import 'package:cookbook_ia/presentation/components/widgets/bouton.dart';
import 'package:cookbook_ia/presentation/components/widgets/fichier.dart';
import 'package:cookbook_ia/presentation/components/widgets/textarea.dart';
import 'package:cookbook_ia/presentation/screens/common/ia_generator_allergies_screen.dart';
import 'package:cookbook_ia/presentation/screens/mobile/dashbord_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:progress_dialog_fork/progress_dialog_fork.dart';

class SearchAllergiesScreen extends StatefulHookConsumerWidget {

  SearchAllergiesScreen();

  @override
  SearchAllergiesScreenState createState() => new SearchAllergiesScreenState();
}

class SearchAllergiesScreenState extends ConsumerState<SearchAllergiesScreen> {

  final imagepath = TextEditingController(); 
  GenerativeModel? model;
  String responseMessage = "";
  String promptRequest = "";
  final contextController = TextEditingController();
  bool detail = false;

  Future<void> ia_generotor() async {
  
    String allergies = "";
    Future<Account> retour = ref.read(appViewModelProvider).getAccount();
        await retour.then((result) { 
          setState(() {
            allergies = result.allergies;
          });
    });

    if(imagepath.text.isEmpty ) {
       Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.empty_txt,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

    } else if(detail && contextController.text.isEmpty) {

       Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.empty_txt,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
    } else if(allergies.isEmpty) {

       Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.txt_allergie_requis,
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
        pr.style(message: AppLocalizations.of(context)!.txt_wait);
        
        await pr.show();

        ImageCompressService imageCompress = ImageCompressService(file: File(imagepath.text.toString()));
        XFile imageCompress1 = await imageCompress.exec();

        final fichier =  await File(imageCompress1.path).readAsBytes();

        String request = promptRequest.replaceAll("@param_allergie",allergies);

        if(detail)  {
          request = request + " "+contextController.text.toString();
        }

        try {

            final prompt = TextPart(request);
            final imageParts = [
              DataPart('image/jpeg', fichier),
            ];
            final response = await model!.generateContent([
              Content.multi([prompt, ...imageParts])
            ]);

            if(Setting.isValidJson(response.text!)) {

                final PromptResponseAllergy promptResponse = PromptResponseAllergy.fromJson(json.decode(response.text!));

                pr.hide().then((isHidden) {
                      print(isHidden);
                });

                if(promptResponse.status == "2") {

                    List<AlerteAction> alertes = [];
                    alertes.add(AlerteAction(label:AppLocalizations.of(context)!.ok_bt, onTap:(){  Navigator.of(context, rootNavigator: true).pop('dialog'); } ));

                    AlerteBox(context: context, title: AppLocalizations.of(context)!.txt_menu6,
                      description: promptResponse.message,
                      actions: alertes
                    );
              
                } else if(promptResponse.status == "3") {

                    List<AlerteAction> alertes = [];
                    alertes.add(AlerteAction(label:AppLocalizations.of(context)!.ok_bt, onTap:(){  Navigator.of(context, rootNavigator: true).pop('dialog'); } ));

                    AlerteBox(context: context, title: AppLocalizations.of(context)!.txt_menu6,
                        description: promptResponse.message,
                        actions: alertes
                    );

                    setState(() {
                          detail = true;
                    });

                } else {

                    Navigator.push(context,
                        MaterialPageRoute(
                          builder: (_) => IaGeneratorAllergiesScreen(promptResponse.content)),
                    );

                }

            }  else {

              pr.hide().then((isHidden) {
                        print(isHidden);
              });

              List<AlerteAction> alertes = [];
              alertes.add(AlerteAction(label:AppLocalizations.of(context)!.ok_bt, onTap:(){  Navigator.of(context, rootNavigator: true).pop('dialog'); } ));

              AlerteBox(context: context, title: AppLocalizations.of(context)!.txt_menu6,
                    description: AppLocalizations.of(context)!.error_title,
                    actions: alertes
              );

        } 
    
    } catch(e) {

           pr.hide().then((isHidden) {
                      print(isHidden);
                    });

                  Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.error_title,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

        }
    }

  }

void initModel() async {
    model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: Setting.apikey, systemInstruction: Content.text(AppLocalizations.of(context)!.txt_prompt_content3), generationConfig: GenerationConfig(temperature: 0.0, responseMimeType: "application/json"  ) );
    setState(() {
      promptRequest = AppLocalizations.of(context)!.txt_prompt3;
    });
  }

  @override
  void initState()  {
    super.initState();
    Future.delayed(Duration.zero, () {
      initModel();
    }); 
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      backgroundColor: Setting.white,
             appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.txt_bloc3,  style: TextStyle(color: Colors.white,  fontFamily: 'Candara', fontWeight: FontWeight.bold, fontSize: 18.0), ),
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
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(AppLocalizations.of(context)!.txt_bloc31, style: TextStyle(  fontWeight: FontWeight.normal, fontSize: 15.0,  fontFamily: 'Candara', color: Setting.black), textAlign: TextAlign.center ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Fichier(titre: AppLocalizations.of(context)!.pic_1+" *", filepath: imagepath,),
                    const SizedBox(
                      height: 10.0,
                    ),
                    detail ? const SizedBox(
                      height: 10.0,
                    ) : Container(),
                    detail ? Textarea(background: Setting.gris, controller: contextController, icon: const Icon(Icons.edit,color: Setting.primaryColor ), label:'${AppLocalizations.of(context)!.txt_context } *',) : Container(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Bouton(background: Setting.primaryColor, couleur: Setting.white, onTap: ia_generotor, texte: AppLocalizations.of(context)!.txt_bt_search,),
                  ],
                ),
          ),
        )
      );
  }

}