import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/app/widgets/back_ground_app_widget.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/routing/routes.dart';
import 'package:smart_cleaner_app/core/utils/assets_manager.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/const_value_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_button.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';

import '../../core/utils/app_constant.dart';
import '../../core/widgets/custome_back_button.dart';
import '../controllers/auth_controller.dart';
import '../widgets/container_gray_widget.dart';
import '../widgets/hello_top_widget.dart';

class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({super.key});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  late AuthController authController;
  @override
  void initState() {
    authController= Get.put(AuthController());
    authController.init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundAppWidget(
        visibleBackIcon: true,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(100.h),
              HelloTopWidget(),
              verticalSpace(30.h),
              Expanded(
                child: ContainerGrayWidget(
                  child: AppPaddingWidget(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StringManager.createNewAccountText,
                          style: StyleManager.font30SemiBold(
                              color: ColorManager.primaryColor),
                        ),
                        const Spacer(),
                        Text(
                          StringManager.chooseYourWorkTitleText.toUpperCase(),
                          style: StyleManager.font16Regular(
                              color: ColorManager.primaryColor),
                        ),
                        verticalSpace(20.h),
                        StatefulBuilder(builder: (context, roleSetState) {
                          return DropdownButtonFormField(
                            icon: Icon(Icons.keyboard_arrow_down),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide.none),
                                filled: true,
                                fillColor: ColorManager.whiteColor,
                                hintText: StringManager.selectWorkTitleText),
                            items: ConstValueManager.roleList
                                .map((e) => DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              roleSetState(() {
                                ConstValueManager.role = value.toString();
                              });
                            },
                          );
                        }),
                        verticalSpace(40.h),
                        AppButton(
                            onPressed: () {

                              if(ConstValueManager.role.contains(ConstValueManager.guest)){
                                authController.typeUser=AppConstants.collectionUser;
                              context.pushReplacement(Routes.signUpRoute);
                              }else{
                                authController.typeUser=AppConstants.collectionWorker;
                                context.pushReplacement(Routes.signUpRoute);
                              }
                            },
                            text: StringManager.nextText),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
