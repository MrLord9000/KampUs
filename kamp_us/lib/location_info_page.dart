import 'package:flutter/material.dart';
import 'package:kamp_us/models.dart';
import 'package:kamp_us/view_models/location.dart';
import 'package:kamp_us/api.dart';


class LocationInfoPage extends StatefulWidget
{
  LocationInfoPage({Key key, this.location}) : super(key: key);

  final Location location;

  @override
  State<StatefulWidget> createState() => _LocationInfoPageState();
}

class _LocationInfoPageState extends State<LocationInfoPage>
{
  void alertDialogPopUpSuccess() {
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Text('Dałeś łapkę w górę'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );

        }
    );
  }

  void alertDialogPopUpFailure(String string) {
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Text(string),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );

        }
    );
  }
  final _addCommentController = TextEditingController();

  int iloscLapek = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // Simple app bar with title
      appBar: AppBar(
        centerTitle: true,
        title: Text("Location Details"),
      ),

      body: SingleChildScrollView (
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(widget.location.name),
                  Padding(padding: EdgeInsets.all(10)),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width/3-20,
                        alignment: Alignment.center,
                        child: Text('Liczba łapek'),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/3-20,
                        alignment: Alignment.center,
                        child: Text(iloscLapek.toString()),
                      ),
                      Container (
                        height: 40,
                        width:  MediaQuery.of(context).size.width/3-20,
                        alignment: Alignment.center,
                        child: Material (
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Theme.of(context).primaryColor,
                            child: InkWell(
                              onTap: () {
                                API.createThumb(new ThumbModel(locId: widget.location.id, userId: API.currentUserNoPass.id),
                                    alertDialogPopUpSuccess,
                                    alertDialogPopUpFailure);
                                setState(() {
                                  iloscLapek = widget.location.thumbs;
                                });
                              },


                              child: Center(
                                child: Text('Daj łapkę', style: TextStyle(color: Colors.white),),
                              ),
                            )
                        ),
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Row(
                    children: <Widget>[

                      Expanded(
                        child: Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                            ),
                            child: Wrap(
                              children: <Widget>[
                                Text(widget.location.description),
                              ],
                            )
                        ),
                      )
                    ],
                  ),
                  Text('Dodaj komentarz'),
                  TextField(
                    controller: _addCommentController,
                      maxLines: null,
                    decoration: InputDecoration(fillColor: Theme.of(context).accentColor),
                  ),
                  Padding(padding: EdgeInsets.all(20)),
                  Container (
                    height: 40,
                    width:  MediaQuery.of(context).size.width/3-20,
                    alignment: Alignment.center,
                    child: Material (
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Theme.of(context).primaryColor,
                        child: InkWell(
                          onTap: () {
                            CommentModel newComment = new CommentModel(userId: API.currentUserNoPass.id,
                            locId: widget.location.id,
                            text: _addCommentController.text);
                            API.createComment(newComment, ()=>{print('sukces')}, (x) => {print(x)});
                          },
                          child: Center(
                            child: Text('Dodaj', style: TextStyle(color: Colors.white),),
                          ),
                        )
                    ),
                  ),

                  Text('Komentarze'),
                  Column (
                    children: <Widget>[
                      for (int i = 0; i < widget.location.comments.length; i++)
                        Row (
                          children: <Widget>[
                            Expanded(
                              child: Text(widget.location.comments.elementAt(i).text),
                            )

                          ],
                        )
                    ],
                  )

                ],
              ),
            )
          ],
        ),
      )



    );

  }

}