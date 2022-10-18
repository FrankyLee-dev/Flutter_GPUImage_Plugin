package com.gpuimage.flutter_gpuimage_plugin.utils

import jp.co.cyberagent.android.gpuimage.filter.*

/**
 *
 *  author : frankylee
 *  date : 2022/10/18 14:44
 *  description : 滤镜
 */
object FilterTools {

    fun generateFilter(arguments: Map<*, *>): GPUImageFilter {
        return when(arguments["type"]) {
            // 对比度
            "contrast" -> GPUImageContrastFilter((arguments["contrast"] as Number).toFloat())
            // 反色
            "colorInvert" -> GPUImageColorInvertFilter()
            // 像素化
            "pixelation" -> {
                val filter = GPUImagePixelationFilter()
                filter.setPixel((arguments["pixel"] as Number).toFloat())
                return filter
            }
            // 色度
            "hue" -> GPUImageHueFilter((arguments["hue"] as Number).toFloat())
            // 亮度
            "brightness" -> GPUImageBrightnessFilter((arguments["brightness"] as Number).toFloat())
            // 灰度
            "grayscale" -> GPUImageGrayscaleFilter()
            // 褐色（怀旧）
            "sepia" -> GPUImageSepiaToneFilter((arguments["sepia"] as Number).toFloat())
            // 锐化
            "sharpen" -> GPUImageSharpenFilter((arguments["sharpen"] as Number).toFloat())
            // 饱和度
            "saturation" -> GPUImageSaturationFilter((arguments["saturation"] as Number).toFloat())
            // 类似Photoshop的级别调整
            "levels" -> {
                val filter = GPUImageLevelsFilter()
                val redMin = arguments["redMin"] as ArrayList<Double>
                val greenMin = arguments["greenMin"] as ArrayList<Double>
                val blueMin = arguments["blueMin"] as ArrayList<Double>
                filter.setRedMin(
                    redMin[0].toFloat(),
                    redMin[1].toFloat(),
                    redMin[2].toFloat(),
                    redMin[3].toFloat(),
                    redMin[4].toFloat()
                )
                filter.setGreenMin(
                    greenMin[0].toFloat(),
                    greenMin[1].toFloat(),
                    greenMin[2].toFloat(),
                    greenMin[3].toFloat(),
                    greenMin[4].toFloat()
                )
                filter.setBlueMin(
                    blueMin[0].toFloat(),
                    blueMin[1].toFloat(),
                    blueMin[2].toFloat(),
                    blueMin[3].toFloat(),
                    blueMin[4].toFloat()
                )
                return filter
            }
            // 曝光度
            "exposure" -> GPUImageExposureFilter((arguments["exposure"] as Number).toFloat())
            // RGB修改
            "rgb" -> {
                val filter = GPUImageRGBFilter()
                filter.setRed((arguments["red"] as Number).toFloat())
                filter.setGreen((arguments["green"] as Number).toFloat())
                filter.setBlue((arguments["blue"] as Number).toFloat())
                return filter
            }
            // 白平衡
            "whiteBalance" -> GPUImageWhiteBalanceFilter(
                (arguments["temperature"] as Number).toFloat(),
                (arguments["tint"] as Number).toFloat()
            )
            // 单色
            "monochrome" -> GPUImageMonochromeFilter(
                (arguments["intensity"] as Number).toFloat(),
                floatArrayOf(
                    (arguments["red"] as Number).toFloat(),
                    (arguments["green"] as Number).toFloat(),
                    (arguments["blue"] as Number).toFloat(),
                    (arguments["alpha"] as Number).toFloat()
                )
            )
            // 指定混色
            "falseColor" -> GPUImageFalseColorFilter(
                (arguments["fRed"] as Number).toFloat(),
                (arguments["fGreen"] as Number).toFloat(),
                (arguments["fBlue"] as Number).toFloat(),
                (arguments["sRed"] as Number).toFloat(),
                (arguments["sGreen"] as Number).toFloat(),
                (arguments["sBlue"] as Number).toFloat()
            )
            // 二维三维变换
            "transformOperation" -> GPUImageTransformFilter()
            // 伽马值
            "gamma" -> GPUImageGammaFilter((arguments["gamma"] as Number).toFloat())
            // 阴影高光
            "highlightsShadows" -> GPUImageHighlightShadowFilter(
                (arguments["shadows"] as Number).toFloat(),
                (arguments["highlights"] as Number).toFloat()
            )
            else -> GPUImageFilter()
        }
    }

}