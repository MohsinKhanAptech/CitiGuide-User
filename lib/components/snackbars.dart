import 'package:flutter/material.dart';

void processingRequestSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text('Processing Request.'),
      ),
    ),
  );
}

void somethingWentWrongSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text('Something went wrong.'),
      ),
    ),
  );
}
