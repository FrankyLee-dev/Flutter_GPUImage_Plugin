import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_gpuimage_plugin_platform_interface.dart';

/// An implementation of [FlutterGpuimagePluginPlatform] that uses method channels.
class MethodChannelFlutterGpuimagePlugin extends FlutterGpuimagePluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_gpuimage_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<dynamic> setFilter(int filter) async {
    final value = await methodChannel
        .invokeMethod<dynamic>('setFilter', {"filter": filter});
    return value;
  }

  @override
  Future<dynamic> updatePreviewFrame(
      Uint8List data, int width, int height) async {
    final value = await methodChannel.invokeMethod<dynamic>(
        'updatePreviewFrame',
        {"planes": data, "width": width, "height": height});
    return value;
  }
}
