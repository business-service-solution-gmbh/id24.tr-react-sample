package com.reactappidentify

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

import androidx.appcompat.app.AppCompatActivity
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.WritableMap
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.identify.sdk.IdentifySdk
import com.identify.sdk.IdentifyTrackingListener
import com.identify.sdk.IdentityOptions
import com.identify.sdk.repository.model.mrz.DocType
import com.identify.sdk.tracking.TrackingEvent

class IdentifyModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    private val reactContext: ReactContext = reactContext

    // This method is required to support NativeEventEmitter
    @ReactMethod
    fun addListener(eventName: String) {
        // Set up any listener or necessary functionality here
    }

    // This method is required to support NativeEventEmitter
    @ReactMethod
    fun removeListeners(count: Int) {
        // Remove listeners, clean up resources, etc.
    }

    override fun getName(): String {
        return "IdentifyModule"
    }

    private fun sendEvent(reactContext: ReactContext, eventName: String, params: WritableMap?) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
            .emit(eventName, params)
    }

    fun configure(): IdentityOptions {
        return IdentityOptions.Builder()
//            .setIdentityType(
//                listOf(
//                    IdentifyModuleTypes.PREPARE,
//                    IdentifyModuleTypes.SPEECH_TEST,
//                    IdentifyModuleTypes.IDENTIFICATION_INFORMATION_WITH_CARD_PHOTO,
//                    IdentifyModuleTypes.IDENTIFICATION_INFORMATION_WITH_NFC,
//                    IdentifyModuleTypes.TAKE_SELFIE,
//                    IdentifyModuleTypes.VALIDATE_ADDRESS,
//                    IdentifyModuleTypes.LIVENESS_TEST,
//                    IdentifyModuleTypes.VIDEO_RECORD,
//                    IdentifyModuleTypes.SIGNATURE,
//                    IdentifyModuleTypes.AGENT_CALL
//                )
//            )
            .setNfcExceptionCount(3)
            .setCallConnectionTimeOut(20000)
            .setOpenIntroPage(false)
            .setDocumentType(DocType.ID_CARD)
            .setOpenThankYouPage(false)
            .setVideoRecordTime(5000)
            .setCallConnectionTimeOut(5000)
            .setAutoSelfieWithLivenessDetection(true)
            .setEnableFaceControlInSelfie(true)
            .setEnableLightInformationInCall(true)
            .build()
    }

    @ReactMethod
    fun startIdentification(apiUrl: String, identId: String, language: String, promise: Promise) {
        try {
            val options = configure()

            val activity = currentActivity

            if (activity != null && activity is AppCompatActivity) {
                val identifyObject = IdentifySdk.Builder()
                    .api(apiUrl)
                    .lifeCycle(activity.lifecycle)
                    .options(options)
                    .build()

                identifyObject.identifyTrackingListener = object : IdentifyTrackingListener {
                    override fun trackingEventReceived(trackingEvent: TrackingEvent) {
                        val params = Arguments.createMap()

//                        if (trackingEvent.context != null) {
//                            val contextJson = JSONObject(trackingEvent.context as Map<*, *>).toString()
//                            params.putString("context", contextJson)
//                        }
                        params.putString("context", trackingEvent.context.toString())
                        params.putString("eventType", trackingEvent.eventType.toString())
                        params.putString("time", trackingEvent.time.toString())

                        sendEvent(reactContext, "TrackingEventReceived", params)
                    }
                }

                identifyObject.startIdentification(currentActivity!!, identId, language)
                promise.resolve("Identification started successfully")
            } else {
                promise.reject("Activity error", "Current activity is null or not an AppCompatActivity")
            }
        } catch (e: Exception) {
            promise.reject("Identification error", e)
        }
    }
}