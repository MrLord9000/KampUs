import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'api.dart';
import 'models.dart';
import 'view_models/location.dart';

class CategoryTagPanel extends StatefulWidget {
  CategoryTagPanel({Key key, this.onFilterChange}) : super(key: key);

  final Function(Category) onFilterChange;

  @override
  _CategoryTagStatus createState() => _CategoryTagStatus();
}

class _CategoryTagStatus extends State<CategoryTagPanel> {
  List<TagModel> tags = new List<TagModel>();
  Category selectedFilter = Category.Other;

  _updateFilter(Category category) {
    if (selectedFilter == category)
    {
      widget.onFilterChange(Category.Other);
      setState(() {
        selectedFilter = Category.Other;
      });
    }
    else
    {
      widget.onFilterChange(category);
      setState(() {
        selectedFilter = category;
      });
    }
  }

  _onStartLoadTags() async {
    tags = await API.loadAllTags(() => {print('sukces')}, (x) => {print(x)});
  }

  BlendMode _getBlendMode(Category category) {
    if (selectedFilter == category || selectedFilter == Category.Other)
    {
      return BlendMode.dst;
    }
    else
    {
      return BlendMode.modulate;
    }
  }

  @override
  Widget build(BuildContext context) {
    _onStartLoadTags();

    return SlidingUpPanel(
        renderPanelSheet: true,
        minHeight: 80,
        color: Colors.grey[300],
        panel: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(4.0),
                      width: MediaQuery.of(context).size.width / 6,
                      child: GestureDetector(
                        child: Image.asset("images/category_panels/Entertainment_frame.png", 
                          color: Colors.grey,
                          colorBlendMode: _getBlendMode(Category.Entertainment),
                          ),
                        onTap: () {_updateFilter(Category.Entertainment);},
                        ),
                    ),
                    Container(
                        padding: EdgeInsets.all(4.0),
                        width: MediaQuery.of(context).size.width / 6,
                        child: GestureDetector(
                          child: Image.asset("images/category_panels/University_frame.png",
                            color: Colors.grey,
                            colorBlendMode: _getBlendMode(Category.University),
                          ),
                          onTap: () {_updateFilter(Category.University);},
                          )
                        ),
                    Container(
                        padding: EdgeInsets.all(4.0),
                        width: MediaQuery.of(context).size.width / 6,
                        child: GestureDetector(
                          child: Image.asset("images/category_panels/Dining_frame.png",
                            color: Colors.grey,
                            colorBlendMode: _getBlendMode(Category.Dining),
                          ),
                          onTap: () {_updateFilter(Category.Dining);},
                          )
                        ),
                    Container(
                        padding: EdgeInsets.all(4.0),
                        width: MediaQuery.of(context).size.width / 6,
                        child: GestureDetector(
                          child: Image.asset("images/category_panels/Parking_frame.png",
                            color: Colors.grey,
                            colorBlendMode: _getBlendMode(Category.Parking),
                          ),
                          onTap: () {_updateFilter(Category.Parking);},
                          )
                        ),
                    Container(
                        padding: EdgeInsets.all(4.0),
                        width: MediaQuery.of(context).size.width / 6,
                        child: GestureDetector(
                          child: Image.asset("images/category_panels/Emergency_frame.png",
                            color: Colors.grey,
                            colorBlendMode: _getBlendMode(Category.Emergency),
                          ),
                          onTap: () {_updateFilter(Category.Emergency);},
                          )
                        ),
                  ],
                ),
              ],
            ),
            Container(
                padding: EdgeInsets.only(top: 5.0),
                child: Wrap(
                  children: <Widget>[
                    for (int i = 0; i < tags.length; i++)
                      Container(
                          padding: EdgeInsets.all(5.0),
                          margin: EdgeInsets.all(5.0),
                          alignment: Alignment.center,
                          height: 30.0,
                          width: MediaQuery.of(context).size.width / 4,
                          child: Material(
                              borderRadius: BorderRadius.horizontal(),
                              elevation: 10.0,
                              color: Colors.redAccent,
                                child: InkWell(
                                  onTap: () {
                                    //Tutaj wybierz tag czy co
                                    print(tags.elementAt(i).tag);
                                  },
                                  child: Text(tags.elementAt(i).tag,
                                      textAlign: TextAlign.center),
                              )
                          ),
                      )
                  ],
                )
            ),
          ],
        ));
  }
}
