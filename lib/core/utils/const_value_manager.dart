import 'string_manager.dart';

class ConstValueManager {
  /// Design Size
  static const double widthSize = 393.0;
  static const double heightSize = 852.0;

  static const int animationDuration = 600;
  static const int activitiesTabBar = 3;

  /// Duration Delayed Second
  static const int delayedSplash = 3;

  /// Button Size
  static const double heightButtonSize = 56;

  /// Length  Appointments TabBar
  static const int lengthAppointmentsTabBar = 3;

  /// Locale Language Code

  static const String arLanguageCode = 'ar';
  static const String enLanguageCode = 'en';

  ///Role Strings
  static const String worker = 'Worker';
  static const String guest = 'Guest';
  static  String role = '';

  static const List<String> roleList = [
    worker,
    guest
  ];

  static List<ConditionPasswordItem> conditionPasswordList = [
    ConditionPasswordItem(text: StringManager.condition1Text),
    ConditionPasswordItem(text: StringManager.condition2Text),
    ConditionPasswordItem(text: StringManager.condition3Text),
    ConditionPasswordItem(text: StringManager.condition4Text),
  ];
}
class ConditionPasswordItem {
  final String text;
  bool isValidate;

  ConditionPasswordItem({required this.text, this.isValidate = false});
}
