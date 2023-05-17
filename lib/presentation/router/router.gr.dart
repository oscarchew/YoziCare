// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:gdsc/presentation/screens/home/basic_info.dart' as _i1;
import 'package:gdsc/presentation/screens/home/chatbot.dart' as _i2;
import 'package:gdsc/presentation/screens/home/ckd_stats.dart' as _i3;
import 'package:gdsc/presentation/screens/home/food_analysis.dart' as _i4;
import 'package:gdsc/presentation/screens/home/google_maps_all.dart' as _i5;
import 'package:gdsc/presentation/screens/home/home.dart' as _i6;
import 'package:gdsc/presentation/screens/intro/basic_info.dart' as _i7;
import 'package:gdsc/presentation/screens/intro/intro.dart' as _i8;
import 'package:gdsc/presentation/screens/login.dart' as _i9;

abstract class $AppRouter extends _i10.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    MyDataRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.MyDataScreen(),
      );
    },
    ChatbotRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ChatbotScreen(),
      );
    },
    EgfrRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.EgfrScreen(),
      );
    },
    FoodAnalysisRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.FoodAnalysisScreen(),
      );
    },
    GoogleMapsRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.GoogleMapsScreen(),
      );
    },
    HomePageRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.HomePageScreen(),
      );
    },
    BasicInfoRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.BasicInfoScreen(),
      );
    },
    IntroRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.IntroScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.LoginScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.MyDataScreen]
class MyDataRoute extends _i10.PageRouteInfo<void> {
  const MyDataRoute({List<_i10.PageRouteInfo>? children})
      : super(
          MyDataRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyDataRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ChatbotScreen]
class ChatbotRoute extends _i10.PageRouteInfo<void> {
  const ChatbotRoute({List<_i10.PageRouteInfo>? children})
      : super(
          ChatbotRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatbotRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i3.EgfrScreen]
class EgfrRoute extends _i10.PageRouteInfo<void> {
  const EgfrRoute({List<_i10.PageRouteInfo>? children})
      : super(
          EgfrRoute.name,
          initialChildren: children,
        );

  static const String name = 'EgfrRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i4.FoodAnalysisScreen]
class FoodAnalysisRoute extends _i10.PageRouteInfo<void> {
  const FoodAnalysisRoute({List<_i10.PageRouteInfo>? children})
      : super(
          FoodAnalysisRoute.name,
          initialChildren: children,
        );

  static const String name = 'FoodAnalysisRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i5.GoogleMapsScreen]
class GoogleMapsRoute extends _i10.PageRouteInfo<void> {
  const GoogleMapsRoute({List<_i10.PageRouteInfo>? children})
      : super(
          GoogleMapsRoute.name,
          initialChildren: children,
        );

  static const String name = 'GoogleMapsRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i6.HomePageScreen]
class HomePageRoute extends _i10.PageRouteInfo<void> {
  const HomePageRoute({List<_i10.PageRouteInfo>? children})
      : super(
          HomePageRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomePageRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i7.BasicInfoScreen]
class BasicInfoRoute extends _i10.PageRouteInfo<void> {
  const BasicInfoRoute({List<_i10.PageRouteInfo>? children})
      : super(
          BasicInfoRoute.name,
          initialChildren: children,
        );

  static const String name = 'BasicInfoRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i8.IntroScreen]
class IntroRoute extends _i10.PageRouteInfo<void> {
  const IntroRoute({List<_i10.PageRouteInfo>? children})
      : super(
          IntroRoute.name,
          initialChildren: children,
        );

  static const String name = 'IntroRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i9.LoginScreen]
class LoginRoute extends _i10.PageRouteInfo<void> {
  const LoginRoute({List<_i10.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}
