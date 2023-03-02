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
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;

import '../screens/home/home.dart' as _i7;
import '../screens/intro/basic_info.dart' as _i3;
import '../screens/intro/family_history.dart' as _i4;
import '../screens/intro/intro.dart' as _i2;
import '../screens/intro/personal_habits.dart' as _i6;
import '../screens/intro/personal_history.dart' as _i5;
import '../screens/login.dart' as _i1;

class AppRouter extends _i8.RootStackRouter {
  AppRouter([_i9.GlobalKey<_i9.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    LoginScreen.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.LoginScreen(),
      );
    },
    IntroScreen.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.IntroScreen(),
      );
    },
    BasicInfoScreen.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.BasicInfoScreen(),
      );
    },
    FamilyHistoryScreen.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.FamilyHistoryScreen(),
      );
    },
    PersonalHistoryScreen.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.PersonalHistoryScreen(),
      );
    },
    PersonalHabitsScreen.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.PersonalHabitsScreen(),
      );
    },
    HomeScreen.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.HomeScreen(),
      );
    },
  };

  @override
  List<_i8.RouteConfig> get routes => [
        _i8.RouteConfig(
          LoginScreen.name,
          path: '/',
        ),
        _i8.RouteConfig(
          IntroScreen.name,
          path: '/intro',
        ),
        _i8.RouteConfig(
          BasicInfoScreen.name,
          path: '/basic-info',
        ),
        _i8.RouteConfig(
          FamilyHistoryScreen.name,
          path: '/family-history',
        ),
        _i8.RouteConfig(
          PersonalHistoryScreen.name,
          path: '/personal-history',
        ),
        _i8.RouteConfig(
          PersonalHabitsScreen.name,
          path: '/personal-habits',
        ),
        _i8.RouteConfig(
          HomeScreen.name,
          path: '/home',
        ),
        _i8.RouteConfig(
          HomeScreen.name,
          path: '/home',
        ),
      ];
}

/// generated route for
/// [_i1.LoginScreen]
class LoginScreen extends _i8.PageRouteInfo<void> {
  const LoginScreen()
      : super(
          LoginScreen.name,
          path: '/',
        );

  static const String name = 'LoginScreen';
}

/// generated route for
/// [_i2.IntroScreen]
class IntroScreen extends _i8.PageRouteInfo<void> {
  const IntroScreen()
      : super(
          IntroScreen.name,
          path: '/intro',
        );

  static const String name = 'IntroScreen';
}

/// generated route for
/// [_i3.BasicInfoScreen]
class BasicInfoScreen extends _i8.PageRouteInfo<void> {
  const BasicInfoScreen()
      : super(
          BasicInfoScreen.name,
          path: '/basic-info',
        );

  static const String name = 'BasicInfoScreen';
}

/// generated route for
/// [_i4.FamilyHistoryScreen]
class FamilyHistoryScreen extends _i8.PageRouteInfo<void> {
  const FamilyHistoryScreen()
      : super(
          FamilyHistoryScreen.name,
          path: '/family-history',
        );

  static const String name = 'FamilyHistoryScreen';
}

/// generated route for
/// [_i5.PersonalHistoryScreen]
class PersonalHistoryScreen extends _i8.PageRouteInfo<void> {
  const PersonalHistoryScreen()
      : super(
          PersonalHistoryScreen.name,
          path: '/personal-history',
        );

  static const String name = 'PersonalHistoryScreen';
}

/// generated route for
/// [_i6.PersonalHabitsScreen]
class PersonalHabitsScreen extends _i8.PageRouteInfo<void> {
  const PersonalHabitsScreen()
      : super(
          PersonalHabitsScreen.name,
          path: '/personal-habits',
        );

  static const String name = 'PersonalHabitsScreen';
}

/// generated route for
/// [_i7.HomeScreen]
class HomeScreen extends _i8.PageRouteInfo<void> {
  const HomeScreen()
      : super(
          HomeScreen.name,
          path: '/home',
        );

  static const String name = 'HomeScreen';
}
