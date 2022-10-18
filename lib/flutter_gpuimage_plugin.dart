import 'package:flutter/foundation.dart';

import 'flutter_gpuimage_plugin_platform_interface.dart';

class FlutterGpuimagePlugin {
  Future<String?> getPlatformVersion() {
    return FlutterGpuimagePluginPlatform.instance.getPlatformVersion();
  }

  Future<dynamic> setFilter(int filter) {
    return FlutterGpuimagePluginPlatform.instance.setFilter(filter);
  }

  Future<dynamic> setCameraFilter(Map args) {
    debugPrint('setCameraFilter: $args');
    return FlutterGpuimagePluginPlatform.instance.setCameraFilter(args);
  }

}
