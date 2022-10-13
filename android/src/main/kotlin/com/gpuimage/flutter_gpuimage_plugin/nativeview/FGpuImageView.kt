/**
 * Copyright (C), 2021-2022, 广州知铲科技有限公司
 * @ProjectName: android
 * @Package: com.gpuimage.flutter_gpuimage_plugin.nativeview
 * @ClassName: FGpuImageView
 * @Description:
 * @Author: frankylee
 * @CreateDate: 2022/10/13 11:49
 * @UpdateUser: frankylee
 * @UpdateData: 2022/10/13 11:49
 * @UpdateRemark: 更新说明
 */
package com.gpuimage.flutter_gpuimage_plugin.nativeview

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.util.Log
import android.view.View
import io.flutter.plugin.platform.PlatformView
import jp.co.cyberagent.android.gpuimage.GPUImageView
import jp.co.cyberagent.android.gpuimage.filter.*

internal class FGpuImageView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {

    private val gpuImageView: GPUImageView

    override fun getView(): View {
        return gpuImageView
    }

    override fun dispose() {

    }

    // 根据路径构建bitmap
    private fun getCompressBitmap(path: String): Bitmap {
        return BitmapFactory.decodeFile(path)
    }

    init {
        val u = creationParams?.get("uri") as String
        gpuImageView = GPUImageView(context)
        gpuImageView.setImage(getCompressBitmap(u)) // this loads image on the current thread, should be run in a thread

    }

    // 设置滤镜
    fun setFilter(filter: Int) {
        when (filter) {
            0 -> gpuImageView.filter = GPUImageSepiaToneFilter()
            1 -> gpuImageView.filter = GPUImageMonochromeFilter()
            2 -> gpuImageView.filter = GPUImageEmbossFilter()
            3 -> gpuImageView.filter = GPUImageGrayscaleFilter()
            4 -> gpuImageView.filter = GPUImageHazeFilter()
            5-> gpuImageView.filter = GPUImageColorBurnBlendFilter()
        }
    }

}