// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i15;
import 'package:flutter/material.dart' as _i16;

import '../screens/home/basic_info.dart' as _i12;
import '../screens/home/chatbot.dart' as _i11;
import '../screens/home/egfr.dart' as _i8;
import '../screens/home/food.dart' as _i9;
import '../screens/home/home.dart' as _i1;
import '../screens/home/hydration.dart' as _i13;
import '../screens/home/map.dart' as _i10;
import '../screens/home/settings.dart' as _i14;
import '../screens/intro/basic_info.dart' as _i4;
import '../screens/intro/family_history.dart' as _i5;
import '../screens/intro/intro.dart' as _i3;
import '../screens/intro/personal_habits.dart' as _i7;
import '../screens/intro/personal_history.dart' as _i6;
import '../screens/login.dart' as _i2;
import 'router.dart' as _i17;

class AppRouter extends _i15.RootStackRouter {
  AppRouter({
    _i16.GlobalKey<_i16.NavigatorState>? navigatorKey,
    required this.checkIfAlreadyLoggedIn,
  }) : super(navigatorKey);

  final _i17.CheckIfAlreadyLoggedIn checkIfAlreadyLoggedIn;

  @override
  final Map<String, _i15.PageFactory> pagesMap = {
    HomePageRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.HomePageScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.LoginScreen(),
      );
    },
    IntroRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.IntroScreen(),
      );
    },
    BasicInfoRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.BasicInfoScreen(),
      );
    },
    FamilyHistoryRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.FamilyHistoryScreen(),
      );
    },
    PersonalHistoryRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.PersonalHistoryScreen(),
      );
    },
    PersonalHabitsRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.PersonalHabitsScreen(),
      );
    },
    EgfrRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i8.EgfrScreen(),
      );
    },
    FoodRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.FoodScreen(),
      );
    },
    MapRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i10.MapScreen(),
      );
    },
    ChatbotRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i11.ChatbotScreen(),
      );
    },
    MyDataRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i12.MyDataScreen(),
      );
    },
    HydrationAnalysisRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i13.HydrationAnalysisScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i14.SettingsScreen(),
      );
    },
  };

  @override
  List<_i15.RouteConfig> get routes => [
        _i15.RouteConfig(
          HomePageRoute.name,
          path: '/',
          guards: [checkIfAlreadyLoggedIn],
          children: [
            _i15.RouteConfig(
              EgfrRoute.name,
              path: 'egfr',
              parent: HomePageRoute.name,
            ),
            _i15.RouteConfig(
              FoodRoute.name,
              path: 'food',
              parent: HomePageRoute.name,
            ),
            _i15.RouteConfig(
              MapRoute.name,
              path: 'map',
              parent: HomePageRoute.name,
            ),
            _i15.RouteConfig(
              ChatbotRoute.name,
              path: 'chatbot',
              parent: HomePageRoute.name,
            ),
            _i15.RouteConfig(
              MyDataRoute.name,
              path: 'my-data',
              parent: HomePageRoute.name,
            ),
            _i15.RouteConfig(
              HydrationAnalysisRoute.name,
              path: 'hydration',
              parent: HomePageRoute.name,
            ),
            _i15.RouteConfig(
              SettingsRoute.name,
              path: 'settings',
              parent: HomePageRoute.name,
            ),
          ],
        ),
        _i15.RouteConfig(
          LoginRoute.name,
          path: '/login',
        ),
        _i15.RouteConfig(
          IntroRoute.name,
          path: '/intro',
        ),
        _i15.RouteConfig(
          BasicInfoRoute.name,
          path: '/basic-info',
        ),
        _i15.RouteConfig(
          FamilyHistoryRoute.name,
          path: '/family-history',
        ),
        _i15.RouteConfig(
          PersonalHistoryRoute.name,
          path: '/personal-history',
        ),
        _i15.RouteConfig(
          PersonalHabitsRoute.name,
          path: '/personal-habits',
        ),
      ];
}

