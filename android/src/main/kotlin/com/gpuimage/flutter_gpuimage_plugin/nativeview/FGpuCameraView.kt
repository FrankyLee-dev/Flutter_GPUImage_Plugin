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
import android.app.Activity
import android.content.Context
import android.os.Build
import android.util.Log
import android.view.View
import android.view.WindowManager
import androidx.annotation.RequiresApi
import androidx.camera.core.AspectRatio
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
import jp.co.cyberagent.android.gpuimage.filter.GPUImageFilter
import jp.co.cyberagent.android.gpuimage.filter.GPUImageFilterGroup
import jp.co.cyberagent.android.gpuimage.filter.GPUImageSepiaToneFilter
import jp.co.cyberagent.android.gpuimage.util.Rotation
import java.util.concurrent.Executors

@RequiresApi(Build.VERSION_CODES.LOLLIPOP)
class FGpuCameraView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView,
    LifecycleOwner {

    private var mContext: Context

    private val gpuImageView: GPUImageView by lazy {
        GPUImageView(context)
    }

    private var cameraProvider: ProcessCameraProvider? = null
    private val executor = Executors.newSingleThreadExecutor()

    private val mRegistry = LifecycleRegistry(this)

    private var currentFilter: GPUImageFilter? = null

    private var contrast: GPUImageFilter? = null
    private var brightness: GPUImageFilter? = null
    private var saturation: GPUImageFilter? = null

    //是否后置摄像头
    private var isBackCamera = true

    // 比例
    private var aspectRatio = AspectRatio.RATIO_4_3

    init {
        mContext = context
        mRegistry.currentState = Lifecycle.State.CREATED
        gpuImageView.setScaleType(GPUImage.ScaleType.CENTER_CROP)
        gpuImageView.setRenderMode(GPUImageView.RENDERMODE_CONTINUOUSLY)
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
            ImageAnalysis.Builder().setTargetAspectRatio(aspectRatio)
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .build()
        imageAnalysis.setAnalyzer(executor) {
            if (it.image != null) {
                if (isBackCamera) {
                    gpuImageView.gpuImage.setRotation(Rotation.ROTATION_90, false, false)
                } else {
                    gpuImageView.gpuImage.setRotation(Rotation.ROTATION_90, true, false)
                }
                gpuImageView.updatePreviewFrame(
                    ImageUtils.generateNV21Data(it.image!!),
                    it.width,
                    it.height
                )
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

    // 切换比例
    fun switchAspectRatio(value: Int?) {
        aspectRatio = if (value == 0) {
            AspectRatio.RATIO_4_3
        } else {
            AspectRatio.RATIO_16_9
        }
        Log.i("switchAspectRatio", "switchAspectRatio: $aspectRatio")
        startCameraIfReady()
    }

    // 切换摄像头
    fun switchCamera(value: Int?) {
        Log.i("switchCamera", "switchCamera: $value")
        isBackCamera = value == 0
        startCameraIfReady()
    }

    // 设置滤镜
    fun setFilter(arguments: Map<*, *>) {
        val filter = FilterTools.generateFilter(arguments)
        currentFilter = filter
        setGroupFilter()
    }

    // 设置对比度
    fun setCameraContrast(arguments: Map<*, *>) {
        val filter = FilterTools.generateFilter(arguments)
        contrast = filter
        setGroupFilter()
    }

    // 设置亮度
    fun setCameraBrightness(arguments: Map<*, *>) {
        val filter = FilterTools.generateFilter(arguments)
        brightness = filter
        setGroupFilter()
    }

    // 设置饱和度
    fun setCameraSaturation(arguments: Map<*, *>) {
        val filter = FilterTools.generateFilter(arguments)
        saturation = filter
        setGroupFilter()
    }

    private fun setGroupFilter() {
        val list = mutableListOf<GPUImageFilter>()
        if (currentFilter != null) {
            list.add(currentFilter!!)
        }
        if (contrast != null) {
            list.add(contrast!!)
        }
        if (brightness != null) {
            list.add(brightness!!)
        }
        if (saturation != null) {
            list.add(saturation!!)
        }
        gpuImageView.filter = GPUImageFilterGroup(list)
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