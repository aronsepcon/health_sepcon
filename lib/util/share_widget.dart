import 'package:flutter/material.dart';

widgetErrorDialog(String message,BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      );
    },
  );
}