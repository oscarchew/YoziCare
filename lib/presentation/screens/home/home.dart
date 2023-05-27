import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../router/router.gr.dart';

@RoutePage()
class HomePageScreen extends StatelessWidget {

  const HomePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AutoTabsScaffold(
      backgroundColor: Colors.white,
      routes: const [
        FoodAnalysisRoute(),
        GoogleMapsRoute(),
        EgfrRoute(),
        ChatbotRoute(),
        MyDataRoute()
      ],
      bottomNavigationBuilder: (_, tabsRouter) => SalomonBottomBar(
        backgroundColor: Colors.green.withOpacity(0.1),
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        currentIndex: tabsRouter.activeIndex,
        onTap: tabsRouter.setActiveIndex,
        items: [
          SalomonBottomBarItem(
            selectedColor: Colors.lightGreen,
            icon: const Icon(
              Icons.food_bank,
              size: 25,
            ),
            title: Text('my-food-title'.i18n(), style: const TextStyle(fontFamily: 'GenWanMin'),),
          ),
          SalomonBottomBarItem(
            selectedColor: Colors.lightGreen,
            icon: const Icon(
              Icons.map,
              size: 25,
            ),
            title: Text('map-title'.i18n(), style: const TextStyle(fontFamily: 'GenWanMin'),),
          ),
          SalomonBottomBarItem(
            selectedColor: Colors.lightGreen,
            icon: const Icon(
              Icons.auto_graph,
              size: 25,
            ),
            title: Text('stats-title'.i18n(), style: const TextStyle(fontFamily: 'GenWanMin'),),
          ),
          SalomonBottomBarItem(
            selectedColor: Colors.lightGreen,
            icon: const Icon(
              Icons.chat,
              size: 25,
            ),
            title: Text('chatbot-title'.i18n(), style: const TextStyle(fontFamily: 'GenWanMin'),),
          ),
          SalomonBottomBarItem(
            selectedColor: Colors.lightGreen,
            icon: const Icon(
              Icons.assignment_outlined,
              size: 25,
            ),
            title: Text('my-data-title'.i18n(), style: const TextStyle(fontFamily: 'GenWanMin'),),
          )
        ],
      )
  );
}