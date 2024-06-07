import { IdentifySdk } from '../modules/identify'
import identifyConfigJson from '../../IdentifyConfig.json'

export interface IdentifySdkParamsType {
  identificationId: string;
  handleCallProcessFinished?: (data?: string) => void;
  handleNfcProcessFinished?: (data?: string) => void;
  handleSpeechProcessFinished?: (data?: string) => void;
  handleTakeCardPhotoProcessFinished?: (data?: string) => void;
  handleTakeSelfieProcessFinished?: (data?: string) => void;
  handleValidateAddressProcessFinished?: (data?: string) => void;
  handleVideoRecordProcessFinished?: (data?: string) => void;
  handleLivenessDetectionProcessFinished?: (data?: string) => void;
  handleSignatureProcessFinished?: (data?: string) => void;
  handleSdkResumed?: (data?: string) => void;
  handleSdkPaused?: (data?: string) => void;
  handleSdkDestroyed?: (data?: string) => void;
  handleInitCall?: (data?: string) => void;
  handleStartCall?: (data?: string) => void;
  handleTerminatedCall?: (data?: string) => void;
  handleCustomerIsOnline?: (data?: string) => void;
  handleCustomerIsOffline?: (data?: string) => void;
  handleSubscribed?: (data?: string) => void;
  handleSubRejected?: (data?: string) => void;
  handleMissedCall?: (data?: string) => void;
  handleToggledCamera?: (data?: string) => void;
}

export const startIdentifySdk = (identifySdkParams: IdentifySdkParamsType): void => {
  IdentifySdk.getInstance()
    .startSdk({
      identificationId: identifySdkParams.identificationId,
      language: 'tr',
      baseApiUrl: identifyConfigJson.baseApiUrl,
      baseSocketUrl: identifyConfigJson.baseSocketUrl,
      socketPort: identifyConfigJson.socketPort,
      stunUrl: identifyConfigJson.stunUrl,
      stunPort: identifyConfigJson.stunPort,
      turnUrl: identifyConfigJson.turnUrl,
      turnPort: identifyConfigJson.turnPort,
      turnUsername: identifyConfigJson.turnUsername,
      turnPassword: identifyConfigJson.turnPassword,
      callProcessFinished: identifySdkParams?.handleCallProcessFinished,
      nfcProcessFinished: identifySdkParams?.handleNfcProcessFinished,
      speechProcessFinished: identifySdkParams?.handleSpeechProcessFinished,
      takeCardPhotoProcessFinished: identifySdkParams?.handleTakeCardPhotoProcessFinished,
      takeSelfieProcessFinished: identifySdkParams?.handleTakeSelfieProcessFinished,
      validateAddressProcessFinished: identifySdkParams?.handleValidateAddressProcessFinished,
      videoRecordProcessFinished: identifySdkParams?.handleVideoRecordProcessFinished,
      livenessDetectionProcessFinished: identifySdkParams?.handleLivenessDetectionProcessFinished,
      signatureProcessFinished: identifySdkParams?.handleSignatureProcessFinished,
      sdkResumed: identifySdkParams?.handleSdkResumed,
      sdkPaused: identifySdkParams?.handleSdkPaused,
      sdkDestroyed: identifySdkParams?.handleSdkDestroyed,
      onInitCall: identifySdkParams?.handleInitCall,
      onStartCall: identifySdkParams?.handleStartCall,
      onTerminatedCall: identifySdkParams?.handleTerminatedCall,
      onCustomerIsOnline: identifySdkParams?.handleCustomerIsOnline,
      onCustomerIsOffline: identifySdkParams?.handleCustomerIsOffline,
      onSubscribed: identifySdkParams?.handleSubscribed,
      onSubRejected: identifySdkParams?.handleSubRejected,
      onMissedCall: identifySdkParams?.handleMissedCall,
      onToggledCamera: identifySdkParams?.handleToggledCamera,
    })
    .catch((error: unknown) => {
      console.error('Error starting SDK:', error);
    });
};
