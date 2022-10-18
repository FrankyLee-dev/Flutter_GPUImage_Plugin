import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gpuimage_plugin/flutter_gpuimage_plugin.dart';
import 'package:flutter_gpuimage_plugin/widget/gpu_image_widget.dart';

/// Copyright (C), 2021-2022, Franky Lee
/// @ProjectName: flutter_gpuimage_plugin
/// @Package:
/// @ClassName: display_picture
/// @Description:
/// @Author: frankylee
/// @CreateDate: 2022/10/14 11:46
/// @UpdateUser: frankylee
/// @UpdateData: 2022/10/14 11:46
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  DisplayPictureScreenState createState() => DisplayPictureScreenState();
}

class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  final _flutterGpuimagePlugin = FlutterGpuimagePlugin();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPU Image Filter'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
                margin: EdgeInsets.all(20),
                child: GpuImageWidget(uri: widget.imagePath)),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          _buildFilterBtn(),
          Padding(padding: EdgeInsets.only(top: 10)),
          _buildFilterBtn2(),
          Padding(padding: EdgeInsets.only(top: 20)),
        ],
      ),
    );
  }
}
