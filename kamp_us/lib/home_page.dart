import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kamp_us/api.dart';
import 'add_marker.dart';
import 'location_info_page.dart';
import 'side_menu.dart';

import 'sliding_panel.dart';
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
  List<Location> locations;
  Category _filterCategory = Category.Other;
  Marker _newMarker;
  final MarkerId newMarkerId = MarkerId("new_marker");
  GoogleMapController mapController;
  Position _center = Position(latitude: 51.753710, longitude: 19.451742);
  double _zoom = 14.0;

  _updateMarkerFiltering(Category category) {
    _filterCategory = category;
    _updateScreenMarkers();
  }

  _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // Here you should retrieve all the markers from screen you're currently on
    _getScreenLocations();
  }

  _getScreenLocations() async {
    LatLngBounds screenBounds = await mapController.getVisibleRegion();
    // Get screen markers depending on screen coordinates
    locations = await API.loadLocationsInRange(
      screenBounds.southwest.longitude, 
      screenBounds.northeast.longitude, 
      screenBounds.southwest.latitude, 
      screenBounds.northeast.latitude, 
      () {
        print("successfully downloaded markers");
        }, 
      () {
        print("marker download error");
        showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(content: Text("Nie udało się pobrać zawartości, spróbuj ponownie później"));
          }
        );
      });
      _updateScreenMarkers();
  }

  _updateScreenMarkers() {
    _markers.clear();

    for (var location in locations)
    {
      if (_filterCategory == Category.Other || location.category == _filterCategory)
      {
        final marker = Marker(
          markerId: MarkerId(location.id.toString()),
          position: LatLng(location.latitude, location.longitude),
          icon: CategoryIcon(context).iconFromCategory(location.category),
          infoWindow: InfoWindow(
              title: location.name,
              snippet: "Dotknij aby zobaczyć szczegóły",
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => LocationInfoPage(location: location)
                    )
                );
              },
            ),
        );
        _markers[location.id.toString()] = marker;
      }
    }
    setState(() {});

    if (_newMarker != null)
    {
      setState(() {
        _markers["new_marker"] = _newMarker;
      });
    }
  }

  _onCreateMarker(LatLng latLng) async {
    _newMarker = Marker(
      markerId: newMarkerId,
      position: latLng,
      icon: CategoryIcon(context).newIcon,
      infoWindow: InfoWindow(
        title: "Utwórz nowy znacznik",
        snippet: "Dotknij aby kontynuować",
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddMarkerPage(latLng: latLng),
            )
          );
        },
      ),
    );
    setState(() {
      _markers["new_marker"] = _newMarker;
    });
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
            onCameraIdle: _getScreenLocations,
            onTap: _onCreateMarker,
            onLongPress: _onCreateMarker,
            
            initialCameraPosition: CameraPosition(
              target: LatLng(_center.latitude, _center.longitude),
              zoom: _zoom,
            ),
            
            markers: _markers.values.toSet(),
            compassEnabled: true,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,

          ),

          Container(
            alignment: Alignment(0.0, 0.675),
            child: FlatButton(
              child: Text("Dodaj znacznik",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'CastleT',
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
              ),
              onPressed: () {},
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Color.fromARGB(255, 76, 175, 80),
              splashColor: Color.fromARGB(255, 89, 207, 94),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
          ),

          CategoryTagPanel(
            onFilterChange: _updateMarkerFiltering,
          )
        ],
      ),

      drawer: SideMenu(),

    );
  }
}

