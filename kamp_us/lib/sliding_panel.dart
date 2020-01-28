import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'api.dart';
import 'models.dart';

class CategoryTagPanel extends StatefulWidget {
  CategoryTagPanel({Key key}) : super(key: key);

  @override
  _CategoryTagStatus createState() => _CategoryTagStatus();
}

class _CategoryTagStatus extends State<CategoryTagPanel> {
  List<TagModel> tags = new List<TagModel>();

  _onStartLoadTags() async {
    tags = await API.loadAllTags(() => {print('sukces')}, (x) => {print(x)});
  }

  @override
  Widget build(BuildContext context) {
    _onStartLoadTags();

    return SlidingUpPanel(
        renderPanelSheet: true,
        panel: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(4.0),
                      height: 100.0,
                      width: MediaQuery.of(context).size.width / 6,
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        color: Colors.blue,
                        child: GestureDetector(
                          onTap: () {
                            print('blue');
                            //Wybierz marker niebieski
                          },
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(4.0),
                        height: 100.0,
                        width: MediaQuery.of(context).size.width / 6,
                        child: Material(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          color: Colors.red,
                          child: GestureDetector(
                            onTap: () {
                              print('red');
                              //Wybierz marker czerwony
                            },
                          ),
                        )),
                    Container(
                        padding: EdgeInsets.all(4.0),
                        height: 100.0,
                        width: MediaQuery.of(context).size.width / 6,
                        child: Material(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          color: Colors.yellow,
                          child: GestureDetector(
                            onTap: () {
                              print('yellow');
                              //Wybierz marker żółty
                            },
                          ),
                        )),
                    Container(
                        padding: EdgeInsets.all(4.0),
                        height: 100.0,
                        width: MediaQuery.of(context).size.width / 6,
                        child: Material(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          color: Colors.green,
                          child: GestureDetector(
                            onTap: () {
                              print('zielony');
                              //Wybierz marker zielony
                            },
                          ),
                        )),
                    Container(
                        padding: EdgeInsets.all(4.0),
                        height: 100.0,
                        width: MediaQuery.of(context).size.width / 6,
                        child: Material(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          color: Colors.purple,
                          child: GestureDetector(
                            onTap: () {
                              print('purple');
                              //Wybierz marker fioletowy
                            },
                          ),
                        )),
                  ],
                ),
              ],
            ),
            Container(
                padding: EdgeInsets.only(top: 125.0),
                child: Wrap(
                  children: <Widget>[
                    for (int i = 0; i < tags.length; i++)
                      Container(
                          padding: EdgeInsets.all(5.0),
                          alignment: Alignment.center,
                          height: 30.0,
                          width: MediaQuery.of(context).size.width / 3,
                          color: Colors.cyanAccent,
                          child: GestureDetector(
                            onTap: () {
                              //Tutaj wybierz tag czy co
                              print(tags.elementAt(i).tag);
                            },
                            child: Text(tags.elementAt(i).tag,
                                textAlign: TextAlign.center),
                          ))
                  ],
                )),
          ],
        ));
  }
}
