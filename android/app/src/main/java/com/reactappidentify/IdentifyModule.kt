package com.reactappidentify

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

import androidx.lifecycle.LifecycleOwner

import com.identify.sdk.IdentifySdk
import com.identify.sdk.IdentityOptions
import com.identify.sdk.repository.model.enums.IdentifyModuleTypes
import com.identify.sdk.repository.model.mrz.DocType

class IdentifyModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return "IdentifyModule"
    }

    fun configure(): IdentityOptions {
        return IdentityOptions.Builder()
            .setIdentityType(
                listOf(
                    IdentifyModuleTypes.PREPARE,
                    IdentifyModuleTypes.SPEECH_TEST,
                    IdentifyModuleTypes.IDENTIFICATION_INFORMATION_WITH_CARD_PHOTO,
                    IdentifyModuleTypes.IDENTIFICATION_INFORMATION_WITH_NFC,
                    IdentifyModuleTypes.TAKE_SELFIE,
                    IdentifyModuleTypes.VALIDATE_ADDRESS,
                    IdentifyModuleTypes.LIVENESS_TEST,
                    IdentifyModuleTypes.VIDEO_RECORD,
                    IdentifyModuleTypes.SIGNATURE,
                    IdentifyModuleTypes.AGENT_CALL
                )
            )
            .setNfcExceptionCount(3)
            .setCallConnectionTimeOut(20000)
            .setOpenIntroPage(false)
            .setDocumentType(DocType.ID_CARD)
            .setOpenThankYouPage(false)
            .setVideoRecordTime(5000)
            .setCallConnectionTimeOut(5000)
            .setAutoSelfieWithLivenessDetection(false)
            .setEnableFaceControlInSelfie(true)
            .setEnableLightInformationInCall(true)
            .build()
    }

    @ReactMethod
    fun startIdentification(apiUrl: String, sessionId: String, language: String, promise: Promise) {
        try {
            val options = configure()
//            val activity = currentActivity as AppCompatActivity

            val lifecycle: Lifecycle by lazy {
                ((this.reactContext as ReactContext).currentActivity as AppCompatActivity).lifecycle
            }

            val identifyObject = IdentifySdk.Builder()
                .api(apiUrl)
                .lifeCycle(activity.lifecycle)
                .options(options)
                .build()

            identifyObject.startIdentification(currentActivity!!, sessionId, language)
            promise.resolve("Identification started successfully")
        } catch (e: Exception) {
            promise.reject("Identification error", e)
        }
    }
}