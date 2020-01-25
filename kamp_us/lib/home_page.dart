import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kamp_us/mock_models/location_mocks.dart';
import 'add_marker.dart';
import 'side_menu.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'view_models/location.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> { 

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Map<String, Marker> _markers = {};
  GoogleMapController mapController;
  Position _center = Position(latitude: 51.753710, longitude: 19.451742);
  double _zoom = 14.0;

  _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // Here you should retrieve all the markers from screen you're currently on
    _getScreenMarkers();
  }

  _getScreenMarkers() {
    _markers.clear();

    // TODO: Remove mockup and add api functionality
    List<Location> locations = LocationMocks.getLocations(0, 1, 0, 1);

    for (var location in locations)
    {
      final marker = Marker(
        // TODO: Not a good practice - change to unique value later
        markerId: MarkerId(location.name),
        position: LatLng(location.latitude, location.longitude),
        // TODO: Add onTap action to display location information
        infoWindow: InfoWindow(title: location.name),
      );
      setState(() {
        _markers[location.name] = marker;
      });
    }

  }

  _onCreateMarker(LatLng latLng) {
    
    setState(() {
      final newMarker = Marker(
        markerId: MarkerId("new_marker"),
        position: latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
      );
      _markers["New Marker"] = newMarker;
    });

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => AddMarkerPage(),
      )
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Show menu',
            alignment: Alignment.center,
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),

      ),
      body: Stack(
        children: <Widget>[

          GoogleMap(
            onMapCreated: _onMapCreated,
            onCameraIdle: _getScreenMarkers,
            
            initialCameraPosition: CameraPosition(
              target: LatLng(_center.latitude, _center.longitude),
              zoom: _zoom,
            ),
            
            markers: _markers.values.toSet(),
            compassEnabled: true,
            onLongPress: _onCreateMarker,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,

          ),

          SlidingUpPanel(
            panel: Center(
              child: Text('markers')
            )
          )
        ],
      ),

      drawer: SideMenu(),

    );
  }
}
