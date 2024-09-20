import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/utils/assets_manager.dart';

class BackgroundAppWidget extends StatelessWidget {
  const BackgroundAppWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          AssetsManager.backGroundAppIcon,
          width: double.maxFinite,
          height: double.maxFinite,
          fit: BoxFit.cover,
        ),

      ],
    );
  }
}
