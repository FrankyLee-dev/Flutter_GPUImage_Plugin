/**
 * Copyright (C), 2021-2022, 广州知铲科技有限公司
 * @ProjectName: android
 * @Package: com.gpuimage.flutter_gpuimage_plugin.factory
 * @ClassName: FGpuCameraFactory
 * @Description:
 * @Author: frankylee
 * @CreateDate: 2022/10/18 12:01
 * @UpdateUser: frankylee
 * @UpdateData: 2022/10/18 12:01
 * @UpdateRemark: 更新说明
 */
package com.gpuimage.flutter_gpuimage_plugin.factory

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.gpuimage.flutter_gpuimage_plugin.nativeview.FGpuCameraView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

@RequiresApi(Build.VERSION_CODES.LOLLIPOP)
class FGpuCameraFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    private lateinit var fGpuCameraView: FGpuCameraView

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {

        val creationParams = args as Map<String?, Any?>?
        fGpuCameraView = FGpuCameraView(context, viewId, creationParams)
        return fGpuCameraView
    }

    fun switchCamera(value: Int?) {
        fGpuCameraView.switchCamera(value)
    }

    fun switchAspectRatio(value: Int?) {
        fGpuCameraView.switchAspectRatio(value)
    }

    fun setFilter(arguments: Map<*, *>) {
        fGpuCameraView.setFilter(arguments)
    }

    fun setCameraContrast(arguments: Map<*, *>) {
        fGpuCameraView.setCameraContrast(arguments)
    }

    fun setCameraBrightness(arguments: Map<*, *>) {
        fGpuCameraView.setCameraBrightness(arguments)
    }

    fun setCameraSaturation(arguments: Map<*, *>) {
        fGpuCameraView.setCameraSaturation(arguments)
    }

}