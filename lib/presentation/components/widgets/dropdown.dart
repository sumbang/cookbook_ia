import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/setting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Dropdown extends HookConsumerWidget {

final String label;
final Color background;
final TextEditingController controller;
final Icon icon;
final int types;
final bool enabled;


  const Dropdown({
    required this.label,
    required this.background,
    required this.controller,
    required this.icon,
    required this.types,
    required this.enabled
  }): super();

  @override
  Widget build(BuildContext context,ref) {

   if(types == 1) {

    List<String> cuisines = [AppLocalizations.of(context)!.txt_cuisine1, AppLocalizations.of(context)!.txt_cuisine2, AppLocalizations.of(context)!.txt_cuisine3, AppLocalizations.of(context)!.txt_cuisine4, AppLocalizations.of(context)!.txt_cuisine5, AppLocalizations.of(context)!.txt_cuisine6, AppLocalizations.of(context)!.txt_cuisine7 ];
    
    if(this.controller.text.toString().isEmpty) this.controller.text = cuisines[0].toString();

    return  Padding(
          padding: const EdgeInsets.all(0.0),
          child: Container(
            padding: const EdgeInsets.only(
                    left: 10.0, right: 5.0, top: 10.0, bottom: 3.0),
                width: double.infinity,
                decoration: new BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
            child : InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: background,
              icon: icon,
              labelText: label,
              labelStyle: const TextStyle( fontFamily: 'Candara', color: Colors.grey, fontSize: 18.0, fontWeight: FontWeight.normal),
              enabledBorder: OutlineInputBorder( 
                  borderSide: BorderSide(color:Setting.primaryColor, width: 2),
                ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Setting.primaryColor, width: 2),
                ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
              contentPadding: const EdgeInsets.only(left: 10.0, right: 5.0, top: 3.0, bottom: 3.0),
            ),
            child: ButtonTheme(
              materialTapTargetSize: MaterialTapTargetSize.padded,
              child:  StatefulBuilder(builder: (BuildContext context, StateSetter setState) {  
                return DropdownButtonHideUnderline(child : DropdownButton<String>(
                isExpanded: true,
                value: this.controller.text.toString(),
                elevation: 10,
                onChanged: (enabled) ? (String? newValue) {
                     setState(() =>  this.controller.text = newValue!);
                } : null,
                items: cuisines.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(value),
                  );
                }).toList(),
              ) ); }),
            ),
          ),
      ));

  }

  else return Container();

  }

}