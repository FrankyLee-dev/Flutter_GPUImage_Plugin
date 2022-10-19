package com.gpuimage.flutter_gpuimage_plugin

import android.os.Build
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import com.gpuimage.flutter_gpuimage_plugin.factory.FGpuCameraFactory
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

  private lateinit var fGpuImageFactory: FGpuImageFactory
  private lateinit var fGpuCameraFactory: FGpuCameraFactory

  @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_gpuimage_plugin")
    channel.setMethodCallHandler(this)

    fGpuImageFactory = FGpuImageFactory()
    flutterPluginBinding.platformViewRegistry.registerViewFactory("com.gpuimageview.FGpuImageView", fGpuImageFactory)
    fGpuCameraFactory = FGpuCameraFactory()
    flutterPluginBinding.platformViewRegistry.registerViewFactory("com.gpuimageview.FGpuCameraView", fGpuCameraFactory)
  }

  @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "setFilter" -> {
        val filter = call.argument<Int>("filter")
        if (filter != null) {
          fGpuImageFactory.setFilter(filter)
        }
      }
      "switchCamera" -> {
        val value = call.argument<Int>("front")
        fGpuCameraFactory.switchCamera(value)
      }
      "switchAspectRatio" -> {
        val value = call.argument<Int>("aspectRatio")
        fGpuCameraFactory.switchAspectRatio(value)
      }
      "setCameraFilter" -> {
        val args = call.arguments as Map<*, *>
        fGpuCameraFactory.setFilter(args)
      }
      "setCameraContrast" -> {
        val args = call.arguments as Map<*, *>
        fGpuCameraFactory.setCameraContrast(args)
      }
      "setCameraBrightness" -> {
        val args = call.arguments as Map<*, *>
        fGpuCameraFactory.setCameraBrightness(args)
      }
      "setCameraSaturation" -> {
        val args = call.arguments as Map<*, *>
        fGpuCameraFactory.setCameraSaturation(args)
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
