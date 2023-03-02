import 'package:auto_route/auto_route.dart';
import '../screens/intro/intro.dart';
import '../screens/intro/basic_info.dart';
import '../screens/intro/family_history.dart';
import '../screens/intro/personal_habits.dart';
import '../screens/intro/personal_history.dart';
import '../screens/home/home.dart';
import '../screens/login.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(path: '/', page: LoginScreen, initial: true),
    AutoRoute(path: '/intro', page: IntroScreen),
    AutoRoute(path: '/basic-info', page: BasicInfoScreen),
    AutoRoute(path: '/family-history', page: FamilyHistoryScreen),
    AutoRoute(path: '/personal-history', page: PersonalHistoryScreen),
    AutoRoute(path: '/personal-habits', page: PersonalHabitsScreen),
    AutoRoute(path: '/home', page: HomeScreen),
    AutoRoute(path: '/home', page: HomeScreen),
  ],
)
class $AppRouter {}

// flutter pub run build_runner watch --delete-conflicting-outputs