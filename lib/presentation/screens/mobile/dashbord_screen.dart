import 'package:cookbook_ia/core/setting.dart';
import 'package:cookbook_ia/core/sizeconfig.dart';
import 'package:cookbook_ia/domain/entities/message.dart';
import 'package:cookbook_ia/presentation/components/view_models/app_view_model.dart';
import 'package:cookbook_ia/presentation/components/widgets/alerte_action.dart';
import 'package:cookbook_ia/presentation/components/widgets/alerte_box.dart';
import 'package:cookbook_ia/presentation/components/widgets/dashbord_bloc.dart';
import 'package:cookbook_ia/presentation/screens/mobile/account_screen.dart';
import 'package:cookbook_ia/presentation/screens/mobile/ask_recipe_screen.dart';
import 'package:cookbook_ia/presentation/screens/mobile/bookmarks_screen.dart';
import 'package:cookbook_ia/presentation/screens/mobile/find_recipe_screen.dart';
import 'package:cookbook_ia/presentation/screens/mobile/generate_recipe_screen.dart';
import 'package:cookbook_ia/presentation/screens/mobile/homepage_screen.dart';
import 'package:cookbook_ia/presentation/screens/mobile/search_allergies_screen.dart';
import 'package:features_tour/features_tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:progress_dialog_fork/progress_dialog_fork.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashbordScreen extends StatefulHookConsumerWidget {

  DashbordScreen();

  @override
  DashbordScreenState createState() => new DashbordScreenState();
}

class DashbordScreenState extends ConsumerState<DashbordScreen> {

  String name = "";

  version(BuildContext context) {

  List<AlerteAction> alertes = [];
  alertes.add(AlerteAction(label:AppLocalizations.of(context)!.ok_bt, onTap:()  
  {  
    
    Navigator.of(context, rootNavigator: true).pop('dialog'); } ));

   AlerteBox(context: context, title: AppLocalizations.of(context)!.txt_menu6,
            description: "${AppLocalizations.of(context)!.txt_menu7} - ${Setting.currenversion}",
             actions: alertes
            );
                                              
  }

  Future<void> _MakeLogout(BuildContext context,ref) async {

    final ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible:false);
    pr.style(message: AppLocalizations.of(context)!.wait_title);
    
    await pr.show();

    final prefs = await SharedPreferences.getInstance();

    Future<Message> retour = ref.read(appViewModelProvider).setLogout();

