
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_bottom_navbar.dart';
import '../../../dashboard/presentation/views/dashboard_view.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({
    super.key,
  });

  @override
  State<MainNavigationView> createState() =>
      _MainNavigationViewState();
}

class _MainNavigationViewState
    extends State<MainNavigationView> {

  int currentIndex = 0;

  final pages = [

    const DashboardView(),
    Container(),
    Container(),

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      bottomNavigationBar:
      CustomBottomNavBar(

        currentIndex: currentIndex,

        onTap: (index) {

          setState(() {

            currentIndex = index;

          });

        },
      ),
    );
  }
}