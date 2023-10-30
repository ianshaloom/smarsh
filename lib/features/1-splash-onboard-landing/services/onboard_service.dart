import 'package:shared_preferences/shared_preferences.dart';

class OnboardService {
  // OnboardService._();
  // static final OnboardService _instance = OnboardService._();
  // factory OnboardService() => _instance;
  // static OnboardService get instance => _instance;

  // final SharedPreferences _prefs =
  //     SharedPreferences.getInstance() as SharedPreferences;

  // set showHome to value
  static toggleShowHome(bool value) async {
    await SharedPreferences.getInstance()
        .then((prefs) => prefs.setBool('showHome', value));
  }

  // get showHome

  static get getShowHome async => await SharedPreferences.getInstance()
      .then((value) => value.getBool('showHome') ?? false);
}
