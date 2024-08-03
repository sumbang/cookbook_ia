import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting {

  static const String appName = 'CookBookIA';
  static const String currenversion = '1.0.0';
  static const String plateformeMobile = '1';
  static const String plateformeWeb = '2';

  static const mobileWidth = 600;
  static const desktopWidth = 1400;

  static const versionName = 'Version 1.0.0 - © 2024 CookBookIA';

  static const String apikey = 'AIzaSyA8ljP0QzyGuKNLsn9CNLF8qliANPtA_X8';

  static String generateRandomString(int len) {
    var r = Random();
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }


  static const bgColor = Color(0xFFFFFFFF);
  static const primaryColor = Color(0xFFE69C0F);  
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const gris = Color(0xFFF4F4F4);
  static const patientColor = Color(0xFF106788);
  static const hopitalColor = Color(0xFFE69C0F);
  static const loginColor = Color(0xFF9FBACB);
  static const vertColor = Color(0xFFADCB9F);
  static const bottomNavigation = Color(0xFF1BA8BA);
  static const bottomNavigationSelect = Color(0xFF708BC7);
  static const jaune = Color(0xFFE5D407);
  static const marron = Color(0xFF957878);

  static const List<String> supportedLanguages = ['en','fr','es'];
  static Iterable<Locale> allSupportedLocales() => supportedLanguages.map<Locale>((lang) =>  Locale(lang, ''));

  static Color generateBackground() {
    var list = [const Color(0xFF198EB9) , const Color(0xFF9FBACB), const Color(0xFF708BC7), const Color(0xFF70BDC7),  const Color(0xFFC66F0A), const Color(0xFF0A4BC6), const Color(0xFF3E9F79) ];
    final random =  Random();
    return list[random.nextInt(list.length)];
  }

  static String arrayToString(List<String> list) {
    String retour = "";
    for(int i = 0; i < list.length; i++) {
      if(i != list.length - 1) {
        retour+= "${list[i].trim()} -  ";
      } else {
        retour+= list[i].trim();
      }
    }
    return retour;
  }

  static String getDynamicMessage(String key, BuildContext context) {
    switch (key) {
      case "email_exist":
        return AppLocalizations.of(context)!.email_exist;
      case "email_invalid":
        return AppLocalizations.of(context)!.email_invalid;
      case "app_error":
        return AppLocalizations.of(context)!.app_error;
      case "account_create":
        return AppLocalizations.of(context)!.account_create;
      case "user_disabled":
        return AppLocalizations.of(context)!.user_disabled;
      case "user_not_found":
        return AppLocalizations.of(context)!.user_not_found;
      case "reset_sent":
        return AppLocalizations.of(context)!.reset_sent;
      case "invalid_credential":
        return AppLocalizations.of(context)!.invalid_credential;
      case "email_verified":
        return AppLocalizations.of(context)!.email_verified;
      case "user_signout":
        return AppLocalizations.of(context)!.user_signout;
      case "txt_save":
        return AppLocalizations.of(context)!.txt_save;
      default: return "";   
      
      }
  }

 



}