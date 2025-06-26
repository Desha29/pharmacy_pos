import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

void motionSnackBarSuccess(BuildContext context, String message) {
  MotionToast.success(
    title: Text(message),
    toastDuration: Duration(seconds: 2),
    toastAlignment: Alignment.bottomRight,
    animationType: AnimationType.slideInFromLeft,
    description: SizedBox(),
    animationDuration: Duration(milliseconds: 400),
    animationCurve: Curves.easeInOut,
    opacity: 0.95,
  ).show(context);
}

void motionSnackBarError(BuildContext context, String message) {
  MotionToast.error(
    title: Text(message),
    toastDuration: Duration(seconds: 2),
    toastAlignment: Alignment.bottomRight,
    animationType: AnimationType.slideInFromLeft,
    description: SizedBox(),
    animationDuration: Duration(milliseconds: 400),
    animationCurve: Curves.easeInOut,
    opacity: 0.95,
  ).show(context);
}

void motionSnackBarInfo(BuildContext context, String message) {
  MotionToast.info(
    title: Text(message),
    toastDuration: Duration(seconds: 2),
    toastAlignment: Alignment.bottomRight,
    animationType: AnimationType.slideInFromLeft,
    description: SizedBox(),
    animationDuration: Duration(milliseconds: 400),
    animationCurve: Curves.easeInOut,
    opacity: 0.95,
  ).show(context);
}

void motionSnackBarWarning(BuildContext context, String message) {
  MotionToast.warning(
    title: Text(message),
    toastDuration: Duration(seconds: 2),
    toastAlignment: Alignment.bottomRight,
    animationType: AnimationType.slideInFromLeft,
    description: SizedBox(),
    animationDuration: Duration(milliseconds: 400),
    animationCurve: Curves.easeInOut,
    opacity: 0.95,
  ).show(context);
}