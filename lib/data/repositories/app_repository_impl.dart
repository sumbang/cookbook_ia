import 'package:cookbook_ia/data/api/database.dart';
import 'package:cookbook_ia/data/models/requests/account_request.dart';
import 'package:cookbook_ia/data/models/requests/login_request.dart';
import 'package:cookbook_ia/data/models/requests/reset_request.dart';
import 'package:cookbook_ia/data/models/requests/signup_request.dart';
import 'package:cookbook_ia/domain/entities/account.dart';
import 'package:cookbook_ia/domain/entities/login.dart';
import 'package:cookbook_ia/domain/entities/message.dart';
import 'package:cookbook_ia/domain/repositories/app_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appRepositoryProvider = Provider<AppRepository>((ref) => AppRepositoryImpl(ref.read(databaseApiProvider)));

class AppRepositoryImpl extends AppRepository {

  final Database _remoteDatabase;

  AppRepositoryImpl(this._remoteDatabase);

  @override
  Future<Message> setSignup({required SignupRequest data}) {
    return _remoteDatabase.setSignup(data).then((value) => value.toEntity());
  }

  @override
  Future<Login> setLogin({required LoginRequest data}) {
    return _remoteDatabase.setSignin(data).then((value) => value.toEntity());
  }

  @override
  Future<Message> setReset({required ResetRequest data}) {
    return _remoteDatabase.setReset(data).then((value) => value.toEntity());
  }
  
  @override
  Future<Message> setLogout() {
    return _remoteDatabase.setSignOut().then((value) => value.toEntity());
  }

  @override
  Future<Account> getAccount() {
    return _remoteDatabase.getUserAccount().then((value) => value.toEntity());
  }

  @override
  Future<Message> setUpdate({required AccountRequest data}) {
    return _remoteDatabase.setUpdateAccount(data).then((value) => value.toEntity());
  }


}