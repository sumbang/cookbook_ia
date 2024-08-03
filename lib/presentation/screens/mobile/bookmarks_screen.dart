import 'package:cookbook_ia/core/setting.dart';
import 'package:cookbook_ia/domain/entities/recipe.dart';
import 'package:cookbook_ia/presentation/components/view_models/app_view_model.dart';
import 'package:cookbook_ia/presentation/components/widgets/recipe_item.dart';
import 'package:cookbook_ia/presentation/screens/mobile/dashbord_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookmarksScreen extends StatefulHookConsumerWidget {

  BookmarksScreen();

  @override
  BookmarksScreenState createState() => new BookmarksScreenState();
}

class BookmarksScreenState extends ConsumerState<BookmarksScreen> {

  final searchController = TextEditingController();
  List<Recipe> recipes = [];   
  List<Recipe> _searchResult = [];
  bool isSearch = true;
  bool isOk = false;

  _getData() async { 
      isSearch = true;
      Future<List<Recipe>> retour = ref.read(appViewModelProvider).getRecipe();

      await retour.then((result) {
           setState(() {
            recipes = result;
            isSearch = false;
            if(recipes.length > 0) isOk = true;
           });
                  
      }).catchError((e) {
        setState(() {
          isSearch = false;
          isOk = false;
        });
      });
  }

  onSearchTextChanged(String text) async {

      _searchResult.clear();
    
      if (text.isEmpty) { setState(() {});  return; }
    
      setState(() {

      print(text);  //  i
    
      recipes.forEach((item) {
        if (item.name.toString().toLowerCase().contains(text.toLowerCase()) || item.ingredients.contains(text.toLowerCase()) || item.instructions.contains(text.toLowerCase()))
              _searchResult.add(item); 
            });

      });

  }


  @override
  void initState()  {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      backgroundColor: Setting.white,
             appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.txt_menu2,  style: TextStyle(color: Colors.white,  fontFamily: 'Candara', fontWeight: FontWeight.bold, fontSize: 18.0), ),
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
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                      Container(
                          color: Setting.patientColor,
                          child:  Padding(
                            padding:  EdgeInsets.all(1.0),
                            child:  Card(
                              child:  ListTile(
                                leading:  Icon(Icons.search),
                                title:  TextField(
                                  controller: searchController,
                                  decoration:  InputDecoration(hintText: AppLocalizations.of(context)!.txt_search, border: InputBorder.none),
                                  onChanged: onSearchTextChanged,
                                ),
                                trailing:  IconButton(icon:  Icon(Icons.cancel), onPressed: () {
                                  searchController.clear();
                                  onSearchTextChanged(searchController.text.toString());
                                },),
                              ),
                            ),
                          ),
                        ),
                        
                        
                      const SizedBox(height: 10,),

                      (isSearch) ? Center( child: CircularProgressIndicator(color: Setting.primaryColor,), ) : (!isOk) ? Container() :  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: (_searchResult.isNotEmpty || searchController.text.isNotEmpty) ? _searchResult.map((data) { return RecipeItem(recipe: data);  }).toList() :  recipes.map((data) { return RecipeItem(recipe: data);}).toList()),
                  
                ],
          )
          ),
        )
      );
  }

}