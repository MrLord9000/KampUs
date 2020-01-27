import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kamp_us/api.dart';
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
  Marker _newMarker;
  GoogleMapController mapController;
  Position _center = Position(latitude: 51.753710, longitude: 19.451742);
  double _zoom = 14.0;

  _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // Here you should retrieve all the markers from screen you're currently on
    _getScreenMarkers();
  }

  _getScreenMarkers() async {
    _markers.clear();

    if (_newMarker != null)
    {
      _markers["new_marker"] = _newMarker;
    }

    LatLngBounds screenBounds = await mapController.getVisibleRegion();
    // Get screen markers depending on screen coordinates
    List<Location> locations = await API.loadLocationsInRange(
      screenBounds.southwest.longitude, 
      screenBounds.northeast.longitude, 
      screenBounds.southwest.latitude, 
      screenBounds.northeast.latitude, 
      () {
        print("successfully downloaded markers");
        }, 
      () {
        print("marker download error");
        // showDialog(context: context,
        // builder: (BuildContext context) {
        //   return AlertDialog(content: Text("Nie udało się pobrać zawartości, spróbuj ponownie później"));
        //   }
        // );
      });

    for (var location in locations)
    {
      final marker = Marker(
        markerId: MarkerId(location.id.toString()),
        position: LatLng(location.latitude, location.longitude),
        // icon: BitmapDescriptor.fromAssetImage(
        //   ImageConfiguration(),
          
        //   ),
        // TODO: Add onTap action to display location information
        infoWindow: InfoWindow(title: location.name),
      );
      setState(() {
        _markers[location.id.toString()] = marker;
      });
    }
  }

  _onCreateMarker(LatLng latLng) {
    MarkerId newMarkerId =  MarkerId("new_marker");
    setState(() {
      _newMarker = Marker(
        markerId:newMarkerId,
        position: latLng,
        infoWindow: InfoWindow(
          title: "Utwórz nowy znacznik",
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => AddMarkerPage(latLng: latLng),
              )
            );
          },
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
      );
      _markers["new_marker"] = _newMarker;
    });
    
    //mapController.showMarkerInfoWindow(newMarkerId);
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
            onTap: (latLng) {
              setState(() {
                _markers.remove("new_marker");
              });
            },
            
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
