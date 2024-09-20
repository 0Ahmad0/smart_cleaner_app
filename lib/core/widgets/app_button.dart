import '/core/utils/color_manager.dart';
import '/core/utils/style_manager.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.onPressed, required this.text});

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.primaryColor),
        onPressed: onPressed,
        child: Text(
          text,
          style: StyleManager.font16Regular(color: ColorManager.whiteColor),
        ));
  }
}
