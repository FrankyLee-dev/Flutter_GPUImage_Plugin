/// Copyright (C), 2021-2022, Franky Lee
/// @ProjectName: flutter_gpuimage_plugin
/// @Package:
/// @ClassName: take_photo
/// @Description:
/// @Author: frankylee
/// @CreateDate: 2022/10/14 11:38
/// @UpdateUser: frankylee
/// @UpdateData: 2022/10/14 11:38
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'display_picture.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        cameras: cameras,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.cameras,
  });

  final List<CameraDescription> cameras;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen>
    with WidgetsBindingObserver {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  bool isFront = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // To display the current output from the Camera,
    // create a CameraController.
    debugPrint('cameras.length: ${widget.cameras.length}');
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.cameras.first,
      // Define the resolution to use.
      ResolutionPreset.max,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  void changeCamera() {
    debugPrint('changeCamera: $isFront');
    CameraController controller = CameraController(
      // Get a specific camera from the list of available cameras.
      !isFront ? widget.cameras[1] : widget.cameras[0],
      // Define the resolution to use.
      ResolutionPreset.max,
    );
    _initializeControllerFuture = controller.initialize();
    setState(() {
      isFront = !isFront;
      _controller = controller;
    });
  }

  void _onCreateNewController() {
    CameraController controller = CameraController(
      // Get a specific camera from the list of available cameras.
      isFront ? widget.cameras[1] : widget.cameras[0],
      // Define the resolution to use.
      ResolutionPreset.max,
    );
    _initializeControllerFuture = controller.initialize();
    setState(() {
      _controller = controller;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // debugPrint('didChangeAppLifecycleState: ${_controller.value.isInitialized}');
    // if (_controller.value.isInitialized) {
    //   return;
    // }
    debugPrint('didChangeAppLifecycleState: $state');
    if (state == AppLifecycleState.inactive) {
      _controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _onCreateNewController();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                // final mediaSize = MediaQuery.of(context).size;
                // final w = mediaSize.width;
                // final h = mediaSize.height;
                // final scale = 1 / (_controller.value.aspectRatio * (w / h));

                return Center(child: CameraPreview(_controller));
              }
              return Column(children: [CircularProgressIndicator()]);
            },
          ),
          Positioned(
              top: MediaQuery.of(context).padding.top + 30,
              right: 25,
              child: GestureDetector(
                onTap: changeCamera,
                child: Icon(
                  Icons.change_circle_outlined,
                  size: 35,
                ),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            debugPrint('$e');
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class _MediaSizeClipper extends CustomClipper<Rect> {
  final double w;
  final double h;

  const _MediaSizeClipper(this.w, this.h);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, w, h);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
