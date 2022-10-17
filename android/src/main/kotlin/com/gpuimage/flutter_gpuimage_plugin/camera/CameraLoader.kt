/**
 * Copyright (C), 2021-2022, 广州知铲科技有限公司
 * @ProjectName: android
 * @Package: com.gpuimage.flutter_gpuimage_plugin.camera
 * @ClassName: CameraLoader
 * @Description:
 * @Author: frankylee
 * @CreateDate: 2022/10/17 17:47
 * @UpdateUser: frankylee
 * @UpdateData: 2022/10/17 17:47
 * @UpdateRemark: 更新说明
 */
package com.gpuimage.flutter_gpuimage_plugin.camera

abstract class CameraLoader {

    protected var mOnPreviewFrameListener: OnPreviewFrameListener? = null

    abstract fun onResume(width: Int, height: Int)

    abstract fun onPause()

    abstract fun switchCamera()

    abstract fun getCameraOrientation(): Int

    abstract fun hasMultipleCamera(): Boolean

    abstract fun isFrontCamera(): Boolean

    open fun setOnPreviewFrameListener(onPreviewFrameListener: OnPreviewFrameListener) {
        mOnPreviewFrameListener = onPreviewFrameListener
    }

    interface OnPreviewFrameListener {
        fun onPreviewFrame(data: ByteArray?, width: Int, height: Int)
    }
}