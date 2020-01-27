import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'api.dart';
import 'view_models/location.dart';


class AddMarkerPage extends StatefulWidget {
  AddMarkerPage({Key key, this.latLng}) : super(key: key);

  final LatLng latLng;

  @override
  _AddMarkerPageState createState() => _AddMarkerPageState();
}

class _AddMarkerPageState extends State<AddMarkerPage> {

  Category _categorySelected;
  final _placeNameController = TextEditingController();
  final _placeDescriptionController = TextEditingController();
  final _tagController = TextEditingController();

  void _sendMarkerToDatabase() {
    API.createLocation(
      Location(
        latitude: widget.latLng.latitude,
        longitude: widget.latLng.longitude,
        category: _categorySelected,
        name: _placeNameController.text,
        description: _placeDescriptionController.text,
        tags: _tagController.text.split(" ")
      ), 
      () {print("Added location successfully");}, 
      (String msg) {print(msg);});
  }

  void _onCategoryChanged(Category value) {
    setState(() {
      _categorySelected = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dodaj znacznik"),
      ),
      body: Column(
        children: <Widget>[

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
              Text("Kategoria"),
              Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  Radio(
                    value: Category.Dining,
                    groupValue: _categorySelected,
                    onChanged: _onCategoryChanged,
                  ),
                  Text("Jedzenie"),
                  Radio(
                    value: Category.Entertainment,
                    groupValue: _categorySelected,
                    onChanged: _onCategoryChanged,
                  ),
                  Text("Rozrywka"),
                  Radio(
                    value: Category.University,
                    groupValue: _categorySelected,
                    onChanged: _onCategoryChanged,
                  ),
                  Text("Uczelnia"),
                  Radio(
                    value: Category.Parking,
                    groupValue: _categorySelected,
                    onChanged: _onCategoryChanged,
                  ),
                  Text("Parking"),
                  Radio(
                    value: Category.Emergency,
                    groupValue: _categorySelected,
                    onChanged: _onCategoryChanged,
                  ),
                  Text("Alarmowe"),
                ],
              ),
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