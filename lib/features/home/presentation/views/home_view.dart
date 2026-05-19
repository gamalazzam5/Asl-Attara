import 'package:flutter/material.dart';

import '../../../../core/constants/text_style.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('أصل العطارة',style: TextStyles.text24,),
        ],
      ),
    );
  }
}
