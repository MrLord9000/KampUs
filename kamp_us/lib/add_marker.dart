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
    Navigator.pop(context);
  }

  void _onCategoryChanged(Category value) {
    setState(() {
      _categorySelected = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Dodaj znacznik"),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                      decoration: InputDecoration(fillColor: Theme.of(context).accentColor),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                    Padding(padding: EdgeInsets.only(top: 16.0),),
                    Text("Kategoria"),
                    Padding(padding: EdgeInsets.only(bottom: 16)),
                    Wrap(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Container(

                            width: MediaQuery.of(context).size.width/6,
                            margin: EdgeInsets.all(2.5),
                            color: Colors.yellow,
                            child: Column(
                              children: <Widget>[
                                Radio(
                                  value: Category.Dining,
                                  groupValue: _categorySelected,
                                  onChanged: _onCategoryChanged,
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 10)),
                                Text("Jedzenie"),
                              ],
                            )
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width/6,
                            margin: EdgeInsets.all(2.5),
                            color: Colors.purple,
                            child: Column(
                              children: <Widget>[
                                Radio(
                                  value: Category.Entertainment,
                                  groupValue: _categorySelected,
                                  onChanged: _onCategoryChanged,
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 10)),
                                Text("Rozrywka"),
                              ],
                            )
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width/6,
                            margin: EdgeInsets.all(2.5),
                            color: Colors.red,
                            child: Column(
                              children: <Widget>[
                                Radio(

                                  value: Category.University,
                                  groupValue: _categorySelected,
                                  onChanged: _onCategoryChanged,
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 10)),
                                Text("Uczelnia"),
                              ],
                            )
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width/6,
                            margin: EdgeInsets.all(2.5),
                            color: Colors.blue,
                            child: Column(
                              children: <Widget>[
                                Radio(
                                  value: Category.Parking,
                                  groupValue: _categorySelected,
                                  onChanged: _onCategoryChanged,
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 10)),
                                Text("Parking"),
                              ],
                            )
                        ),
                        Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width/6,
                            margin: EdgeInsets.all(2.5),
                            color: Colors.green,
                            child: Column(
                              children: <Widget>[
                                Radio(
                                  value: Category.Emergency,
                                  groupValue: _categorySelected,
                                  onChanged: _onCategoryChanged,
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 10)),
                                Text("Alarmowe"),

                              ],
                            )
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 16)),
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
                Container (
                  height: 40,
                  width:  MediaQuery.of(context).size.width-10,
                  alignment: Alignment.center,
                  child: Material (
                    borderRadius: BorderRadius.all(Radius.circular(5)),

                    color: Theme.of(context).primaryColor,
                    child: InkWell(
                      onTap: _sendMarkerToDatabase,
                      child: Center(
                        child: Text('Dodaj', style: TextStyle(color: Colors.white),),
                      ),
                    )
                  ),
                )
              ],
            )

          ],),
      )

    );

  }
}