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
  Future<dynamic> setImageFilter(Map args) async {
    final value =
        await methodChannel.invokeMethod<dynamic>('setImageFilter', args);
    return value;
  }

  /// 设置对比度
  @override
  Future<dynamic> setImageContrast(Map args) async {
    final value =
        await methodChannel.invokeMethod<dynamic>('setImageContrast', args);
    return value;
  }

  /// 设置亮度
  @override
  Future<dynamic> setImageBrightness(Map args) async {
    final value =
        await methodChannel.invokeMethod<dynamic>('setImageBrightness', args);
    return value;
  }

  /// 设置饱和度
  @override
  Future<dynamic> setImageSaturation(Map args) async {
    final value =
        await methodChannel.invokeMethod<dynamic>('setImageSaturation', args);
    return value;
  }
}