/// generated route for
/// [_i1.HomePageScreen]
class HomePageRoute extends _i15.PageRouteInfo<void> {
  const HomePageRoute({List<_i15.PageRouteInfo>? children})
      : super(
          HomePageRoute.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'HomePageRoute';
}

/// generated route for
/// [_i2.LoginScreen]
class LoginRoute extends _i15.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/login',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i3.IntroScreen]
class IntroRoute extends _i15.PageRouteInfo<void> {
  const IntroRoute()
      : super(
          IntroRoute.name,
          path: '/intro',
        );

  static const String name = 'IntroRoute';
}

/// generated route for
/// [_i4.BasicInfoScreen]
class BasicInfoRoute extends _i15.PageRouteInfo<void> {
  const BasicInfoRoute()
      : super(
          BasicInfoRoute.name,
          path: '/basic-info',
        );

  static const String name = 'BasicInfoRoute';
}

/// generated route for
/// [_i5.FamilyHistoryScreen]
class FamilyHistoryRoute extends _i15.PageRouteInfo<void> {
  const FamilyHistoryRoute()
      : super(
          FamilyHistoryRoute.name,
          path: '/family-history',
        );

  static const String name = 'FamilyHistoryRoute';
}

/// generated route for
/// [_i6.PersonalHistoryScreen]
class PersonalHistoryRoute extends _i15.PageRouteInfo<void> {
  const PersonalHistoryRoute()
      : super(
          PersonalHistoryRoute.name,
          path: '/personal-history',
        );

  static const String name = 'PersonalHistoryRoute';
}

/// generated route for
/// [_i7.PersonalHabitsScreen]
class PersonalHabitsRoute extends _i15.PageRouteInfo<void> {
  const PersonalHabitsRoute()
      : super(
          PersonalHabitsRoute.name,
          path: '/personal-habits',
        );

  static const String name = 'PersonalHabitsRoute';
}

/// generated route for
/// [_i8.EgfrScreen]
class EgfrRoute extends _i15.PageRouteInfo<void> {
  const EgfrRoute()
      : super(
          EgfrRoute.name,
          path: 'egfr',
        );

  static const String name = 'EgfrRoute';
}

/// generated route for
/// [_i9.FoodScreen]
class FoodRoute extends _i15.PageRouteInfo<void> {
  const FoodRoute()
      : super(
          FoodRoute.name,
          path: 'food',
        );

  static const String name = 'FoodRoute';
}

/// generated route for
/// [_i10.MapScreen]
class MapRoute extends _i15.PageRouteInfo<void> {
  const MapRoute()
      : super(
          MapRoute.name,
          path: 'map',
        );

  static const String name = 'MapRoute';
}

/// generated route for
/// [_i11.ChatbotScreen]
class ChatbotRoute extends _i15.PageRouteInfo<void> {
  const ChatbotRoute()
      : super(
          ChatbotRoute.name,
          path: 'chatbot',
        );

  static const String name = 'ChatbotRoute';
}

/// generated route for
/// [_i12.MyDataScreen]
class MyDataRoute extends _i15.PageRouteInfo<void> {
  const MyDataRoute()
      : super(
          MyDataRoute.name,
          path: 'my-data',
        );

  static const String name = 'MyDataRoute';
}

/// generated route for
/// [_i13.HydrationAnalysisScreen]
class HydrationAnalysisRoute extends _i15.PageRouteInfo<void> {
  const HydrationAnalysisRoute()
      : super(
          HydrationAnalysisRoute.name,
          path: 'hydration',
        );

  static const String name = 'HydrationAnalysisRoute';
}

/// generated route for
/// [_i14.SettingsScreen]
class SettingsRoute extends _i15.PageRouteInfo<void> {
  const SettingsRoute()
      : super(
          SettingsRoute.name,
          path: 'settings',
        );

  static const String name = 'SettingsRoute';
}
