import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

mixin Messages<T extends StatefulWidget> on State<T> {
  void showError(String message) {
    _showTopSnackBar(CustomSnackBar.error(message: message), context);
  }

  void showWarning(String message) {
    _showTopSnackBar(CustomSnackBar.info(message: message), context);
  }

  void showInfo(String message) {
    _showTopSnackBar(CustomSnackBar.info(message: message), context);
  }

  void showSuccess(String message) {
    _showTopSnackBar(CustomSnackBar.success(message: message), context);
  }

  void _showTopSnackBar(CustomSnackBar snackBar, BuildContext context) {
    final overlay = Overlay.of(context);

    showTopSnackBar(
      overlay,
      snackBar,
    );
  }
}