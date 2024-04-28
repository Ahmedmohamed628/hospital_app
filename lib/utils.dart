import 'package:get_it/get_it.dart';
import 'package:hospital/authentication/login/login_screen_view_model.dart';

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<LoginScreenViewModel>(
    LoginScreenViewModel(),
  );
}
