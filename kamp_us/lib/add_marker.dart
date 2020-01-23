import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'model/place.dart';

class AddMarkerPage extends StatefulWidget {
  AddMarkerPage({Key key, this.latLng}) : super(key: key);

  LatLng latLng;
  Place place;

  @override
  _AddMarkerPageState createState() => _AddMarkerPageState();
}

class _AddMarkerPageState extends State<AddMarkerPage> {



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dodaj znacznik"),
      ),
    );

  }

}