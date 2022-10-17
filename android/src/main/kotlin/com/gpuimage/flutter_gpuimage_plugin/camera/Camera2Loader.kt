/**
 * Copyright (C), 2021-2022, 广州知铲科技有限公司
 * @ProjectName: android
 * @Package: com.gpuimage.flutter_gpuimage_plugin.camera
 * @ClassName: Camera2Loader
 * @Description:
 * @Author: frankylee
 * @CreateDate: 2022/10/17 17:49
 * @UpdateUser: frankylee
 * @UpdateData: 2022/10/17 17:49
 * @UpdateRemark: 更新说明
 */
package com.gpuimage.flutter_gpuimage_plugin.camera

import android.Manifest
import android.app.Activity
import android.content.ContentValues.TAG
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.ImageFormat
import android.hardware.camera2.*
import android.media.Image
import android.media.ImageReader
import android.media.ImageReader.OnImageAvailableListener
import android.os.Build
import android.util.Log
import android.util.Size
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat


class Camera2Loader(context: Context) : CameraLoader() {

    private val mCameraManager: CameraManager? = null
    private var mCameraCharacteristics: CameraCharacteristics? = null
    private var mCameraDevice: CameraDevice? = null
    private var mImageReader: ImageReader? = null
    private var mCaptureSession: CameraCaptureSession? = null
    private var mCameraId: String? = null
    private val mCameraFacing = CameraCharacteristics.LENS_FACING_BACK

    private var mViewWidth = 0
    private var mViewHeight = 0

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onResume(width: Int, height: Int) {
        this.mViewWidth = width
        this.mViewHeight = height
        this.setUpCamera()
    }

    override fun onPause() {
    }

    override fun switchCamera() {
    }

    override fun getCameraOrientation(): Int {
        return 0
    }

    override fun hasMultipleCamera(): Boolean {
        return false
    }

    override fun isFrontCamera(): Boolean {
        return false
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun setUpCamera() {
        try {
//            if (context?.let { ContextCompat.checkSelfPermission(it, Manifest.permission.CAMERA) } !==
//                PackageManager.PERMISSION_GRANTED
//            ) {
//                (context as Activity?)?.let {
//                    ActivityCompat.requestPermissions(
//                        it, arrayOf<String>(Manifest.permission.CAMERA),
//                        50
//                    )
//                }
//            }
            mCameraId = this.getCameraId(mCameraFacing)
            mCameraCharacteristics = mCameraManager!!.getCameraCharacteristics(mCameraId!!)
            mCameraManager.openCamera(mCameraId!!, this.mCameraDeviceCallback, null)
        } catch (e: Exception) {
            println(e.toString())
        }
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun getCameraId(facing: Int): String? {
        try {
            val cameraIdList = mCameraManager!!.cameraIdList
            for (id in cameraIdList) {
                val thisFacing = mCameraManager.getCameraCharacteristics(id)
                    .get(CameraCharacteristics.LENS_FACING)!!
                if (thisFacing == facing) {
                    return id
                }
            }
        } catch (e: java.lang.Exception) {
            println(e.toString())
        }
        return facing.toString()
    }

    private val mCameraDeviceCallback: CameraDevice.StateCallback =
        @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
        object : CameraDevice.StateCallback() {
            override fun onOpened(@NonNull camera: CameraDevice) {
                mCameraDevice = camera
                startCaptureSession()
            }

            override fun onDisconnected(@NonNull camera: CameraDevice) {}
            override fun onError(@NonNull camera: CameraDevice, error: Int) {}
        }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun startCaptureSession() {
        val size = Size(mViewWidth, mViewHeight)
        mImageReader =
            ImageReader.newInstance(size.width, size.height, ImageFormat.YUV_420_888, 2)
        mImageReader!!.setOnImageAvailableListener(OnImageAvailableListener { reader ->
            if (reader != null) {
                val image: Image? = reader.acquireNextImage()
                if (image != null) {
                    if (mOnPreviewFrameListener != null) {
                        val data: ByteArray? = ImageUtils.generateNV21Data(image)
                        mOnPreviewFrameListener!!.onPreviewFrame(
                            data,
                            image.width,
                            image.height
                        )
                    }
                    image.close()
                }
            }
        }, null)
        try {
            mCameraDevice!!.createCaptureSession(
                listOf(mImageReader!!.surface),
                mCaptureStateCallback,
                null
            )
        } catch (e: CameraAccessException) {
            e.printStackTrace()
            Log.e(TAG, "Failed to start camera session")
        }
    }

    private val mCaptureStateCallback: CameraCaptureSession.StateCallback =
        @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
        object : CameraCaptureSession.StateCallback() {
            override fun onConfigured(session: CameraCaptureSession) {
                if (mCameraDevice == null) {
                    return
                }
                mCaptureSession = session
                try {
                    val builder =
                        mCameraDevice!!.createCaptureRequest(CameraDevice.TEMPLATE_PREVIEW)
                    builder.addTarget(mImageReader!!.surface)
                    builder.set(
                        CaptureRequest.CONTROL_AF_MODE,
                        CaptureRequest.CONTROL_AF_MODE_CONTINUOUS_PICTURE
                    )
                    builder.set(
                        CaptureRequest.CONTROL_AE_MODE,
                        CaptureRequest.CONTROL_AE_MODE_ON_AUTO_FLASH
                    )
                    session.setRepeatingRequest(builder.build(), null, null)
                } catch (e: CameraAccessException) {
                    e.printStackTrace()
                }
            }

            override fun onConfigureFailed(session: CameraCaptureSession) {
                Log.e(TAG, "Failed to configure capture session.")
            }
        }
}