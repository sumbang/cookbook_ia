import 'package:cookbook_ia/core/setting.dart';
import 'package:flutter/material.dart';


class ItemLine extends StatelessWidget {

  final String item;

  ItemLine({required this.item});

  @override
  Widget build(BuildContext context) {

      return Padding(
                padding: const EdgeInsets.all(5),
                    child: Align(alignment: Alignment.centerLeft, child : Padding(padding: const EdgeInsets.only(left: 5), child : Text(item, style: TextStyle(color: Setting.black,  fontSize: 16, fontFamily: 'Candara', fontWeight: FontWeight.normal, height: 1.5)))));
  }

}