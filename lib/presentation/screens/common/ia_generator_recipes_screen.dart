import 'package:cookbook_ia/core/setting.dart';
import 'package:cookbook_ia/data/models/responses/recette_response.dart';
import 'package:cookbook_ia/presentation/components/widgets/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';


class IaGeneratorRecipesScreen extends StatefulHookConsumerWidget {

  final List<RecetteResponse> recipes;
  IaGeneratorRecipesScreen(this.recipes);

  @override
  IaGeneratorRecipesScreenState createState() =>IaGeneratorRecipesScreenState(recipes);

}

class IaGeneratorRecipesScreenState extends ConsumerState<IaGeneratorRecipesScreen>  with TickerProviderStateMixin {
  List<RecetteResponse> recipes;
  IaGeneratorRecipesScreenState(this.recipes);

  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: recipes.length, vsync: this);    
  }


  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  


  @override
  Widget build(BuildContext context) {

    return PopScope(
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
      body : Column(
            children: <Widget>[

               Expanded(
                child:  PageView(
                controller: _pageViewController,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPageIndex = page;
                    });
                  },
                children:recipes.map((e) => Recipe(recette: e,)).toList(),
              )),
              
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 10),
                child: PageViewDotIndicator(
                  currentItem: _currentPageIndex,
                  count: recipes.length,
                  unselectedColor: Setting.black,
                  selectedColor: Setting.primaryColor,
                  duration: const Duration(milliseconds: 200),
                  boxShape: BoxShape.circle,
                  onItemClicked: (index) {
                    _pageViewController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ]
          
     ), ));
    

  }


}