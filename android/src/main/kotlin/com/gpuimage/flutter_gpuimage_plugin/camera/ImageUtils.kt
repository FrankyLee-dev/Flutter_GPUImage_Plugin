/**
 * Copyright (C), 2021-2022, 广州知铲科技有限公司
 * @ProjectName: android
 * @Package: com.gpuimage.flutter_gpuimage_plugin.camera
 * @ClassName: ImageUtils
 * @Description:
 * @Author: frankylee
 * @CreateDate: 2022/10/17 18:01
 * @UpdateUser: frankylee
 * @UpdateData: 2022/10/17 18:01
 * @UpdateRemark: 更新说明
 */
package com.gpuimage.flutter_gpuimage_plugin.camera

import android.graphics.ImageFormat
import android.graphics.Rect
import android.media.Image
import android.os.Build
import androidx.annotation.RequiresApi
import java.nio.ByteBuffer


object ImageUtils {

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    fun generateNV21Data(image: Image): ByteArray? {
        val crop: Rect = image.cropRect
        val format: Int = image.format
        val width: Int = crop.width()
        val height: Int = crop.height()
        val planes: Array<Image.Plane> = image.planes
        val data = ByteArray(width * height * ImageFormat.getBitsPerPixel(format) / 8)
        val rowData = ByteArray(planes[0].rowStride)
        var channelOffset = 0
        var outputStride = 1
        for (i in planes.indices) {
            when (i) {
                0 -> {
                    channelOffset = 0
                    outputStride = 1
                }
                1 -> {
                    channelOffset = width * height + 1
                    outputStride = 2
                }
                2 -> {
                    channelOffset = width * height
                    outputStride = 2
                }
            }
            val buffer: ByteBuffer = planes[i].buffer
            val rowStride: Int = planes[i].rowStride
            val pixelStride: Int = planes[i].pixelStride
            val shift = if (i == 0) 0 else 1
            val w = width shr shift
            val h = height shr shift
            buffer.position(rowStride * (crop.top shr shift) + pixelStride * (crop.left shr shift))
            for (row in 0 until h) {
                var length: Int
                if (pixelStride == 1 && outputStride == 1) {
                    length = w
                    buffer.get(data, channelOffset, length)
                    channelOffset += length
                } else {
                    length = (w - 1) * pixelStride + 1
                    buffer.get(rowData, 0, length)
                    for (col in 0 until w) {
                        data[channelOffset] = rowData[col * pixelStride]
                        channelOffset += outputStride
                    }
                }
                if (row < h - 1) {
                    buffer.position(buffer.position() + rowStride - length)
                }
            }
        }
        return data
    }
}