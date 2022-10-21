/**
 * Copyright (C), 2021-2022, 广州知铲科技有限公司
 * @ProjectName: android
 * @Package: com.gpuimage.flutter_gpuimage_plugin.factory
 * @ClassName: FGpuImageFactory
 * @Description:
 * @Author: frankylee
 * @CreateDate: 2022/10/13 12:02
 * @UpdateUser: frankylee
 * @UpdateData: 2022/10/13 12:02
 * @UpdateRemark: 更新说明
 */
package com.gpuimage.flutter_gpuimage_plugin.factory

import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import com.gpuimage.flutter_gpuimage_plugin.nativeview.FGpuImageView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class FGpuImageFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    private lateinit var fGpuImageView: FGpuImageView

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        fGpuImageView = FGpuImageView(context, viewId, creationParams)
        return fGpuImageView
    }

    fun setImageFilter(arguments: Map<*, *>) {
        fGpuImageView.setImageFilter(arguments)
    }

    fun setCameraContrast(arguments: Map<*, *>) {
        fGpuImageView.setImageContrast(arguments)
    }

    fun setCameraBrightness(arguments: Map<*, *>) {
        fGpuImageView.setImageBrightness(arguments)
    }

    fun setCameraSaturation(arguments: Map<*, *>) {
        fGpuImageView.setImageSaturation(arguments)
    }
}