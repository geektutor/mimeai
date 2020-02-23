import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mimeai/model/api.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

String _disease = "di";

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);
            // Load it from my filesystem
            File imageFile = new File(path);

            // Convert to amazon requirements
            List imageBytes = imageFile.readAsBytesSync();
            String base64Image = base64Encode(imageBytes);

            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path, base64Image: base64Image),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}


// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String base64Image;
  const DisplayPictureScreen({Key key, this.imagePath, this.base64Image}) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
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
        body: Builder(builder: (_context) =>
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Image.file(File(widget.imagePath)),
                ),
                Text('Disease:  $_disease'),
                RaisedButton(
                    onPressed: () async {
                      try {
                        ApiRequests apiRequests = new ApiRequests();
                        final prediction = await apiRequests.getPrediction(widget.imagePath, widget.base64Image);

                        if(prediction['success']) {
                          setState(() {
                            _disease = prediction['disease'];
                          });
                          _showMessage('Prediction is ready', _context);

                        } else {
                          _showMessage('Could not sign in.\n'
                              'Is the Google Services file missing?', _context);
                        }
                      } on Exception catch (error) {
                        print(error);
                      }
                    },
                    child: Text('Request Prediction')
                )
              ],
            ),
        )
    );
  }
}

void _showMessage(String msg, BuildContext context) {
  final SnackBar snackBar = SnackBar(
    duration: Duration(seconds: 3),
    content: Text(msg),
  );
  Scaffold.of(context).showSnackBar(snackBar);
}
