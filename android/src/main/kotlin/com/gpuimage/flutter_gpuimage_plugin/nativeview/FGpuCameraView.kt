/**
 * Copyright (C), 2021-2022, 广州知铲科技有限公司
 * @ProjectName: android
 * @Package: com.gpuimage.flutter_gpuimage_plugin.nativeview
 * @ClassName: FGpuCameraView
 * @Description:
 * @Author: frankylee
 * @CreateDate: 2022/10/18 12:01
 * @UpdateUser: frankylee
 * @UpdateData: 2022/10/18 12:01
 * @UpdateRemark: 更新说明
 */
package com.gpuimage.flutter_gpuimage_plugin.nativeview

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.util.Log
import android.view.View
import androidx.annotation.RequiresApi
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageAnalysis
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import com.gpuimage.flutter_gpuimage_plugin.utils.FilterTools
import com.gpuimage.flutter_gpuimage_plugin.utils.ImageUtils
import io.flutter.plugin.platform.PlatformView
import jp.co.cyberagent.android.gpuimage.GPUImage
import jp.co.cyberagent.android.gpuimage.GPUImageView
import jp.co.cyberagent.android.gpuimage.filter.GPUImageSepiaToneFilter
import jp.co.cyberagent.android.gpuimage.util.Rotation
import java.util.concurrent.Executors

@RequiresApi(Build.VERSION_CODES.LOLLIPOP)
class FGpuCameraView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView,
    LifecycleOwner {

    private val gpuImageView: GPUImageView by lazy {
        GPUImageView(context)
    }

    private var cameraProvider: ProcessCameraProvider? = null
    private val executor = Executors.newSingleThreadExecutor()

    private val mRegistry = LifecycleRegistry(this)

    //是否后置摄像头
    private var isBackCamera = true

    init {
        mRegistry.currentState = Lifecycle.State.CREATED
        gpuImageView.setScaleType(GPUImage.ScaleType.CENTER_CROP)
        gpuImageView.setRenderMode(GPUImageView.RENDERMODE_CONTINUOUSLY)
//        gpuImageView.filter = GPUImageSepiaToneFilter()
        val cameraProviderFuture = ProcessCameraProvider.getInstance(context)
        cameraProviderFuture.addListener({
            cameraProvider = cameraProviderFuture.get()
            startCameraIfReady()
        }, ContextCompat.getMainExecutor(context))
        mRegistry.currentState = Lifecycle.State.RESUMED
    }

    @SuppressLint("UnsafeOptInUsageError")
    private fun startCameraIfReady() {
        val imageAnalysis =
            ImageAnalysis.Builder().setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .build()
        imageAnalysis.setAnalyzer(executor) {
            if (it.image != null) {
                gpuImageView.setRotation(
                    if (isBackCamera) {
                        Rotation.ROTATION_90
                    } else {
                        Rotation.ROTATION_270
                    }
                )
                gpuImageView.updatePreviewFrame(ImageUtils.generateNV21Data(it.image!!), it.width, it.height)
            }
            it.close()
        }
        val cameraSelector = if (isBackCamera) {
            CameraSelector.DEFAULT_BACK_CAMERA
        } else {
            CameraSelector.DEFAULT_FRONT_CAMERA
        }
        cameraProvider?.let {
            cameraProvider?.unbindAll()
            cameraProvider?.bindToLifecycle(
                this,
                cameraSelector, imageAnalysis
            )
        }
    }

    // 设置滤镜
    fun setFilter(arguments: Map<*, *>) {
        val filter = FilterTools.generateFilter(arguments)
        gpuImageView.filter = filter
    }

    override fun getView(): View {
        return gpuImageView
    }

    override fun dispose() {
        mRegistry.currentState = Lifecycle.State.DESTROYED
    }

    override fun getLifecycle(): Lifecycle {
        return mRegistry
    }
}