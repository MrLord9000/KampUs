import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kamp_us/models.dart';

// Primary tags enum class
enum Category { 
  Dining,
  University,
  Entertainment,
  Parking,
  Emergency,
  Other,
}

class CategoryIcon {
  static CategoryIcon _instance = CategoryIcon._init();

  static BuildContext _context;

  BitmapDescriptor _entertainmentIcon;
  BitmapDescriptor _universityIcon;
  BitmapDescriptor _diningIcon;
  BitmapDescriptor _parkingIcon;
  BitmapDescriptor _emergencyIcon;
  BitmapDescriptor _otherIcon;
  BitmapDescriptor _newIcon;

  BitmapDescriptor get entertainmentIcon => _entertainmentIcon;
  BitmapDescriptor get universityIcon => _universityIcon;
  BitmapDescriptor get diningIcon => _diningIcon;
  BitmapDescriptor get parkingIcon => _parkingIcon;
  BitmapDescriptor get emergencyIcon => _emergencyIcon;
  BitmapDescriptor get otherIcon => _otherIcon;
  BitmapDescriptor get newIcon => _newIcon;

  factory CategoryIcon(BuildContext context) {
    _context = context;
    return _instance;
  }

  CategoryIcon._init() {
    _populate();
  }

  BitmapDescriptor iconFromCategory(Category category)
  {
    BitmapDescriptor output = BitmapDescriptor.defaultMarker;
    switch(category)
    {
      case Category.Dining:
        output = _diningIcon;
        break;
      case Category.University:
        output = _universityIcon;
        break;
      case Category.Entertainment:
        output = _entertainmentIcon;
        break;
      case Category.Parking:
        output = _parkingIcon;
        break;
      case Category.Emergency:
        output = _emergencyIcon;
        break;
      case Category.Other:
        output = _otherIcon;
        break;
    }
    return output;
  }

  _populate() async {
    MediaQueryData data = MediaQuery.of(_context);
    double ratio = data.devicePixelRatio;
    

    _entertainmentIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), imageDir("images/map_icons", "Entertainment_icon.png", ratio));
    _universityIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), imageDir("images/map_icons", "University_icon.png", ratio));
    _diningIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), imageDir("images/map_icons", "Dining_icon.png", ratio));
    _parkingIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), imageDir("images/map_icons", "Parking_icon.png", ratio));
    _emergencyIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), imageDir("images/map_icons", "Emergency_icon.png", ratio));
    _otherIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), imageDir("images/map_icons", "Unknown_icon.png", ratio));
    _newIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), imageDir("images/map_icons", "New_icon.png", ratio));
  }

  String imageDir(String prefix, String fileName, double pixelRatio) {
    String directory = '/1.0x/';
    //xd
    if (pixelRatio >= 1.5) {
        directory = '/2.0x/';
    }
    if (pixelRatio >= 2.5) {
        directory = '/3.0x/';
    }
    if (pixelRatio >= 3.5) {
        directory = '/4.0x/';
    }
    
    return '$prefix$directory$fileName';
  }
}

Category categoryFromString(String string) {
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

Color colorFromCategory(Category category) {
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

String imagePathFromCategory(Category category)
{
  String path;
  switch (category)
  {
    case Category.Dining:
      path = "images/Dining_icon.png";
      break;
    case Category.University:
      path = "images/University_icon.png";
      break;
    case Category.Entertainment:
      path = "images/Entertainment_icon.png";
      break;
    case Category.Parking:
      path = "images/Parking_icon.png";
      break;
    case Category.Emergency:
      path = "images/Emergency_icon.png";
      break;
    case Category.Other:
      path = "images/Other_icon.png";
      break;
  }
  return path;
}

IconData iconFromCategory(Category category)
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
    case Category.Other:
      outIcon = Icons.help;
      break;
  }
  return outIcon;
}


class Location {

  bool isValid = false;
  
  double latitude;
  double longitude;

  int id;

  String name;
  String description;

  AccountModel creator;

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
            this.creator,
            this.category,
            this.tags,
            this.comments,
            this.id,
            this.thumbs,
            this.isVerified});

}