import 'package:cookbook_ia/core/setting.dart';
import 'package:cookbook_ia/data/models/responses/allergy_response.dart';
import 'package:cookbook_ia/presentation/components/widgets/allergy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IaGeneratorAllergiesScreen extends StatefulHookConsumerWidget {

  final List<AllergyResponse> allergies;
  IaGeneratorAllergiesScreen(this.allergies);

  @override
  IaGeneratorAllergiesScreenState createState() => IaGeneratorAllergiesScreenState(allergies);

}

class IaGeneratorAllergiesScreenState extends ConsumerState<IaGeneratorAllergiesScreen> {
  List<AllergyResponse> allergies;
  IaGeneratorAllergiesScreenState(this.allergies);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
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
      body :  Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child :  SingleChildScrollView(child : Padding(
                                padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
                                child:  Column(
                                  children: allergies.map((e) => Allergy(allergie: e,)).toList(),
                                ),)),
                ),
                
    ));

  }


}