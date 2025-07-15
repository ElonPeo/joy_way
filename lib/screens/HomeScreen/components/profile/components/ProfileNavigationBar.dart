import 'package:flutter/material.dart';

import '../../../../../config/GeneralSpecifications.dart';

class ProfileNavigationBar extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return SizedBox(
      width: specs.screenWidth,
      child: Row(
        children: [

        ],
      )
    );
  }
}