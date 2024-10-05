import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';

class OtherAdminScreen extends StatelessWidget {
  const OtherAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringManager.otherText.toUpperCase(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: Text(
              'COMING SOON...',
              textAlign: TextAlign.center,
              style: StyleManager.font30Bold(
                color: ColorManager.primaryColor
              ),
            ),
          )
        ],
      ),
    );
  }
}
