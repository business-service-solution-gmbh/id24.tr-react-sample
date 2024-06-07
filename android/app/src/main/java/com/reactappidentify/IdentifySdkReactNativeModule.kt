package com.reactappidentify

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import androidx.appcompat.app.AppCompatActivity
import com.google.gson.Gson
import com.identify.sdk.IdentifySdk
import com.identify.sdk.IdentityOptions
import com.identify.sdk.repository.model.enums.IdentifyModuleTypes
import com.identify.sdk.repository.model.enums.ModuleCacheType
import com.identify.sdk.repository.model.mrz.DocType
import androidx.lifecycle.Lifecycle
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.identify.sdk.IdentifyErrorListener
import com.identify.sdk.IdentifyNavigationListener
import com.identify.sdk.IdentifyResultListener
import com.identify.sdk.IdentifySocketListener
import com.identify.sdk.SdkLifeCycleListener
import com.identify.sdk.repository.model.dto.MrzDto
import com.identify.sdk.repository.model.entities.ScannedMrzInfo
import org.json.JSONObject

class IdentifySdkReactNativeModule(private val reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext) {


    override fun getName(): String {
        return "IdentifyReactNative"
    }

    @ReactMethod
    fun addListener(eventName: String?) {
        // Keep: Required for RN built in Event Emitter Calls.
    }

    @ReactMethod
    fun removeListeners(count: Int?) {
        // Keep: Required for RN built in Event Emitter Calls.
    }

    private val EVENT_PREFIX = "IdentifyReactNative"


