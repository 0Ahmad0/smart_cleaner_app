import 'package:flutter/material.dart';

showAppDialog(BuildContext context, {required Widget child}) {
  showDialog(
    context: context,
    builder: (context) => child,
  );
}
