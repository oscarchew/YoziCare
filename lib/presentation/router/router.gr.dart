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
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/material.dart' as _i11;

import '../screens/home/basic_info.dart' as _i9;
import '../screens/home/chatbot.dart' as _i8;
import '../screens/home/ckd_stats.dart' as _i5;
import '../screens/home/food_analysis.dart' as _i6;
import '../screens/home/google_maps_all.dart' as _i7;
import '../screens/home/home.dart' as _i1;
import '../screens/intro/basic_info.dart' as _i4;
import '../screens/intro/intro.dart' as _i3;
import '../screens/login.dart' as _i2;
import 'router.dart' as _i12;

class AppRouter extends _i10.RootStackRouter {
  AppRouter({
    _i11.GlobalKey<_i11.NavigatorState>? navigatorKey,
    required this.checkIfAlreadyLoggedIn,
  }) : super(navigatorKey);

  final _i12.CheckIfAlreadyLoggedIn checkIfAlreadyLoggedIn;

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    HomePageRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.HomePageScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.LoginScreen(),
      );
    },
    IntroRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.IntroScreen(),
      );
    },
    BasicInfoRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.BasicInfoScreen(),
      );
    },
    EgfrRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.EgfrScreen(),
      );
    },
    FoodAnalysisRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.FoodAnalysisScreen(),
      );
    },
    GoogleMapsRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.GoogleMapsScreen(),
      );
    },
    ChatbotRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i8.ChatbotScreen(),
      );
    },
    MyDataRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.MyDataScreen(),
      );
    },
  };

  @override
  List<_i10.RouteConfig> get routes => [
        _i10.RouteConfig(
          HomePageRoute.name,
          path: '/',
          guards: [checkIfAlreadyLoggedIn],
          children: [
            _i10.RouteConfig(
              EgfrRoute.name,
              path: 'egfr',
              parent: HomePageRoute.name,
            ),
            _i10.RouteConfig(
              FoodAnalysisRoute.name,
              path: 'food',
              parent: HomePageRoute.name,
            ),
            _i10.RouteConfig(
              GoogleMapsRoute.name,
              path: 'map',
              parent: HomePageRoute.name,
            ),
            _i10.RouteConfig(
              ChatbotRoute.name,
              path: 'chatbot',
              parent: HomePageRoute.name,
            ),
            _i10.RouteConfig(
              MyDataRoute.name,
              path: 'my-data',
              parent: HomePageRoute.name,
            ),
          ],
        ),
        _i10.RouteConfig(
          LoginRoute.name,
          path: '/login',
        ),
        _i10.RouteConfig(
          IntroRoute.name,
          path: '/intro',
        ),
        _i10.RouteConfig(
          BasicInfoRoute.name,
          path: '/basic-info',
        ),
      ];
}

/// generated route for
/// [_i1.HomePageScreen]
class HomePageRoute extends _i10.PageRouteInfo<void> {
  const HomePageRoute({List<_i10.PageRouteInfo>? children})
      : super(
          HomePageRoute.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'HomePageRoute';
}

/// generated route for
/// [_i2.LoginScreen]
class LoginRoute extends _i10.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/login',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i3.IntroScreen]
class IntroRoute extends _i10.PageRouteInfo<void> {
  const IntroRoute()
      : super(
          IntroRoute.name,
          path: '/intro',
        );

  static const String name = 'IntroRoute';
}

/// generated route for
/// [_i4.BasicInfoScreen]
class BasicInfoRoute extends _i10.PageRouteInfo<void> {
  const BasicInfoRoute()
      : super(
          BasicInfoRoute.name,
          path: '/basic-info',
        );

  static const String name = 'BasicInfoRoute';
}

/// generated route for
/// [_i5.EgfrScreen]
class EgfrRoute extends _i10.PageRouteInfo<void> {
  const EgfrRoute()
      : super(
          EgfrRoute.name,
          path: 'egfr',
        );

  static const String name = 'EgfrRoute';
}

/// generated route for
/// [_i6.FoodAnalysisScreen]
class FoodAnalysisRoute extends _i10.PageRouteInfo<void> {
  const FoodAnalysisRoute()
      : super(
          FoodAnalysisRoute.name,
          path: 'food',
        );

  static const String name = 'FoodAnalysisRoute';
}

/// generated route for
/// [_i7.GoogleMapsScreen]
class GoogleMapsRoute extends _i10.PageRouteInfo<void> {
  const GoogleMapsRoute()
      : super(
          GoogleMapsRoute.name,
          path: 'map',
        );

  static const String name = 'GoogleMapsRoute';
}

/// generated route for
/// [_i8.ChatbotScreen]
class ChatbotRoute extends _i10.PageRouteInfo<void> {
  const ChatbotRoute()
      : super(
          ChatbotRoute.name,
          path: 'chatbot',
        );

  static const String name = 'ChatbotRoute';
}

/// generated route for
/// [_i9.MyDataScreen]
class MyDataRoute extends _i10.PageRouteInfo<void> {
  const MyDataRoute()
      : super(
          MyDataRoute.name,
          path: 'my-data',
        );

  static const String name = 'MyDataRoute';
}
