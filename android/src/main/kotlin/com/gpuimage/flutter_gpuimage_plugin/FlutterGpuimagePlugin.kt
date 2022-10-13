package com.gpuimage.flutter_gpuimage_plugin

import androidx.annotation.NonNull
import com.gpuimage.flutter_gpuimage_plugin.factory.FGpuImageFactory

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterGpuimagePlugin */
class FlutterGpuimagePlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var factory: FGpuImageFactory

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_gpuimage_plugin")
    channel.setMethodCallHandler(this)

    factory = FGpuImageFactory()
    flutterPluginBinding.platformViewRegistry.registerViewFactory("com.gpuimageview.FGpuImageView", factory)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "setFilter" -> {
        val filter = call.argument<Int>("filter")
        if (filter != null) {
          factory.setFilter(filter)
        }
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
