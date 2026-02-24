import 'package:mvvm_project/data/implementations/api/auth_api.dart';
import 'package:mvvm_project/data/implementations/local/app_database.dart';
import 'package:mvvm_project/data/implementations/mapper/auth_mapper.dart';
import 'package:mvvm_project/data/implementations/repositories/auth_repository.dart';
import 'package:mvvm_project/viewmodels/login/login_viewmodel.dart';

LoginViewModel buildLoginVM(){
  final api = AuthApi(AppDatabase.instance); //impliment AuthApi
  final mapper = AuthSessionMapper(); //DTO => Entity
  final repo = AuthRepository(api: api, mapper: mapper);
  return LoginViewModel(repo);
}
