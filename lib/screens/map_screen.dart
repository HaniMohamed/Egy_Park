import 'dart:async';

import 'package:egy_park/widgets/floating_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  double _lat = 13.0827;
  double _lng = 80.2707;
  Completer<GoogleMapController> _controller = Completer();
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  CameraPosition _currentPosition;

  @override
  initState() {
    super.initState();
    _locateMe();
    _currentPosition = CameraPosition(
      target: LatLng(_lat, _lng),
      zoom: 12,
    );
  }

  _locateMe() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    await location.getLocation().then((res) async {
      final GoogleMapController controller = await _controller.future;
      final _position = CameraPosition(
        target: LatLng(res.latitude, res.longitude),
        zoom: 12,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(_position));
      setState(() {
        _lat = res.latitude;
        _lng = res.longitude;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              initialCameraPosition: _currentPosition,
              markers: {
                Marker(
                  markerId: MarkerId('marker1'),
                  position: LatLng(_lat + 0.0225, _lng + 0.0305),
                  onTap: () {
                    Navigator.of(context).pushNamed("/details");
                  },
                ),
                Marker(
                  markerId: MarkerId('marker2'),
                  position: LatLng(_lat - 0.0225, _lng - 0.0305),
                  onTap: () {
                    Navigator.of(context).pushNamed("/details");
                  },
                )
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: FloatingAppBar(),)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.my_location),
        onPressed: () => _locateMe(),
      ),
    );
  }
}
