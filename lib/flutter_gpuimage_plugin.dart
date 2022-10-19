import 'package:flutter/foundation.dart';

import 'flutter_gpuimage_plugin_platform_interface.dart';

class FlutterGpuimagePlugin {
  Future<String?> getPlatformVersion() {
    return FlutterGpuimagePluginPlatform.instance.getPlatformVersion();
  }

  Future<dynamic> setFilter(int filter) {
    return FlutterGpuimagePluginPlatform.instance.setFilter(filter);
  }

  Future<dynamic> switchCamera(int front) async {
    return FlutterGpuimagePluginPlatform.instance.switchCamera(front);
  }

  Future<dynamic> switchAspectRatio(int ar) async {
    return FlutterGpuimagePluginPlatform.instance.switchAspectRatio(ar);
  }

  Future<dynamic> setCameraFilter(Map args) {
    debugPrint('setCameraFilter: $args');
    return FlutterGpuimagePluginPlatform.instance.setCameraFilter(args);
  }

  Future<dynamic> setCameraContrast(Map args) {
    debugPrint('setCameraContrast: $args');
    return FlutterGpuimagePluginPlatform.instance.setCameraContrast(args);
  }

  Future<dynamic> setCameraBrightness(Map args) {
    debugPrint('setCameraBrightness: $args');
    return FlutterGpuimagePluginPlatform.instance.setCameraBrightness(args);
  }

  Future<dynamic> setCameraSaturation(Map args) {
    debugPrint('setCameraSaturation: $args');
    return FlutterGpuimagePluginPlatform.instance.setCameraSaturation(args);
  }

}
