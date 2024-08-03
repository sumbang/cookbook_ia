import 'package:cookbook_ia/data/models/requests/account_request.dart';
import 'package:cookbook_ia/data/models/requests/login_request.dart';
import 'package:cookbook_ia/data/models/requests/recipe_request.dart';
import 'package:cookbook_ia/data/models/requests/reset_request.dart';
import 'package:cookbook_ia/data/models/requests/signup_request.dart';
import 'package:cookbook_ia/domain/entities/account.dart';
import 'package:cookbook_ia/domain/entities/login.dart';
import 'package:cookbook_ia/domain/entities/message.dart';
import 'package:cookbook_ia/domain/entities/recipe.dart';
import 'package:cookbook_ia/domain/usercases/app_usercase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appViewModelProvider = Provider.autoDispose<AppViewModel>((ref) => AppViewModel(ref.read(appUseCaseProvider)));

class AppViewModel {

  final AppUsercase _useCase;

  AppViewModel(this._useCase);
  
  Future<Message> setSignup(SignupRequest data) {
     return _useCase.setSignup(data);
  }

  Future<Message> setReset(ResetRequest data) {
     return _useCase.setReset(data);
  }

  Future<Login> setLogin(LoginRequest data) {
     return _useCase.setLogin(data);
  }

  Future<Message> setLogout() {
     return _useCase.setLogout();
  }

  Future<Message> setUpdate(AccountRequest data) {
     return _useCase.setUpdate(data);
  }

  Future<Account> getAccount() {
     return _useCase.getAccount();
  }

  Future<Message> setRecipe(RecipeRequest data) {
     return _useCase.setRecipe(data);
  }

  Future<List<Recipe>> getRecipe() {
     return _useCase.getRecipe();
  }

  Future<Message> deleteRecipe(Recipe data) {
     return _useCase.deleteRecipe(data);
  }


}