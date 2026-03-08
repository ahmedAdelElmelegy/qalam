import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

extension Navigation on BuildContext {
  Future<dynamic> push(Widget child) => Navigator.of(
    this,
  ).push(PageTransition(child: child, type: PageTransitionType.rightToLeft));

  void pushAndRemoveUntil(Widget child) =>
      Navigator.of(this).pushAndRemoveUntil(
        PageTransition(child: child, type: PageTransitionType.fade),
        (route) => false,
      );

  void pushReplacement(Widget child) => Navigator.of(this).pushReplacement(
    PageTransition(child: child, type: PageTransitionType.fade),
  );

  void pop() => Navigator.of(this).pop();
}
