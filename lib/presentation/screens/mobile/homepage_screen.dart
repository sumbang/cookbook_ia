
import 'package:cookbook_ia/core/setting.dart';
import 'package:cookbook_ia/core/sizeconfig.dart';
import 'package:cookbook_ia/data/models/requests/login_request.dart';
import 'package:cookbook_ia/data/models/requests/signup_request.dart';
import 'package:cookbook_ia/domain/entities/login.dart';
import 'package:cookbook_ia/domain/entities/message.dart';
import 'package:cookbook_ia/presentation/components/view_models/app_view_model.dart';
import 'package:cookbook_ia/presentation/components/view_models/password_view_model.dart';
import 'package:cookbook_ia/presentation/components/widgets/bouton.dart';
import 'package:cookbook_ia/presentation/components/widgets/input.dart';
import 'package:cookbook_ia/presentation/components/widgets/password.dart';
import 'package:cookbook_ia/presentation/screens/mobile/dashbord_screen.dart';
import 'package:cookbook_ia/presentation/screens/mobile/resetpwd_screen.dart';
import 'package:cookbook_ia/presentation/screens/mobile/signup_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:progress_dialog_fork/progress_dialog_fork.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageScreen extends StatefulHookConsumerWidget {

  HomePageScreen();

  @override
  HomePageScreenState createState() => new HomePageScreenState();
}

class HomePageScreenState extends ConsumerState<HomePageScreen> {

  HomePageScreenState();

  final signupLoginController = TextEditingController();
  final signupPwdController = TextEditingController();
  final signupNameController = TextEditingController();
  final signinLoginController = TextEditingController();
  final signinPwdController = TextEditingController();

  Future<void> _makeSignup(BuildContext context,ref) async {

    if(signupLoginController.text.isEmpty || signupPwdController.text.isEmpty || signupNameController.text.isEmpty) {
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

      SignupRequest signupRequest = SignupRequest(
        username: signupLoginController.text.toString(),
        password: signupPwdController.text.toString(),
        fullname: signupNameController.text.toString()
      );

      Future<Message> retour = ref.read(appViewModelProvider).setSignup(signupRequest);
      retour.then((result) {
        
        pr.hide().then((isHidden) {
          print(isHidden);
        });


        signupLoginController.clear();
        signupPwdController.clear();
        signupNameController.clear();

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
                      MaterialPageRoute(builder: (_) => SignupSuccessScreen()),
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

  Future<void> _makeLogin(BuildContext context,ref) async {

    if(signinLoginController.text.isEmpty || signinPwdController.text.isEmpty) {
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

      final prefs = await SharedPreferences.getInstance();

      LoginRequest loginRequest = LoginRequest(
        username: signinLoginController.text.toString(),
        password: signinPwdController.text.toString(),
      );

      Future<Login> retour = ref.read(appViewModelProvider).setLogin(loginRequest);
      retour.then((result) {
        
        pr.hide().then((isHidden) {
          print(isHidden);
        });

        prefs.setString("activated",result.activated?"1":"0");
        prefs.setString("username",result.username);
        prefs.setString("fullname",result.fullname);
        prefs.setString("id",result.uuid.toString());

        signinLoginController.clear();
        signinPwdController.clear();

        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DashbordScreen()),
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
      final viewModelState = ref.watch(passwordViewModelProvider);
      return PopScope(
     canPop: false, 
      child: Scaffold(
      backgroundColor: Setting.white,
      body: Stack(
        children: <Widget>[
          Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.only(top : 40 * SizeConfig.heightMultiplier,),
                child: Container(
                  child: DefaultTabController(
                     length: 2,
                     initialIndex: 0,
                     child :  Column(children: <Widget>[
                        TabBar(
                          isScrollable: false,
                          labelStyle: const TextStyle( fontFamily: 'Candara', fontSize: 14.0, ),
                          indicatorColor: Setting.hopitalColor,
                          indicatorWeight: 3.0,
                          padding: EdgeInsets.all(10),
                          physics: const NeverScrollableScrollPhysics(),
                          tabs: <Widget>[
                            Tab(
                              text: AppLocalizations.of(context)!.txt_login.toUpperCase(),
                            ),
                            Tab(
                              text: AppLocalizations.of(context)!.txt_signup.toUpperCase(),
                            )
                          ],
                        ),
                        Expanded (child : TabBarView(
                          children: [
                            SingleChildScrollView(child : Padding(
                              padding: EdgeInsets.all(10),
                              child :  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Input(background: Setting.gris, controller: signinLoginController, icon: const Icon(Icons.email,color: Setting.primaryColor ), label:'${AppLocalizations.of(context)!.txt_email} *', enabled: true,),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Password(background: Setting.gris, controller: signinPwdController, icon: const Icon(Icons.lock_open,color: Setting.primaryColor ), label:'${AppLocalizations.of(context)!.txt_pwd} *', state: viewModelState),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Bouton(background: Setting.primaryColor, couleur: Setting.white, onTap: () { _makeLogin(context, ref); }, texte: AppLocalizations.of(context)!.txt_bt_signin,),
                                          const SizedBox(
                                            height: 30.0,
                                          ), 
                                          Center(child : GestureDetector(
                                              child : Text( AppLocalizations.of(context)!.txt_reset_pwd, style: const TextStyle(  fontWeight: FontWeight.normal, fontSize: 14.0,  fontFamily: 'Candara', color: Setting.black), textAlign: TextAlign.center ), 
                                              onTap: ()  => { Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (_) => ResetpwdScreen()),
                                                    ) },),)
                                        ],
                                      )
                            )),
                            SingleChildScrollView(child : Padding(
                              padding: EdgeInsets.all(10),
                              child :  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Input(background: Setting.gris, controller: signupNameController, icon: const Icon(Icons.person,color: Setting.primaryColor ), label:'${AppLocalizations.of(context)!.txt_name} *', enabled: true,),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Input(background: Setting.gris, controller: signupLoginController, icon: const Icon(Icons.email,color: Setting.primaryColor ), label:'${AppLocalizations.of(context)!.txt_email} *', enabled: true,),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Password(background: Setting.gris, controller: signupPwdController, icon: const Icon(Icons.lock_open,color: Setting.primaryColor ), label:'${AppLocalizations.of(context)!.txt_pwd} *', state: viewModelState),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Bouton(background: Setting.primaryColor, couleur: Setting.white, onTap: () {  _makeSignup(context, ref); } , texte: AppLocalizations.of(context)!.txt_bt_signup,),
                                          
                                        ],
                                      )
                            )),
                          ]
                        ))
                     ])
                  )
                )
          ),
          Positioned(
                top: 0.0,
                child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ClipPath(
                                      clipper: OvalBottomBorderClipper(),
                                      child: Container(
                                        height: 39 * SizeConfig.heightMultiplier,
                                        width: MediaQuery.of(context).size.width,
                                        color: Setting.primaryColor,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset('img/logo.png',fit: BoxFit.cover,alignment: Alignment.center, width: 200.0,),
                                            SizedBox(height: 5.0),
                                            Text(AppLocalizations.of(context)!.app_title,
                                                  style: new TextStyle(
                                                  fontFamily: 'Candara',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                  color: Setting.white),
                                            ),
                                            SizedBox(height: 5.0),
                                        ]),
                                      ),
                                    )
                          ),
                        ) 
        ],
      )));
            
  }
    
  }