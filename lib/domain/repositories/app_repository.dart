import 'package:cookbook_ia/data/models/requests/account_request.dart';
import 'package:cookbook_ia/data/models/requests/login_request.dart';
import 'package:cookbook_ia/data/models/requests/recipe_request.dart';
import 'package:cookbook_ia/data/models/requests/reset_request.dart';
import 'package:cookbook_ia/data/models/requests/signup_request.dart';
import 'package:cookbook_ia/domain/entities/account.dart';
import 'package:cookbook_ia/domain/entities/login.dart';
import 'package:cookbook_ia/domain/entities/message.dart';
import 'package:cookbook_ia/domain/entities/recipe.dart';

abstract class AppRepository {

  Future<Message> setSignup({required SignupRequest data});
  Future<Message> setReset({required ResetRequest data});
  Future<Login> setLogin({required LoginRequest data});
  Future<Message> setLogout();
  Future<Message> setUpdate({required AccountRequest data});
  Future<Account> getAccount();
  Future<Message> setRecipe({required RecipeRequest data});
  Future<List<Recipe>> getRecipe();
  Future<Message> deleteRecipe({required Recipe data});

}