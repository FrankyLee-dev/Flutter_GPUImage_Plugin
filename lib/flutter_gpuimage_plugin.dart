import 'package:flutter/foundation.dart';

import 'flutter_gpuimage_plugin_platform_interface.dart';

class FlutterGpuimagePlugin {
  Future<String?> getPlatformVersion() {
    return FlutterGpuimagePluginPlatform.instance.getPlatformVersion();
  }

  Future<dynamic> setFilter(int filter) {
    return FlutterGpuimagePluginPlatform.instance.setFilter(filter);
  }

  Future<dynamic> updatePreviewFrame(Uint8List data, int width, int height) {
    return FlutterGpuimagePluginPlatform.instance
        .updatePreviewFrame(data, width, height);
  }
}
