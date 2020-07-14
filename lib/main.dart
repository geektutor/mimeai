import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mimeai_app/analyzing.dart';
import 'package:mimeai_app/detected.dart';
import 'package:mimeai_app/healthy.dart';
import 'package:mimeai_app/services/api.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';
import 'nmain.dart';
import 'camera.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Mimeai'),
            ),
          ),
          body: Container(
            margin: EdgeInsets.only(top: 2),
            child: HomeScreen(
              firstCamera: firstCamera,
            ),
          ),
        )),
  );
}

class HomeScreen extends StatelessWidget {
  // Obtain a list of the available cameras on the device.
  final firstCamera;
  HomeScreen({Key key, @required this.firstCamera});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 200,
          ),
          Center(
            child: RaisedButton(
              color: Colors.lightBlue,
              textColor: Colors.white,
              child: Text('Go to OG Screen 1'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Analyzing()),
                );
              },
            ),
          ),
          Center(
            child: RaisedButton(
              color: Colors.lightBlue,
              textColor: Colors.white,
              child: Text('Go to OG Screen 2'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Detected()),
                );
              },
            ),
          ),
          Center(
            child: RaisedButton(
              color: Colors.lightBlue,
              textColor: Colors.white,
              child: Text('Go to Geek Main'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppBarTop()),
                );
              },
            ),
          ),
          Center(
            child: RaisedButton(
              color: Colors.lightBlue,
              textColor: Colors.white,
              child: Text('Go to Geek Snap'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakePictureGeek(
                      camera: firstCamera,
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: RaisedButton(
                color: Colors.lightBlue,
                textColor: Colors.white,
                child: Container(
                  width: 170,
                  child: Row(
                    children: <Widget>[
                      Text('Select leaf picture'),
                      SizedBox(
                        width: 30,
                      ),
                      Icon(Icons.camera)
                    ],
                  ),
                ),
                onPressed: () async {
                  var image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);

                  File imageFile = new File(image.path);

                  // Convert to amazon requirements
                  List imageBytes = imageFile.readAsBytesSync();
                  String base64Image = base64Encode(imageBytes);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(
                              imagePath: image.path,
                              base64Image: base64Image)));
                }),
          ),
          Center(
            child: RaisedButton(
                color: Colors.lightBlue,
                textColor: Colors.white,
                child: Container(
                  width: 170,
                  child: Row(
                    children: <Widget>[
                      Text('Take leaf picture'),
                      SizedBox(
                        width: 40,
                      ),
                      Icon(Icons.add_a_photo)
                    ],
                  ),
                ),
                onPressed: () async {
                  /*Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>  PickImage(
                      // Pass the appropriate camera to the TakePictureScreen widget.

                    ),
                  ));*/
                  var image =
                      await ImagePicker.pickImage(source: ImageSource.camera);

                  File imageFile = new File(image.path);

                  // Convert to amazon requirements
                  List imageBytes = imageFile.readAsBytesSync();
                  String base64Image = base64Encode(imageBytes);

                  // If the picture was taken, display it on a new screen.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayPictureScreen(
                          imagePath: image.path, base64Image: base64Image),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String base64Image;
  const DisplayPictureScreen({Key key, this.imagePath, this.base64Image})
      : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

String _predictionLink = "";
String _disease = "";
bool _requesting = false;

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  @override
  void dispose() {
    super.dispose();
    _requesting = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Get Prediction')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        /*body: Center(
        child: RaisedButton(
            onPressed: () {
            },
            child: Text('Go back')
        ),
      ),*/
        body: Builder(
            builder: (_context) => Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(6, 0, 6, 20.0),
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 200,
                          child: Image.file(File(widget.imagePath)),
                        )),
                    Text('Disease Prediction:  $_disease'),
                    SizedBox(
                      height: 20,
                    ),
                    _requesting
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            color: Colors.lightBlue,
                            textColor: Colors.white,
                            onPressed: () async {
                              try {
                                ApiRequests apiRequests = new ApiRequests();
                                setState(() {
                                  _requesting = true;
                                });
                                final prediction =
                                    await apiRequests.getPrediction(
                                        widget.imagePath, widget.base64Image);
                                setState(() => _requesting = false);
                                if (prediction['success']) {
                                  setState(() {
                                    _disease = prediction['disease'];
                                    _predictionLink = prediction['image_path'];
                                  });
                                  print(_disease);
                                  _neverSatisfied(
                                      context, prediction['disease']);
                                } else {
                                  _showMessage(
                                      'Error getting prediction', _context);
                                }
                                setState(() => _requesting = false);
                              } on Exception catch (error) {
                                print(error);
                              }
                            },
                            child: Text('Request Prediction'))
                  ],
                )),
        floatingActionButton: Builder(
            builder: (newContext) => FloatingActionButton(
                  onPressed: () async {
                    if (_predictionLink == "")
                      _showMessage(
                          "No prediction yet, request prediction", newContext);
                    else
                      Share.share(
                          'Hi, please I need pesticide for $_disease, here is a link to the image $_predictionLink',
                          subject: 'Look at my plant disease prediction');
                  },
                  tooltip: 'Share',
                  child: Icon(Icons.share),
                )));
  }
}

void _showMessage(String msg, BuildContext context) {
  final SnackBar snackBar = SnackBar(
    duration: Duration(seconds: 3),
    content: Text(msg),
  );
  Scaffold.of(context).showSnackBar(snackBar);
}

Future<void> _neverSatisfied(BuildContext context, String prediction) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Share prediction'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Hi, your Prediction is ready!!'),
              SizedBox(
                height: 20,
              ),
              Text('Your prediction is: $prediction'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Share.share(
                  'Hi, please I need pesticide for $_disease, here is a link to the image $_predictionLink',
                  subject: 'Look at my plant disease prediction');
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
