import 'package:cookbook_ia/core/setting.dart';
import 'package:cookbook_ia/data/models/responses/recette_response.dart';
import 'package:flutter/material.dart';

class IaGeneratorRecipesScreen extends StatelessWidget {

  final List<RecetteResponse> recipes;
  IaGeneratorRecipesScreen(this.recipes);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          body: IaGeneratorRecipesScreen1(recipes)
          );
  }
}

class IaGeneratorRecipesScreen1 extends StatefulWidget {

  final List<RecetteResponse> recipes;
  IaGeneratorRecipesScreen1(this.recipes);

  @override
  IaGeneratorRecipesScreenState createState() =>IaGeneratorRecipesScreenState(recipes);

}

class IaGeneratorRecipesScreenState extends State<IaGeneratorRecipesScreen1> {
  List<RecetteResponse> recipes;
  IaGeneratorRecipesScreenState(this.recipes);

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
    
    return  Scaffold( 
      backgroundColor: Setting.white,
      key: _scaffoldKey,
      body : Stack(
            children: <Widget>[
              
              Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top:100),
                        height: MediaQuery.of(context).size.height,
                        child :SingleChildScrollView(child : Padding(
                                padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
                                child:  Container(),)),
                ),

                Positioned(
                  top: 50.0,
                  right: 20.0,
                  child: Container(
                    child : Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                          const SizedBox(width: 10,),
                          
                          IconButton(
                                icon: const Icon(
                                    Icons.close,
                                    color: Colors.black,
                                    size: 30,
                                ), onPressed: () {

                                   Navigator.of(_scaffoldKey.currentContext!).pop();
                                  
                          },),


                      ],
                    )
                  ) 
                ),


            ]
          
     ) );

  }


}