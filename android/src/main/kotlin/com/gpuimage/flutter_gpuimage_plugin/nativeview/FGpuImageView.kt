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
import com.gpuimage.flutter_gpuimage_plugin.utils.FilterTools
import io.flutter.plugin.platform.PlatformView
import jp.co.cyberagent.android.gpuimage.GPUImageView
import jp.co.cyberagent.android.gpuimage.filter.*
import jp.co.cyberagent.android.gpuimage.util.Rotation

internal class FGpuImageView(context: Context, id: Int, creationParams: Map<String?, Any?>?) :
    PlatformView {

    private val gpuImageView: GPUImageView

    private var currentFilter: GPUImageFilter? = null

    private var contrast: GPUImageFilter? = null
    private var brightness: GPUImageFilter? = null
    private var saturation: GPUImageFilter? = null

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
        if (creationParams != null) {
            // 图片显示
            val u = creationParams["uri"] as String?
            val isFront = creationParams["isFront"] as Boolean
            if (u != null) {
                if (isFront) {
                    gpuImageView.gpuImage.setRotation(Rotation.NORMAL, true, false)
                }
                gpuImageView.setImage(getCompressBitmap(u)) // this loads image on the current thread, should be run in a thread
            }
        }
    }

    // 设置滤镜
    fun setImageFilter(arguments: Map<*, *>) {
        val filter = FilterTools.generateFilter(arguments)
        currentFilter = filter
        setGroupFilter()
    }

    // 设置对比度
    fun setImageContrast(arguments: Map<*, *>) {
        val filter = FilterTools.generateFilter(arguments)
        contrast = filter
        setGroupFilter()
    }

    // 设置亮度
    fun setImageBrightness(arguments: Map<*, *>) {
        val filter = FilterTools.generateFilter(arguments)
        brightness = filter
        setGroupFilter()
    }

    // 设置饱和度
    fun setImageSaturation(arguments: Map<*, *>) {
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

}