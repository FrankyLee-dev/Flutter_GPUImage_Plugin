import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gpuimage_plugin/flutter_gpuimage_plugin_platform_interface.dart';

/// Copyright (C), 2021-2022, Franky Lee
/// @ProjectName: flutter_gpuimage_plugin
/// @Package:
/// @ClassName: gpu_camera_controller
/// @Description:
/// @Author: frankylee
/// @CreateDate: 2022/10/20 10:44
/// @UpdateUser: frankylee
/// @UpdateData: 2022/10/20 10:44
/// @UpdateRemark: 更新说明
///

class GpuImageController extends ValueNotifier {
  // This is used in the platform side to register the view.
  final String viewType = 'com.gpuimageview.FGpuImageView';

  GpuImageController():super(null);

  /// Camera Filter
  Future<dynamic> setImageFilter(Map args) {
    return FlutterGpuimagePluginPlatform.instance.setImageFilter(args);
  }

  /// Camera Contrast
  Future<dynamic> setImageContrast(Map args) {
    return FlutterGpuimagePluginPlatform.instance.setImageContrast(args);
  }

  /// Camera Brightness
  Future<dynamic> setImageBrightness(Map args) {
    return FlutterGpuimagePluginPlatform.instance.setImageBrightness(args);
  }

  /// Camera Saturation
  Future<dynamic> setImageSaturation(Map args) {
    return FlutterGpuimagePluginPlatform.instance.setImageSaturation(args);
  }

  Widget buildPreview(Map<String, dynamic>? creationParams) {
    return AndroidView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

}