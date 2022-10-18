import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_gpuimage_plugin_method_channel.dart';

abstract class FlutterGpuimagePluginPlatform extends PlatformInterface {
  /// Constructs a FlutterGpuimagePluginPlatform.
  FlutterGpuimagePluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterGpuimagePluginPlatform _instance = MethodChannelFlutterGpuimagePlugin();

  /// The default instance of [FlutterGpuimagePluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterGpuimagePlugin].
  static FlutterGpuimagePluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterGpuimagePluginPlatform] when
  /// they register themselves.
  static set instance(FlutterGpuimagePluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<dynamic> setFilter(int filter) {
    throw UnimplementedError('setFilter() has not been implemented.');
  }

  Future<dynamic> setCameraFilter(Map args) {
    throw UnimplementedError('setCameraFilter() has not been implemented.');
  }

}
