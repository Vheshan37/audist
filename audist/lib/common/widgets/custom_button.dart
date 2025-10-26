import 'package:audist/core/color.dart';
import 'package:audist/core/sizes.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget content;
  final VoidCallback onPressed;
  final double radius;
  final EdgeInsetsGeometry? padding;
  const CustomButton({
    super.key,
    required this.content,
    required this.onPressed,
    this.radius = 4,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: AppSizes.buttonHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
          gradient: LinearGradient(
            colors: [
              Color(0xFF423736), // start color
              Color(0xFF987185), // end color
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: content,
      ),
    );
  }
}
