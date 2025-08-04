import 'package:flutter/material.dart';

class Snackbar {
  static void showSuccess(
      BuildContext context,
      String message, {
        int seconds = 2,
      }) {
    _show(
      context: context,
      message: message,
      backgroundColor: Colors.green,
      duration: Duration(seconds: seconds),
    );
  }

  static void showError(
      BuildContext context,
      String message, {
        int seconds = 2,
      }) {
    _show(
      context: context,
      message: message,
      backgroundColor: Colors.red,
      duration: Duration(seconds: seconds),
    );
  }

  static void _show({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required Duration duration,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }
}
