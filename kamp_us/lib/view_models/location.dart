import 'package:flutter/material.dart';

// Primary tags enum class
enum Category { 
  Dining,
  University,
  Entertainment,
  Parking,
  Emergency
}

extension CategoryExtension on Category {

  Color color(Category category) {
    Color outColor;
    switch(category)
    {
      case Category.Dining:
        outColor = Colors.orange[400];
        break;
      case Category.University:
        outColor = Color.fromARGB(255, 139, 0, 2);
        break;
      case Category.Entertainment:
        outColor = Colors.purple[400];
        break;
      case Category.Parking:
        outColor = Colors.blue;
        break;
      case Category.Emergency:
        outColor = Colors.white;
        break;
    }
    return outColor;
  }

  IconData icon(Category category)
  {
    IconData outIcon;
    switch(category)
    {
      case Category.Dining:
        outIcon = Icons.restaurant_menu;
        break;
      case Category.University:
        outIcon = Icons.school;
        break;
      case Category.Entertainment:
        outIcon = Icons.whatshot;
        break;
      case Category.Parking:
        outIcon = Icons.local_parking;
        break;
      case Category.Emergency:
        outIcon = Icons.local_hospital;
        break;
    }
    return outIcon;
  }

}

class Location {

  bool isValid = false;
  
  double latitude;
  double longitude;

  String name;
  String description;

  String accountNickname;

  bool isVerified;

  Category category;

  List<String> tags;
  
  Location({this.latitude, 
            this.longitude, 
            this.name, 
            this.description, 
            this.accountNickname,
            this.category,
            this.tags});

}