package com.reactappidentify

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Lifecycle
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

            val activity = currentActivity

            if (activity != null && activity is AppCompatActivity) {
                val identifyObject = IdentifySdk.Builder()
                    .api(apiUrl)
                    .lifeCycle(activity.lifecycle)
                    .options(options)
                    .build()

                Log.d("IdentifyModule", "Current Activity: $activity")
                Log.d("IdentifyModule", "Starting Identification with apiUrl: $apiUrl, sessionId: $sessionId, language: $language")

                identifyObject.startIdentification(currentActivity!!, sessionId, language)
                promise.resolve("Identification started successfully")
            } else {
                promise.reject("Activity error", "Current activity is null or not an AppCompatActivity")
            }
        } catch (e: Exception) {
            promise.reject("Identification error", e)
        }
    }
}