import 'package:flutter/material.dart';

class Input extends StatelessWidget {

final String label;
final Color background;
final TextEditingController controller;
final Icon icon;
final bool enabled;

  const Input({super.key, 
    required this.label,
    required this.background,
    required this.controller,
    required this.icon,
    required this.enabled
  });
  
  @override
  Widget build(BuildContext context) {
    
    return  Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 5.0, top: 3.0, bottom: 3.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                child: TextFormField(
                  obscureText: false,
                  style: const TextStyle(
                      fontFamily: 'Candara',
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: icon,
                    labelText: label,
                    labelStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                        fontFamily: 'Candara',
                        fontWeight: FontWeight.normal),
                  ),
                  keyboardType: TextInputType.text,
                  controller: controller,
                  enabled: enabled,
                ),
              ),
            );
  }


}