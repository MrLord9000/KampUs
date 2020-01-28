import 'package:flutter/material.dart';
import 'package:kamp_us/view_models/location.dart';

class LocationInfoPage extends StatefulWidget
{
  LocationInfoPage({Key key, this.location}) : super(key: key);

  final Location location;

  @override
  State<StatefulWidget> createState() => _LocationInfoPageState();
}

class _LocationInfoPageState extends State<LocationInfoPage>
{
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // Simple app bar with title
      appBar: AppBar(
        centerTitle: true,
        title: Text("Location Details"),
      ),

      body: Column(
        children: <Widget>[

          // Location name here as a title
          Container(
            child: Text(widget.location.name),
          ),

          Expanded(
            child: Container(

              // Location description goes here
              child: Text(widget.location.description)

            ),

          ),

        ],
      ),

    );

  }

}