import 'dart:math';

import 'package:flutter/material.dart';

mixin DialogService {
  Future<T?> showAnimatedDialog<T>({
    required BuildContext context,
    required Widget dialog,
    Function(T)? onValue,
    Function? onDismiss,
  }) =>
      showGeneralDialog<T>(
        context: context,
        pageBuilder: (context, _, __) => dialog,
        barrierLabel: 'Dialog' + Random().nextInt(1000).toString(),
        barrierDismissible: true,
        transitionDuration: Duration(milliseconds: 300),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
}
