import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'helpers/provider.dart';

class Settings extends StatefulWidget {
  final WebSocketChannel socket;
  const Settings({super.key, required this.socket});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return MapRectangleSelector(
      socket: widget.socket,
    );
  }
}

class MapRectangleSelector extends StatefulWidget {
  final WebSocketChannel socket;
  const MapRectangleSelector({Key? key, required this.socket})
      : super(key: key);

  @override
  _MapRectangleSelectorState createState() => _MapRectangleSelectorState();
}

class _MapRectangleSelectorState extends State<MapRectangleSelector> {
  List<Polygon> _rectangles = [];
  List<LatLng> _points = [];
  final List<Color> _colors = [Colors.blue, Colors.red];
  final Set<PolygonId> _uniquePolygons = {};

  GoogleMapController? _mapController;
  final Location _location = Location();
  LocationData? _currentLocation;
  late StreamSubscription _locationSub;

  void sendMessage(json) {
    widget.socket.sink.add(jsonEncode(json));
  }

  Set<Marker> _getMarkers() {
    return _points
        .map(
          (latLng) => Marker(
            markerId: MarkerId('${latLng.latitude}-${latLng.longitude}'),
            position: latLng,
          ),
        )
        .toSet();
  }

  void _onTap(LatLng point) {
    setState(() {
      if (_uniquePolygons.length >= 2) {
        return;
      }
      _points.add(point);
      if (_points.length == 2) {
        Polygon rectangle = Polygon(
          polygonId: PolygonId('rectangle-${_rectangles.length}'),
          points: _getRectanglePoints(),
          strokeWidth: 2,
          strokeColor: _colors[_rectangles.length],
          fillColor: _colors[_rectangles.length].withOpacity(0.3),
        );
        _rectangles.add(rectangle);
        _uniquePolygons.add(rectangle.polygonId);
        _points.clear();
      }
      if (_uniquePolygons.length == 2) {
        final json = {
          'clear_zone': [
            {
              'lat': _rectangles[0].points[0].latitude,
              'lon': _rectangles[0].points[0].longitude,
            },
            {
              'lat': _rectangles[0].points[1].latitude,
              'lon': _rectangles[0].points[1].longitude,
            }
          ],
          'snow_zone': [
            {
              'lat': _rectangles[1].points[0].latitude,
              'lon': _rectangles[1].points[0].longitude,
            },
            {
              'lat': _rectangles[1].points[1].latitude,
              'lon': _rectangles[1].points[1].longitude,
            }
          ]
        };
        sendMessage({'zones': json});
      }
    });
  }

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

  List<LatLng> _getRectanglePoints() {
    LatLng point1 = _points[0];
    LatLng point2 = _points[1];
    return [
      LatLng(point1.latitude, point1.longitude),
      LatLng(point1.latitude, point2.longitude),
      LatLng(point2.latitude, point2.longitude),
      LatLng(point2.latitude, point1.longitude),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Colors.white,
        child: const Text(
          'Reset',
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () {
          setState(() {
            _points = [];
            _rectangles = [];
            _uniquePolygons.clear();
          });
        },
      ),
      body: Stack(
        children: [
          Consumer<AppData>(
            builder: (context, data, child) => GoogleMap(
              markers: _getMarkers(),
              mapType: MapType.satellite,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              onTap: _onTap,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              polygons: Set<Polygon>.of(_rectangles),
              initialCameraPosition: _currentLocation != null
                  ? CameraPosition(
                      target: LatLng(
                        _currentLocation!.latitude!,
                        _currentLocation!.longitude!,
                      ),
                      zoom: 23.0,
                    )
                  : CameraPosition(
                      target: data.initialPosition,
                      zoom: 23,
                    ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: FractionallySizedBox(
              child: Container(
                width: 285,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Click once to add snow removal zone. Click again to add snow deposit zone.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
