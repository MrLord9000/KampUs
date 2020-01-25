import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class AddMarkerPage extends StatefulWidget {
  AddMarkerPage({Key key, this.latLng}) : super(key: key);

  final LatLng latLng;

  @override
  _AddMarkerPageState createState() => _AddMarkerPageState();
}

class _AddMarkerPageState extends State<AddMarkerPage> {

  final _placeNameController = TextEditingController();
  final _placeDescriptionController = TextEditingController();
  final _tagController = TextEditingController();

  void _sendMarkerToDatabase() {

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dodaj znacznik"),
      ),
      body: Column(
        children: <Widget>[
        
        GoogleMap(
          initialCameraPosition: CameraPosition(target: widget.latLng),
        ),

        Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Nazwa miejsca"),
              TextField(
                controller: _placeNameController,
                maxLines: 1,
                decoration: InputDecoration(fillColor: Theme.of(context).accentColor)
              ),
              Padding(padding: EdgeInsets.only(top: 16.0),),
              Text("Opis miejsca"),
              TextField(
                controller: _placeDescriptionController,
                decoration: InputDecoration(fillColor: Theme.of(context).accentColor)
              ),
              Padding(padding: EdgeInsets.only(top: 16.0),),
              Text("Tagi"),
              TextField(
                controller: _tagController,
                decoration: InputDecoration(fillColor: Theme.of(context).accentColor)
              )

            ],
          )
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Text("Dodaj"),
              onPressed: _sendMarkerToDatabase,
            )
          ],
        )
        
      ],),
    );

  }

}