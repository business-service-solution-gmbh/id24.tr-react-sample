import { NativeModules, NativeEventEmitter, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'identify-sdk-react-native' doesn't seem to be linked. Make sure: \n\n${Platform.select(
    { ios: "- You have run 'pod install'\n", default: '' }
  )}- You rebuilt the app after installing the package\n` +
  `- You are not using Expo managed workflow\n`;

const IdentifyReactNative = NativeModules.IdentifyReactNative
  ? NativeModules.IdentifyReactNative
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

enum IdentifyEventName {
  ON_CALL_PROCESS_FINISED = 'IdentifyReactNative:callProcessFinished',
  ON_NFC_PROCESS_FINISED = 'IdentifyReactNative:nfcProcessFinished',
  ON_SPEECH_PROCESS_FINISED = 'IdentifyReactNative:speechProcessFinished',
  ON_TAKE_CARD_PHOTO_PROCESS_FINISED = 'IdentifyReactNative:takeCardPhotoProcessFinished',
  ON_TAKE_SELFIE_PROCESS_FINISED = 'IdentifyReactNative:takeSelfieProcessFinished',
  ON_VALIDATE_ADDRESS_PROCESS_FINISED = 'IdentifyReactNative:validateAddressProcessFinished',
  ON_VIDEO_RECORD_PROCESS_FINISED = 'IdentifyReactNative:videoRecordProcessFinished',
  ON_LIVENESS_DETECTION_PROCESS_FINISED = 'IdentifyReactNative:livenessDetectionProcessFinished',
  ON_SIGNITURE_PROCESS_FINISED = 'IdentifyReactNative:signatureProcessFinished',
  ON_BACK_PRESSED = 'IdentifyReactNative:backPressed',
  ON_REDIRECT_CALL_PROCESS = 'IdentifyReactNative:redirectCallProcess',
  ON_SDK_DESTROYED = 'IdentifyReactNative:sdkDestroyed',
  ON_SDK_PAUSED = 'IdentifyReactNative:sdkPaused',
  ON_SDK_RESUMED = 'IdentifyReactNative:sdkResumed',
  ON_WebRTC_INIT_CALL = 'IdentifyReactNative:onInitCall',
  ON_WebRTC_START_CALL = 'IdentifyReactNative:onStartCall',
  ON_WebRTC_TERMINATED_CALL = 'IdentifyReactNative:onTerminatedCall',
  ON_WebRTC_CUSTOMER_IS_ONLINE = 'IdentifyReactNative:onCustomerIsOnline',
  ON_WebRTC_CUSTOMER_IS_OFFLINE = 'IdentifyReactNative:onCustomerIsOffline',
  ON_WebRTC_SUBSCRIBED = 'IdentifyReactNative:onSubscribed',
  ON_WebRTC_SUB_REJECTED = 'IdentifyReactNative:onSubRejected',
  ON_WebRTC_MISSED_CALL = 'IdentifyReactNative:onMissedCall',
  ON_WebRTC_TOGGLED_CAMERA = 'IdentifyReactNative:onToggledCamera',
  ON_ALL_PROCESS_FINISHED = 'IdentifyReactNative:allProcessFinished',
}

export class IdentifySdk {
  private static instance: IdentifySdk;

  private identifyEventEmitter = new NativeEventEmitter(
    Platform.OS === 'ios' ? NativeModules.RNEventEmitter : IdentifyReactNative
  );

  // eslint-disable-next-line @typescript-eslint/no-empty-function, no-useless-constructor
  private constructor() {}

  static getInstance(): IdentifySdk {
    if (!IdentifySdk.instance) {
      IdentifySdk.instance = new IdentifySdk();
    }
    return IdentifySdk.instance;
  }

  private addListener(identifyEventName: IdentifyEventName, callback: (event: any) => void) {
    return this.identifyEventEmitter.addListener(identifyEventName, callback);
  }

  public startSdk(args: {
    identificationId: string;
    language: string;
    baseApiUrl: string;
    baseSocketUrl: string;
    socketPort: string;
    stunUrl: string;
    stunPort: string;
    turnUrl: string;
    turnPort: string;
    turnUsername: string;
    turnPassword: string;
    allProcessFinished?: (data?: string) => void;
    callProcessFinished?: (data?: string) => void;
    nfcProcessFinished?: (data?: string) => void;
    speechProcessFinished?: (data?: string) => void;
    takeCardPhotoProcessFinished?: (data?: string) => void;
    takeSelfieProcessFinished?: (data?: string) => void;
    validateAddressProcessFinished?: (data?: string) => void;
    videoRecordProcessFinished?: (data?: string) => void;
    livenessDetectionProcessFinished?: (data?: string) => void;
    signatureProcessFinished?: (data?: string) => void;
    backPressed?: (data?: string) => void;
    redirectCallProcess?: (data?: string) => void;
    sdkDestroyed?: (data?: string) => void;
    sdkPaused?: (data?: string) => void;
    sdkResumed?: (data?: string) => void;
    onInitCall?: (data?: string) => void;
    onStartCall?: (data?: string) => void;
    onTerminatedCall?: (data?: string) => void;
    onCustomerIsOnline?: (data?: string) => void;
    onCustomerIsOffline?: (data?: string) => void;
    onSubscribed?: (data?: string) => void;
    onSubRejected?: (data?: string) => void;
    onMissedCall?: (data?: string) => void;
    onToggledCamera?: (data?: string) => void;
  }) {
    this.removeAllListeners();
    if (args.allProcessFinished != null)
      this.addListener(IdentifyEventName.ON_ALL_PROCESS_FINISHED, (data: any) => {
        args.allProcessFinished?.(data);
      });
    if (args.callProcessFinished != null)
      this.addListener(IdentifyEventName.ON_CALL_PROCESS_FINISED, (data: any) => {
        args.callProcessFinished?.(data);
      });
    if (args.nfcProcessFinished != null)
      this.addListener(IdentifyEventName.ON_NFC_PROCESS_FINISED, (data: any) => {
        args.nfcProcessFinished?.(data);
      });
    if (args.speechProcessFinished != null)
      this.addListener(IdentifyEventName.ON_SPEECH_PROCESS_FINISED, (data: any) => {
        args.speechProcessFinished?.(data);
      });
    if (args.takeCardPhotoProcessFinished != null)
      this.addListener(IdentifyEventName.ON_TAKE_CARD_PHOTO_PROCESS_FINISED, (data: any) => {
        args.takeCardPhotoProcessFinished?.(data);
      });
    if (args.takeSelfieProcessFinished != null)
      this.addListener(IdentifyEventName.ON_TAKE_SELFIE_PROCESS_FINISED, (data: any) => {
        args.takeSelfieProcessFinished?.(data);
      });
    if (args.validateAddressProcessFinished != null)
      this.addListener(IdentifyEventName.ON_VALIDATE_ADDRESS_PROCESS_FINISED, (data: any) => {
        args.validateAddressProcessFinished?.(data);
      });
    if (args.videoRecordProcessFinished != null)
      this.addListener(IdentifyEventName.ON_VIDEO_RECORD_PROCESS_FINISED, (data: any) => {
        args.videoRecordProcessFinished?.(data);
      });
    if (args.livenessDetectionProcessFinished != null)
      this.addListener(IdentifyEventName.ON_LIVENESS_DETECTION_PROCESS_FINISED, (data: any) => {
        args.livenessDetectionProcessFinished?.(data);
      });
    if (args.signatureProcessFinished != null)
      this.addListener(IdentifyEventName.ON_SIGNITURE_PROCESS_FINISED, (data: any) => {
        args.signatureProcessFinished?.(data);
      });
    if (args.backPressed != null)
      this.addListener(IdentifyEventName.ON_BACK_PRESSED, (data: any) => {
        args.backPressed?.(data);
      });
    if (args.redirectCallProcess != null)
      this.addListener(IdentifyEventName.ON_REDIRECT_CALL_PROCESS, (data: any) => {
        args.redirectCallProcess?.(data);
      });
    if (args.sdkDestroyed != null)
      this.addListener(IdentifyEventName.ON_SDK_DESTROYED, (data: any) => {
        args.sdkDestroyed?.(data);
      });
    if (args.sdkPaused != null)
      this.addListener(IdentifyEventName.ON_SDK_PAUSED, (data: any) => {
        args.sdkPaused?.(data);
      });
    if (args.sdkResumed != null)
      this.addListener(IdentifyEventName.ON_SDK_RESUMED, (data: any) => {
        args.sdkResumed?.(data);
      });
    if (args.onInitCall != null)
      this.addListener(IdentifyEventName.ON_WebRTC_INIT_CALL, (data: any) => {
        args.onInitCall?.(data);
      });
    if (args.onStartCall != null)
      this.addListener(IdentifyEventName.ON_WebRTC_START_CALL, (data: any) => {
        args.onStartCall?.(data);
      });
    if (args.onTerminatedCall != null)
      this.addListener(IdentifyEventName.ON_WebRTC_TERMINATED_CALL, (data: any) => {
        args.onTerminatedCall?.(data);
      });
    if (args.onCustomerIsOnline != null)
      this.addListener(IdentifyEventName.ON_WebRTC_CUSTOMER_IS_ONLINE, (data: any) => {
        args.onCustomerIsOnline?.(data);
      });
    if (args.onCustomerIsOffline != null)
      this.addListener(IdentifyEventName.ON_WebRTC_CUSTOMER_IS_OFFLINE, (data: any) => {
        args.onCustomerIsOffline?.(data);
      });
    if (args.onSubscribed != null)
      this.addListener(IdentifyEventName.ON_WebRTC_SUBSCRIBED, (data: any) => {
        args.onSubscribed?.(data);
      });
    if (args.onSubRejected != null)
      this.addListener(IdentifyEventName.ON_WebRTC_SUB_REJECTED, (data: any) => {
        args.onSubRejected?.(data);
      });
    if (args.onMissedCall != null)
      this.addListener(IdentifyEventName.ON_WebRTC_MISSED_CALL, (data: any) => {
        args.onMissedCall?.(data);
      });
    if (args.onToggledCamera != null)
      this.addListener(IdentifyEventName.ON_WebRTC_TOGGLED_CAMERA, (data: any) => {
        args.onToggledCamera?.(data);
      });

    return IdentifyReactNative.startSdk({
      identificationId: args.identificationId,
      language: args.language,
      baseApiUrl: args.baseApiUrl,
      baseSocketUrl: args.baseSocketUrl,
      socketPort: args.socketPort,
      stunUrl: args.stunUrl,
      stunPort: args.stunPort,
      turnUrl: args.turnUrl,
      turnPort: args.turnPort,
      turnUsername: args.turnUsername,
      turnPassword: args.turnPassword,
    });
  }

  private removeAllListeners() {
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_CALL_PROCESS_FINISED);
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_NFC_PROCESS_FINISED);
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_SPEECH_PROCESS_FINISED);
    this.identifyEventEmitter.removeAllListeners(
      IdentifyEventName.ON_TAKE_CARD_PHOTO_PROCESS_FINISED
    );
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_TAKE_SELFIE_PROCESS_FINISED);
    this.identifyEventEmitter.removeAllListeners(
      IdentifyEventName.ON_VALIDATE_ADDRESS_PROCESS_FINISED
    );
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_VIDEO_RECORD_PROCESS_FINISED);
    this.identifyEventEmitter.removeAllListeners(
      IdentifyEventName.ON_LIVENESS_DETECTION_PROCESS_FINISED
    );
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_SIGNITURE_PROCESS_FINISED);
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_BACK_PRESSED);
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_REDIRECT_CALL_PROCESS);
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_SDK_DESTROYED);
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_SDK_PAUSED);
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_SDK_RESUMED);
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_WebRTC_INIT_CALL);
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_WebRTC_START_CALL);
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_WebRTC_TERMINATED_CALL);
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_WebRTC_CUSTOMER_IS_ONLINE);
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_WebRTC_CUSTOMER_IS_OFFLINE);
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_WebRTC_SUBSCRIBED);
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_WebRTC_SUB_REJECTED);
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_WebRTC_MISSED_CALL);
    this.identifyEventEmitter.removeAllListeners(IdentifyEventName.ON_WebRTC_TOGGLED_CAMERA);
  }
}
