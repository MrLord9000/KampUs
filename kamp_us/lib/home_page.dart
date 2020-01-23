import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'add_marker.dart';
import 'side_menu.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> { 

  GoogleMapController mapController;
  final LatLng _center = const LatLng(51.746920, 19.453656);
  final Map<String, Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _centerPosition() async {
    Position currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 11.0
            )
          )
        );
      // _markers.clear();
      // final marker = Marker(
      //     markerId: MarkerId("curr_loc"),
      //     position: LatLng(currentLocation.latitude, currentLocation.longitude),
      //     infoWindow: InfoWindow(title: 'Your Location'),
      // );
      // _markers["Current Location"] = marker;
    });

  }

  void _onCreateMarker(LatLng latLng) {

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => AddMarkerPage(),
      )
    );

  }

  @override
  Widget build(BuildContext context) {
        
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Show menu',
            alignment: Alignment.center,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),

      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: _markers.values.toSet(),
            compassEnabled: true,
            onLongPress: _onCreateMarker,

          ),

          SlidingUpPanel(
            panel: Center(
              child: Text('markers')
            )
          )
        ],
      ),



      drawer: SideMenu(),


      floatingActionButton: FloatingActionButton(
        onPressed: _centerPosition,
        tooltip: 'Center Position',
        child: Icon(Icons.my_location),
      ),

    );
  }
}
