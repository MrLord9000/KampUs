import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kamp_us/models.dart';

// Primary tags enum class
enum Category { 
  Dining,
  University,
  Entertainment,
  Parking,
  Emergency,
  Other
}

Category CategoryFromString(String string) {
  switch(string)
  {
    case "Dining":        return Category.Dining;
    case "University":    return Category.University;
    case "Entertainment": return Category.Entertainment;
    case "Parking":       return Category.Parking;
    case "Emergency":     return Category.Emergency;
    case "Other":         return Category.Other;
    default:              return null;
  }
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
      case Category.Other:
        outColor = Colors.blueGrey;
        break;
    }
    return outColor;
  }

  IconData icon()
  {
    IconData outIcon;
    switch(this)
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
      case Category.Other:
        outIcon = Icons.help;
        break;
    }
    return outIcon;
  }

}

class Location {

  bool isValid = false;
  
  double latitude;
  double longitude;

  int id;

  String name;
  String description;

  String accountNickname;

  bool isVerified;

  Category category;

  List<CommentModel> comments;
  List<String> tags;
  int thumbs;
  //TODO comments
  
  Location({this.latitude, 
            this.longitude, 
            this.name, 
            this.description, 
            this.accountNickname,
            this.category,
            this.tags,
            this.comments,
            this.id,
            this.thumbs,
            this.isVerified});

}