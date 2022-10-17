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
import android.view.View
import androidx.core.view.ViewCompat
import com.gpuimage.flutter_gpuimage_plugin.camera.Camera2Loader
import com.gpuimage.flutter_gpuimage_plugin.camera.CameraLoader
import io.flutter.plugin.platform.PlatformView
import jp.co.cyberagent.android.gpuimage.GPUImageView
import jp.co.cyberagent.android.gpuimage.filter.*


internal class FGpuImageView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {

    private val gpuImageView: GPUImageView

    private var mCameraLoader: CameraLoader

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
        gpuImageView = GPUImageView(context)
//        gpuImageView.setRenderMode(GPUImageView.RENDERMODE_CONTINUOUSLY)

        mCameraLoader = Camera2Loader(context)
        mCameraLoader.setOnPreviewFrameListener(object : CameraLoader.OnPreviewFrameListener {
            override fun onPreviewFrame(data: ByteArray?, width: Int, height: Int) {
                gpuImageView.updatePreviewFrame(data, width, height)
            }

        })

        if (creationParams != null) {
            // 图片显示
            val u = creationParams["uri"] as String?
            if (u != null) {
                gpuImageView.setImage(getCompressBitmap(u)) // this loads image on the current thread, should be run in a thread
            }
        }
    }

    // yuv数据显示摄像头预览
    fun updatePreviewFrame(data : ByteArray?, width: Int, height: Int) {

//        Log.i("updatePreviewFrame", "updatePreviewFrame: " + data?.size)

        gpuImageView.updatePreviewFrame(data, width, height)
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

    override fun onFlutterViewAttached(flutterView: View) {
        if (ViewCompat.isLaidOut(gpuImageView) && !gpuImageView.isLayoutRequested) {
            mCameraLoader.onResume(gpuImageView.width, gpuImageView.height)
        } else {
            gpuImageView.addOnLayoutChangeListener(object : View.OnLayoutChangeListener {
                override fun onLayoutChange(
                    p0: View?,
                    p1: Int,
                    p2: Int,
                    p3: Int,
                    p4: Int,
                    p5: Int,
                    p6: Int,
                    p7: Int,
                    p8: Int
                ) {
                    gpuImageView.removeOnLayoutChangeListener(this)
                    mCameraLoader.onResume(gpuImageView.width, gpuImageView.height)
                }

            })
        }
    }

}