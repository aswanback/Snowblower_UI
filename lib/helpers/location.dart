import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:ui_463/helpers/provider.dart';

class LiveLocationMap extends StatefulWidget {
  const LiveLocationMap({super.key});

  @override
  _LiveLocationMapState createState() => _LiveLocationMapState();
}

class _LiveLocationMapState extends State<LiveLocationMap> {
  GoogleMapController? _mapController;
  final Location _location = Location();
  LocationData? _currentLocation;
  late StreamSubscription _locationSub;

  @override
  void dispose() {
    _locationSub.cancel(); // cancel the stream subscription
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _locationSub =
        _location.onLocationChanged.listen((LocationData locationData) {
      if (mounted) {
        setState(() {
          _currentLocation = locationData;
        });
      }
      if (_currentLocation?.latitude != null &&
          _currentLocation?.longitude != null) {
        final latLng =
            LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
        _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
      }
    });

    _location.getLocation().then((LocationData locationData) {
      if (mounted) {
        setState(() {
          _currentLocation = locationData;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppData>(
        builder: (context, data, child) => GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          mapType: MapType.satellite,
          initialCameraPosition: _currentLocation != null
              ? CameraPosition(
                  target: LatLng(_currentLocation!.latitude!,
                      _currentLocation!.longitude!),
                  zoom: 20.0,
                )
              : CameraPosition(target: data.initialPosition, zoom: 20),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
      ),
    );
  }
}
