import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'router.gr.dart';

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

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
        path: '/',
        page: HomePageRoute.page,
        initial: true,
        guards: [CheckIfAlreadyLoggedIn()],
        children: [
          AutoRoute(
              path: 'egfr',
              page: EgfrRoute.page,
              initial: true
          ),
          AutoRoute(
              path: 'food',
              page: FoodAnalysisRoute.page
          ),
          AutoRoute(
              path: 'map',
              page: GoogleMapsRoute.page
          ),
          AutoRoute(
              path: 'chatbot',
              page: ChatbotRoute.page
          ),
          AutoRoute(
              path: 'my-data',
              page: MyDataRoute.page
          )
        ]
    ),
    AutoRoute(
        path: '/login',
        page: LoginRoute.page
    ),
    AutoRoute(
        path: '/intro',
        page: IntroRoute.page
    ),
    AutoRoute(
        path: '/basic-info',
        page: BasicInfoRoute.page
    ),
  ];
}

// flutter pub run build_runner build --delete-conflicting-outputs