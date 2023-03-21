import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../router/router.gr.dart';

class HomePageScreen extends StatelessWidget {

  const HomePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AutoTabsScaffold(
      backgroundColor: Colors.white,
      routes: const [
        EgfrRoute(),
        FoodRoute(),
        MapRoute(),
        ChatbotRoute(),
        MyDataRoute(),
        HydrationAnalysisRoute(),
        SettingsRoute()
      ],
      bottomNavigationBuilder: (_, tabsRouter) => SalomonBottomBar(
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
              Icons.auto_graph,
              size: 20,
            ),
            title: const Text('My eGFR'),
          ),
          SalomonBottomBarItem(
            selectedColor: Colors.amberAccent,
            icon: const Icon(
              Icons.food_bank,
              size: 20,
            ),
            title: const Text('My Food'),
          ),
          SalomonBottomBarItem(
            selectedColor: Colors.redAccent,
            icon: const Icon(
              Icons.map,
              size: 20,
            ),
            title: const Text('CKD Map'),
          ),
          SalomonBottomBarItem(
            selectedColor: Colors.brown,
            icon: const Icon(
              Icons.chat,
              size: 20,
            ),
            title: const Text('Chatbot'),
          ),
          SalomonBottomBarItem(
            selectedColor: Colors.blue[200],
            icon: const Icon(
              Icons.assignment_outlined,
              size: 20,
            ),
            title: const Text('My Data'),
          ),
          SalomonBottomBarItem(
            selectedColor: Colors.pinkAccent[100],
            icon: const Icon(
              Icons.water_drop,
              size: 20,
            ),
            title: const Text('Hydration'),
          ),
          SalomonBottomBarItem(
            selectedColor: Colors.grey,
            icon: const Icon(
              Icons.settings,
              size: 20,
            ),
            title: const Text('Settings'),
          )
        ],
      )
  );
}