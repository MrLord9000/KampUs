import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void openPageUstawienia(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(
    builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ustawienia'),
        ),
        body: const Center(
          child: Text(
            'Tutaj beda ustawienia',
            style: TextStyle(fontSize: 24),
          ),
        ),
      );
    },
  ));
}

void openPageUlubione(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(
    builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ulubione'),
        ),
        body: const Center(
          child: Text(
            'Tutaj beda ulubione lokacje',
            style: TextStyle(fontSize: 24),
          ),
        ),
      );
    },
  ));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  GoogleMapController mapController;
  final LatLng _center = const LatLng(51.746920, 19.453656);
  final Map<String, Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _getLocation() async {
    Position currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      _markers.clear();
      final marker = Marker(
          markerId: MarkerId("curr_loc"),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers["Current Location"] = marker;
    });

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

            },
          ),

      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers.values.toSet(),


      ),



      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('KampUs'),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            ListTile(
                title: Text('Ustawienia'),
                onTap:() {
                  //tutaj otwarcie nowego okna
                  openPageUstawienia(context);
                }
            ),
            ListTile(
              title: Text('Ulubione'),
              onTap: () {
                openPageUlubione(context);
              },
            ),

          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _getLocation,
        tooltip: 'Get Location',
        child: Icon(Icons.flag),
      ),
    );
  }
}