    private fun setupIdentifySdk(
        baseApiUrl: String,
        baseSocketUrl: String,
        socketPort: String,
        stunUrl: String,
        stunPort: String,
        turnUrl: String,
        turnPort: String,
        username: String,
        password: String,
    ): IdentifySdk {

        val gson = Gson()

        val identityOptions = IdentityOptions.Builder()
            .setIdentityType(
                listOf(
                    IdentifyModuleTypes.IDENTIFICATION_INFORMATION_WITH_CARD_PHOTO,
                    IdentifyModuleTypes.IDENTIFICATION_INFORMATION_WITH_NFC,
                    IdentifyModuleTypes.TAKE_SELFIE,
                    IdentifyModuleTypes.VALIDATE_ADDRESS,
                    IdentifyModuleTypes.LIVENESS_TEST,
                    IdentifyModuleTypes.VIDEO_RECORD,
                    IdentifyModuleTypes.SIGNATURE,
                    IdentifyModuleTypes.SPEECH_TEST,
                    IdentifyModuleTypes.AGENT_CALL
                )
            )
            .setNfcExceptionCount(3)
            .setCallConnectionTimeOut(20000)
            .setOpenIntroPage(false)
            .setDocumentType(DocType.ID_CARD)
            .setModuleCacheType(ModuleCacheType.ALWAYS_BACK_TO_TOP)
            .setOpenThankYouPage(false)
            .setVideoRecordTime(5000)
            .setCallConnectionTimeOut(5000)
            .setAutoSelfieWithLivenessDetection(false)
            .setEnableFaceControlInSelfie(true)
            .setEnableLightInformationInCall(true)
            .build()

        val lifecycle: Lifecycle by lazy {
            ((this.reactContext as ReactContext).currentActivity as AppCompatActivity).lifecycle
        }


        val identifyObject = IdentifySdk.Builder()
            .api(baseApiUrl)
            .socket(baseSocketUrl, socketPort)
            .stun(stunUrl, stunPort)
            .turn(turnUrl, turnPort, username, password)
            .lifeCycle(lifecycle)
            .options(identityOptions)
            .build()

        fun eventEmit(eventName: String, params: Any?) {
            val jsModule =
                reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
            val identifyEventName = "${EVENT_PREFIX}:${eventName}"
            jsModule.emit(identifyEventName, params)
        }

        identifyObject.identifyErrorListener = object : IdentifyErrorListener {
            override fun identError(errorMessage: String) {
                eventEmit("identError", errorMessage)
            }
        }

        identifyObject.identifyNavigationListener = object : IdentifyNavigationListener {
            override fun backPressed(whereFrom: String, returnFromRedirect: Boolean) {
                val jsonObject = JSONObject()
                jsonObject.put("whereFrom", whereFrom)
                jsonObject.put("returnFromRedirect", returnFromRedirect)
                eventEmit("backPressed", jsonObject)
            }

            override fun redirectCallProcess() {
                eventEmit("redirectCallProcess", null)
            }
        }

        identifyObject.sdkLifeCycleListener = object : SdkLifeCycleListener {
            override fun sdkDestroyed() {
                eventEmit("sdkDestroyed", null)
            }

            override fun sdkPaused() {
                eventEmit("sdkPaused", null)
            }

            override fun sdkResumed() {
                eventEmit("sdkResumed", null)
            }
        }

        identifyObject.identifySocketListener = object : IdentifySocketListener {
            override fun onInitCall() {
                eventEmit("onInitCall", null)
            }

            override fun onStartCall() {
                eventEmit("onStartCall", null)
            }

            override fun onTerminatedCall() {
                eventEmit("onTerminatedCall", null)
            }

            override fun onCustomerIsOnline() {
                eventEmit("onCustomerIsOnline", null)
            }

            override fun onCustomerIsOffline() {
                eventEmit("onCustomerIsOffline", null)
            }

            override fun onSubscribed() {
                eventEmit("onSubscribed", null)
            }

            override fun onSubRejected() {
                eventEmit("onSubRejected", null)
            }

            override fun onMissedCall() {
                eventEmit("onMissedCall", null)
            }

            override fun onToggledCamera() {
                eventEmit("onToggledCamera", null)
            }
        }

        identifyObject.identifyResultListener = object : IdentifyResultListener {
            override fun allProcessFinished() {
                eventEmit("allProcessFinished", null)
            }

            override fun callProcessFinished(
                withRedirect: Boolean,
                withCallNfc: Boolean,
                mrzDto: MrzDto?
            ) {
                val jsonObject = JSONObject()
                if (mrzDto != null) jsonObject.put("mrzDto", gson.toJson(mrzDto))
                jsonObject.put("withRedirect", withRedirect)
                jsonObject.put("withCallNfc", withCallNfc)
                eventEmit("callProcessFinished", jsonObject)

            }

            override fun nfcProcessFinished(isSuccess: Boolean, mrzDto: MrzDto?) {
                try {
                    val jsonObject = JSONObject()
                    if (mrzDto != null) jsonObject.put("mrzDto", gson.toJson(mrzDto))
                    jsonObject.put("isSuccess", isSuccess)
                    eventEmit("nfcProcessFinished", jsonObject)
                } catch (e: Exception) {
                    eventEmit("nfcProcessFinished", null)
                }
            }

            override fun signatureProcessFinished() {
                eventEmit("signatureProcessFinished", null)

            }

            override fun speechProcessFinished() {
                eventEmit("speechProcessFinished", null)
            }

            override fun takeCardPhotoProcessFinished(scannedMrzInfo: ScannedMrzInfo) {
                eventEmit(
                    "takeCardPhotoProcessFinished",
                    gson.toJson(scannedMrzInfo)
                )
            }

            override fun takeSelfieProcessFinished() {
                eventEmit("takeSelfieProcessFinished", null)

            }

            override fun validateAddressProcessFinished() {
                eventEmit("validateAddressProcessFinished", null)

            }


            override fun videoRecordProcessFinished() {
                eventEmit("videoRecordProcessFinished", null)

            }

            override fun livenessDetectionProcessFinished() {
                eventEmit("livenessDetectionProcessFinished", null)
            }

        }
        return identifyObject;
    }
    @ReactMethod
    fun startSdk(arguments: ReadableMap, promise: Promise) {

        data class SdkConfig(
            val identificationId: String?,
            val language: String?,
            val baseApiUrl: String?,
            val baseSocketUrl: String?,
            val socketPort: String?,
            val stunUrl: String?,
            val stunPort: String?,
            val turnUrl: String?,
            val turnPort: String?,
            val turnUsername: String?,
            val turnPassword: String?
        )

        val sdkConfig = SdkConfig(
            identificationId = arguments.getString("identificationId"),
            language = arguments.getString("language"),
            baseApiUrl = arguments.getString("baseApiUrl"),
            baseSocketUrl = arguments.getString("baseSocketUrl"),
            socketPort = arguments.getString("socketPort"),
            stunUrl = arguments.getString("stunUrl"),
            stunPort = arguments.getString("stunPort"),
            turnUrl = arguments.getString("turnUrl"),
            turnPort = arguments.getString("turnPort"),
            turnUsername = arguments.getString("turnUsername"),
            turnPassword = arguments.getString("turnPassword")
        )

        val activity =
            currentActivity ?: return promise.reject("ActivityError", "Activity not found")

        try {
            setupIdentifySdk(
                sdkConfig.baseApiUrl!!,
                sdkConfig.baseSocketUrl!!,
                sdkConfig.socketPort!!,
                sdkConfig.stunUrl!!,
                sdkConfig.stunPort!!,
                sdkConfig.turnUrl!!,
                sdkConfig.turnPort!!,
                sdkConfig.turnUsername!!,
                sdkConfig.turnPassword!!)
                .startIdentification(activity, sdkConfig.identificationId!!, sdkConfig.language!!)
            promise.resolve(null)
        } catch (e: Exception) {
            promise.reject("SdkError", "Error starting identification", e)
        }
    }


}