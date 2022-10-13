import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_gpuimage_plugin/flutter_gpuimage_plugin.dart';
import 'package:flutter_gpuimage_plugin/widget/gpu_image_widget.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterGpuimagePlugin = FlutterGpuimagePlugin();

  final ImagePicker _picker = ImagePicker();

  String? uri;

  final List<String> _list = [
    'SepiaToneFilter',
    'MonochromeFilter',
    'EmbossFilter',
    'GrayscaleFilter',
    'HazeFilter',
    'BurnBlendFilter'
  ];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterGpuimagePlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Widget _buildFilterBtn() {
    List<Widget> child = [];
    List.generate(
        3,
        (index) => {
              child.add(Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      _flutterGpuimagePlugin.setFilter(index);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(_list[index]),
                    ),
                  ))),
            });
    return Row(
      children: child,
    );
  }

  Widget _buildFilterBtn2() {
    List<Widget> child = [];
    List.generate(
        3,
        (index) => {
              child.add(Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      _flutterGpuimagePlugin.setFilter(index + 3);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(_list[index + 3]),
                    ),
                  ))),
            });
    return Row(
      children: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GPU Image Filter'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                  margin: EdgeInsets.all(20),
                  child: uri != null
                      ? GpuImageWidget(uri: uri!)
                      : const Text('加载中...')),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            GestureDetector(
              onTap: () async {
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                debugPrint('image: ${image?.name}');
                debugPrint('image: ${image?.path}');
                setState(() {
                  uri = image?.path;
                  // uri = 'http://pic1.win4000.com/mobile/0/55837b9844216.jpg';
                });
              },
              child: Container(
                alignment: Alignment.center,
                height: 40,
                color: Colors.blue,
                child: Text('fetch image'),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            _buildFilterBtn(),
            Padding(padding: EdgeInsets.only(top: 10)),
            _buildFilterBtn2(),
            Padding(padding: EdgeInsets.only(top: 20)),
          ],
        ),
        // floatingActionButton: FloatingActionButton(onPressed: () async {
        //   // final XFile? image =
        //   //     await _picker.pickImage(source: ImageSource.gallery);
        //   // debugPrint('image: ${image?.name}');
        //   // debugPrint('image: ${image?.path}');
        //   setState(() {
        //     // uri = image?.path;
        //     uri = 'http://pic1.win4000.com/mobile/0/55837b9844216.jpg';
        //   });
        // }),
      ),
    );
  }
}
