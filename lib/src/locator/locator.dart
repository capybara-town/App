import 'package:capybara/src/api/festivals_api.dart';
import 'package:capybara/src/api/users_api.dart';
import 'package:capybara/src/provider/user_provider.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => UsersApi());
  locator.registerLazySingleton(() => UserProvider());
  locator.registerLazySingleton(() => FestivalsApi());
}