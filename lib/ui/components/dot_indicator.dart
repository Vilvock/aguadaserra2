import 'package:app/res/owner_colors.dart';
import 'package:flutter/material.dart';


class DotIndicator extends StatelessWidget {

  final bool isActive;
  final Color color;

  const DotIndicator({Key? key, this.isActive = false, required this.color}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(1, 24, 1, 24),
      child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: isActive ? 8 : 8,
          width: 8,
          decoration: BoxDecoration(
              color: isActive ? color : OwnerColors.lightGrey,
              borderRadius: BorderRadius.all(Radius.circular(10)))),
    );
  }
}