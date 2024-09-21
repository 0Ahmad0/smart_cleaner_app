import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';

import '../../core/utils/assets_manager.dart';
import '../../core/widgets/custome_back_button.dart';

class BackgroundAppWidget extends StatelessWidget {
  const BackgroundAppWidget({
    super.key,
    required this.child,
    this.visibleBackIcon = false,
  });

  final Widget child;
  final bool visibleBackIcon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Bounce(
          child: SvgPicture.asset(
            AssetsManager.backGroundAppIcon,
            width: double.maxFinite,
            height: double.maxFinite,
            fit: BoxFit.cover,
          ),
        ),
        Visibility(visible: visibleBackIcon, child: SafeArea(child: CustomBackButton())),
        child,
      ],
    );
  }
}
