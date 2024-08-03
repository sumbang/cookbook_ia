import 'package:cookbook_ia/data/models/requests/account_request.dart';
import 'package:cookbook_ia/data/models/requests/login_request.dart';
import 'package:cookbook_ia/data/models/requests/recipe_request.dart';
import 'package:cookbook_ia/data/models/requests/reset_request.dart';
import 'package:cookbook_ia/data/models/requests/signup_request.dart';
import 'package:cookbook_ia/data/repositories/app_repository_impl.dart';
import 'package:cookbook_ia/domain/entities/account.dart';
import 'package:cookbook_ia/domain/entities/login.dart';
import 'package:cookbook_ia/domain/entities/message.dart';
import 'package:cookbook_ia/domain/entities/recipe.dart';
import 'package:cookbook_ia/domain/repositories/app_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appUseCaseProvider = Provider<AppUsercase>((ref) => AppUsercase(ref.read(appRepositoryProvider)));

class AppUsercase { 

    AppUsercase(this._repository);

    final AppRepository _repository; 

    Future<Message> setSignup(SignupRequest signupRequest) {
      return _repository.setSignup(data: signupRequest);
    }

    Future<Message> setReset(ResetRequest resetRequest) {
      return _repository.setReset(data: resetRequest);
    }

    Future<Login> setLogin(LoginRequest loginRequest) {
      return _repository.setLogin(data: loginRequest);
    }

    Future<Message> setLogout() {
      return _repository.setLogout();
    }

    Future<Message> setUpdate(AccountRequest accountRequest) {
      return _repository.setUpdate(data: accountRequest);
    }

    Future<Account> getAccount() {
      return _repository.getAccount();
    }

    Future<Message> setRecipe(RecipeRequest recipeRequest) {
      return _repository.setRecipe(data: recipeRequest);
    }

    Future<List<Recipe>> getRecipe() {
      return _repository.getRecipe();
    }

    Future<Message> deleteRecipe(Recipe recipeRequest) {
      return _repository.deleteRecipe(data: recipeRequest);
    }

} 