    retour.then((result) {

        pr.hide().then((isHidden) {
          print(isHidden);
        });

        prefs.remove('activated');
        prefs.remove('username');
        prefs.remove('fullname');
        prefs.remove('id');
        prefs.remove("tour");

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePageScreen()));

    }).catchError((e) {
            
        pr.hide().then((isHidden) {
            print(isHidden);
        });

        Fluttertoast.showToast(
                  msg:  Setting.getDynamicMessage(e.message, context),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
      });    



  }

  deconnexion(BuildContext context, ref) {

    List<AlerteAction> alertes = [];
    alertes.add(AlerteAction(label:AppLocalizations.of(context)!.logout_op2, onTap:()  {  Navigator.of(context, rootNavigator: true).pop('dialog'); } ));
    alertes.add(AlerteAction(label:AppLocalizations.of(context)!.logout_op1, onTap:() { Navigator.of(context, rootNavigator: true).pop('dialog');  _MakeLogout(context,ref); }));

    AlerteBox(
      context: context,
      title: AppLocalizations.of(context)!.logout_title,
      description: AppLocalizations.of(context)!.logout_desc,
      actions: alertes
    );

  }

  void initName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String fullname = prefs.getString("fullname") ?? "";
      if(fullname.isNotEmpty) {
        var tab = fullname.split(" ");
        name = tab[0];
      }
    });
     
  }

  final tourController = FeaturesTourController('App');

  void showFeaturesTour() async {
    final prefs = await SharedPreferences.getInstance();
    bool showed = await prefs.getBool("tour") ?? false;
    if(!showed) {
      setState(() {
        prefs.setBool("tour", true);
      });
      tourController.start(context);
    }
  }

  @override
  void initState()  {
    initName();
    showFeaturesTour();
    super.initState();
  }   


  @override
  Widget build(BuildContext context) {
      return Scaffold(
      backgroundColor: Setting.white,
             appBar: AppBar(
              title: const Text( "",  style: TextStyle(color: Colors.black), ),
              backgroundColor: Setting.primaryColor,
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 0,
              leading: Icon(Icons.person_rounded,color: Setting.white, size: 30.0, ),
              actions: [
                 FeaturesTour(
                    controller: tourController,
                    index: 0,
                    nextConfig: NextConfig(text: AppLocalizations.of(context)!.txt_tour_bt1, textStyle: TextStyle(color: Setting.primaryColor, fontFamily: 'Candara', fontWeight: FontWeight.bold) ),
                    skipConfig: SkipConfig(text: AppLocalizations.of(context)!.txt_tour_bt4, textStyle: TextStyle(color: Setting.vertColor, fontFamily: 'Candara', fontWeight: FontWeight.bold) ),
                    doneConfig: DoneConfig (text: AppLocalizations.of(context)!.txt_tour_bt3, textStyle: TextStyle(color: Setting.primaryColor, fontFamily: 'Candara', fontWeight: FontWeight.bold) ),
                    introduce:  Text(AppLocalizations.of(context)!.txt_tour1_desc, style: TextStyle(color: Setting.white, fontFamily: 'Candara', fontWeight: FontWeight.bold),),
                    child: PopupMenuButton<String>(
                          // Callback that sets the selected popup menu item.
                          onSelected: (String item) {
                            if(item == "1") {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => BookmarksScreen()));
                            }
                            else if(item == "2") {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => AccountScreen()));
                            }
                            else if(item == "3") {
                              version(context);
                            }
                            else if(item == "4") {
                            deconnexion(context, ref);
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: "1",
                              child: Text(AppLocalizations.of(context)!.txt_menu2, style: const TextStyle(fontFamily: 'Candara')),
                            ),
                            PopupMenuItem<String>(
                              value: "2",
                              child: Text(AppLocalizations.of(context)!.txt_menu3, style: const TextStyle(fontFamily: 'Candara')),
                            ),
                            PopupMenuItem<String>(
                              value: "3",
                              child: Text(AppLocalizations.of(context)!.txt_menu4, style: const TextStyle(fontFamily: 'Candara')),
                            ),
                            PopupMenuItem<String>(
                              value: "4",
                              child: Text(AppLocalizations.of(context)!.txt_menu5, style: const TextStyle(fontFamily: 'Candara')),
                            )
                          ],
                        ),
                  ),
                
              ],
        ),
      body: Stack(
        children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.only(top : 13 * SizeConfig.heightMultiplier, bottom: 50),
                child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    childAspectRatio: (3/4),
                    crossAxisCount: 2,
                    children: <Widget>[

                      FeaturesTour(
                        controller: tourController,
                        index: 1,
                        nextConfig: NextConfig(text: AppLocalizations.of(context)!.txt_tour_bt1, textStyle: TextStyle(color: Setting.primaryColor, fontFamily: 'Candara', fontWeight: FontWeight.bold) ),
                        skipConfig: SkipConfig(text: AppLocalizations.of(context)!.txt_tour_bt4, textStyle: TextStyle(color: Setting.vertColor, fontFamily: 'Candara', fontWeight: FontWeight.bold) ),
                        doneConfig: DoneConfig (text: AppLocalizations.of(context)!.txt_tour_bt3, textStyle: TextStyle(color: Setting.primaryColor, fontFamily: 'Candara', fontWeight: FontWeight.bold) ),
                        introduce:  Text(AppLocalizations.of(context)!.txt_tour2_desc, style: TextStyle(color: Setting.white, fontFamily: 'Candara', fontWeight: FontWeight.bold),),
                        child: DashbordBloc(texte: AppLocalizations.of(context)!.txt_bloc1, image: Image.asset('img/img1.png',fit: BoxFit.contain,alignment: Alignment.topCenter), onTap: () { Navigator.push(context,MaterialPageRoute(builder: (_) => FindRecipeScreen()), ); },),
                      ),

                      FeaturesTour(
                        controller: tourController,
                        index: 2,
                        nextConfig: NextConfig(text: AppLocalizations.of(context)!.txt_tour_bt1, textStyle: TextStyle(color: Setting.primaryColor, fontFamily: 'Candara', fontWeight: FontWeight.bold) ),
                        skipConfig: SkipConfig(text: AppLocalizations.of(context)!.txt_tour_bt4, textStyle: TextStyle(color: Setting.vertColor, fontFamily: 'Candara', fontWeight: FontWeight.bold) ),
                        doneConfig: DoneConfig (text: AppLocalizations.of(context)!.txt_tour_bt3, textStyle: TextStyle(color: Setting.primaryColor, fontFamily: 'Candara', fontWeight: FontWeight.bold) ),
                        introduce: Text(AppLocalizations.of(context)!.txt_tour3_desc, style: TextStyle(color: Setting.white, fontFamily: 'Candara', fontWeight: FontWeight.bold),),
                        child: DashbordBloc(texte: AppLocalizations.of(context)!.txt_bloc2, image: Image.asset('img/img2.png',fit: BoxFit.contain,alignment: Alignment.topCenter), onTap: () { Navigator.push(context,MaterialPageRoute(builder: (_) => AskRecipeScreen()), ); },),
                      ),

                      FeaturesTour(
                        controller: tourController,
                        index: 3,
                        nextConfig: NextConfig(text: AppLocalizations.of(context)!.txt_tour_bt1, textStyle: TextStyle(color: Setting.primaryColor, fontFamily: 'Candara', fontWeight: FontWeight.bold) ),
                        skipConfig: SkipConfig(text: AppLocalizations.of(context)!.txt_tour_bt4, textStyle: TextStyle(color: Setting.vertColor, fontFamily: 'Candara', fontWeight: FontWeight.bold) ),
                        doneConfig: DoneConfig (text: AppLocalizations.of(context)!.txt_tour_bt3, textStyle: TextStyle(color: Setting.primaryColor, fontFamily: 'Candara', fontWeight: FontWeight.bold) ),
                        introduce:  Text(AppLocalizations.of(context)!.txt_tour4_desc, style: TextStyle(color: Setting.white, fontFamily: 'Candara', fontWeight: FontWeight.bold),),
                        child: DashbordBloc(texte: AppLocalizations.of(context)!.txt_bloc3, image: Image.asset('img/img3.png',fit: BoxFit.contain,alignment: Alignment.topCenter), onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => SearchAllergiesScreen()),  ); },),
                      ),

                      FeaturesTour(
                        controller: tourController,
                        index: 4,
                        nextConfig: NextConfig(text: AppLocalizations.of(context)!.txt_tour_bt1, textStyle: TextStyle(color: Setting.primaryColor, fontFamily: 'Candara', fontWeight: FontWeight.bold) ),
                        skipConfig: SkipConfig(text: AppLocalizations.of(context)!.txt_tour_bt4, textStyle: TextStyle(color: Setting.vertColor, fontFamily: 'Candara', fontWeight: FontWeight.bold) ),
                        doneConfig: DoneConfig (text: AppLocalizations.of(context)!.txt_tour_bt3, textStyle: TextStyle(color: Setting.primaryColor, fontFamily: 'Candara', fontWeight: FontWeight.bold) ),
                        introduce:  Text(AppLocalizations.of(context)!.txt_tour5_desc, style: TextStyle(color: Setting.white, fontFamily: 'Candara', fontWeight: FontWeight.bold),),
                        child: DashbordBloc(texte: AppLocalizations.of(context)!.txt_bloc4, image: Image.asset('img/img4.png',fit: BoxFit.contain,alignment: Alignment.topCenter), onTap: () { Navigator.push(context,MaterialPageRoute(builder: (_) => GenerateRecipeScreen()), ); },),
                      ),

                    ],
                  )
            ),

            Positioned(
              bottom: 0.0,
              child:  Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(Setting.versionName,
                                                  textAlign: TextAlign.center,
                                                  style: new TextStyle(
                                                  fontFamily: 'Candara',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12.0,
                                                  color: Setting.black),
                                            ),
                                            SizedBox(height: 20.0),
                                        ]),
                          ),
            ),

            Positioned(
                top: 0.0,
                child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ClipPath(
                                      clipper: OvalBottomBorderClipper(),
                                      child: Container(
                                        height: 12 * SizeConfig.heightMultiplier,
                                        width: MediaQuery.of(context).size.width,
                                        color: Setting.primaryColor,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(AppLocalizations.of(context)!.txt_welcome.replaceAll("user", name),
                                                  textAlign: TextAlign.center,
                                                  style: new TextStyle(
                                                  fontFamily: 'Candara',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                  color: Setting.white),
                                            ),
                                            SizedBox(height: 20.0),
                                        ]),
                                      ),
                                    )
                          ),
                        ) 
        ])
      );
  }

}