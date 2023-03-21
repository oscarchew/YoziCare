import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsc/presentation/screens/home/food.dart';
import 'package:gdsc/presentation/screens/home/food_analysis.dart';
import 'package:gdsc/presentation/screens/home/google_maps_all.dart';
import 'package:gdsc/presentation/screens/home/map.dart';
import '../screens/home/chatbot.dart';
import '../screens/home/home.dart';
import '../screens/home/hydration.dart';
import '../screens/home/basic_info.dart';
import '../screens/home/settings.dart';
import '../screens/intro/intro.dart';
import '../screens/intro/basic_info.dart';
import '../screens/intro/family_history.dart';
import '../screens/intro/personal_habits.dart';
import '../screens/intro/personal_history.dart';
import '../screens/home/egfr.dart';
import '../screens/login.dart';

class CheckIfAlreadyLoggedIn extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final alreadyLoggedIn = (currentUser != null);
    if (alreadyLoggedIn) {
      resolver.next();
    } else {
      router.replaceNamed('/login');
    }
  }
}

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(
        path: '/',
        page: HomePageScreen,
        initial: true,
        guards: [CheckIfAlreadyLoggedIn],
        children: [
          AutoRoute(
              path: 'egfr',
              page: EgfrScreen
          ),
          // Not yet implemented
          AutoRoute(
              path: 'food',
              page: FoodAnalysisScreen
          ),
          // Not yet implemented
          AutoRoute(
              path: 'map',
              page: GoogleMapsScreen
          ),
          // Not yet implemented
          AutoRoute(
              path: 'chatbot',
              page: ChatbotScreen
          ),
          AutoRoute(
              path: 'my-data',
              page: MyDataScreen
          ),
          AutoRoute(
              path: 'hydration',
              page: HydrationAnalysisScreen
          ),
          AutoRoute(
              path: 'settings',
              page: SettingsScreen
          )
        ]
    ),
    AutoRoute(
      path: '/login',
      page: LoginScreen
    ),
    AutoRoute(
        path: '/intro',
        page: IntroScreen
    ),
    AutoRoute(
        path: '/basic-info',
        page: BasicInfoScreen
    ),
    AutoRoute(
        path: '/family-history',
        page: FamilyHistoryScreen
    ),
    AutoRoute(
        path: '/personal-history',
        page: PersonalHistoryScreen
    ),
    AutoRoute(
        path: '/personal-habits',
        page: PersonalHabitsScreen
    )
  ],
)
class $AppRouter {}

// flutter pub run build_runner build --delete-conflicting-outputs