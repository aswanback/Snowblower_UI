import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppData extends ChangeNotifier {
  DateTime? scheduledClearTime;
  LatLng initialPosition;

  AppData({this.initialPosition = const LatLng(40.433273, -86.913523)});

  void setScheduledClearTime(DateTime t) {
    scheduledClearTime = t;
    notifyListeners();
  }

  void setLatLng(LatLng ll) {
    initialPosition = ll;
    notifyListeners();
  }
}
