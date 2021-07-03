import 'package:flutter/material.dart';

class BackgroundUpload with ChangeNotifier {
  bool _isUploading = false;
  bool get isUploading => _isUploading;
  DateTime _lastUpload = DateTime.now();
  DateTime get lastUpload => _lastUpload;

  set isUploading(bool trigger) {
    if (trigger) {
      DateTime dateNow = DateTime.now();
      _lastUpload = dateNow;
      _isUploading = true;
    } else {
      _isUploading = false;
    }
    notifyListeners();
  }
}
