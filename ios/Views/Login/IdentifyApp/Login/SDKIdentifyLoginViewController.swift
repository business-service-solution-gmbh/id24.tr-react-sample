//
//  SDKIdentifyLoginViewController.swift
//  NewTest
//
//  Created by Emir Beytekin on 17.11.2023.
//

import UIKit
import IdentifySDK
import CoreData

class SDKIdentifyLoginViewController: SDKBaseViewController {

    @IBOutlet weak var langBtn: IdentifyButton!
    @IBOutlet weak var loginBtn: IdentifyButton!
    @IBOutlet weak var identIdArea: UITextField!
    var subRejected = false
    @IBOutlet weak var versionNo: UILabel!
    @IBOutlet weak var jbView: UIView!
    var selectedServer = SelectedServerSettings()
    var envList = [SelectedServerSettings]()
    var userDefaults = UserDefaults.standard
    
    var selectedModuleList = [SdkModules]()
    var editedShowBigCustomer = false
    var editedSignLang = false
    
    var idLang: IDLang? = .TR
    var useSSLPinning = false
  
    // for react
    var cominId: String? = ""
    var cominUrl: String? = ""
    var cominLang: String? = ""
    
    @IBOutlet weak var serverSelector: IdentifyButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSDK()
    }
    
    // MARK:  Modül - Controller eşleşmesi yapıyoruz
    
    private func setupSDK() { // Modül - Controller eşleşmesi yapıyoruz
        self.manager.setSDKLang(lang: .eng)
        self.manager.loginModuleController = SDKLoginViewController.instantiate()
        self.manager.selfieModuleController = SDKSelfieViewController.instantiate()
        self.manager.idCardModuleController = SDKCardReaderViewController.instantiate()
        self.manager.nfcModuleController = SDKNfcViewController.instantiate()
        self.manager.signatureModuleController = SDKSignatureViewController.instantiate()
        self.manager.videoRecorderModuleController = SDKVideoRecorderViewController.instantiate()
        self.manager.livenessModuleController = SDKLivenessViewController.instantiate()
        self.manager.addressModuleController = SDKAddressConfirmViewController.instantiate()
        self.manager.liveStreamModuleController = SDKCallScreenViewController.instantiate()
        self.manager.speechModuleController = SDKSpeechRecViewController.instantiate()
        self.manager.thankYouViewController = SDKThankYouViewController.instantiate()
        self.manager.prepareViewController = SDKPrepareViewController.instantiate()
        self.manager.socketMessageListener = self // eğer odada farklı bir kişi varsa listener sayesinde detect edebiliyoruz.
        self.setupUI()
        if manager.jailBreakStatus {
            self.jbView.isHidden = false
            print("cihazda jb tespit edildi, bu durumu yönetebilirsiniz.")
        }
        
      self.selectedServer.apiUrl = self.cominUrl ?? ""
      if self.cominLang == "tr" {
          self.idLang = .TR
          self.manager.setSDKLang(lang: .tr)
      } else if self.cominLang == "en" {
          self.manager.setSDKLang(lang: .eng)
      } else if self.cominLang == "de" {
          self.manager.setSDKLang(lang: .de)
      }
      
      forceLoginForReact()
    }
    
    private func setupUI() {
        self.loginBtn.setTitle(self.translate(text: .connect), for: .normal)
        self.loginBtn.type = .submit
        self.loginBtn.onTap = {
            self.loginSystem()
        }
        self.loginBtn.populate()
        
        self.langBtn.setTitle("Select SDK Language", for: .normal)
        self.langBtn.type = .cancel
        self.langBtn.onTap = {
            self.showLangOptions()
        }
        self.langBtn.populate()
        self.versionNo.text = "Build No: \(Bundle.main.buildVersionNumber ?? "")"
        self.navigationItem.rightBarButtonItem = nil
        self.identIdArea.delegate = self
        self.identIdArea.tag = 0
        self.identIdArea.returnKeyType = .go
        
        self.identIdArea.text = self.cominId
    }
    
    // MARK:  Sisteme giriş yapıyoruz
    
    private func connectSDK() {
        self.view.endEditing(true)
        
        self.showLoader()
        
        self.manager.setupSDK(
            identId: identIdArea.text!,
            baseApiUrl: self.selectedServer.apiUrl,
            networkOptions: SDKNetworkOptions(timeoutIntervalForRequest: 30, timeoutIntervalForResource: 30, useSslPinning: self.useSSLPinning),
            kpsData: nil, // EĞER ELİNİZDE KPS DEN GELEN KİMLİK DATALARI VARSA ALTTAKİ KODU AKTİF EDİP BU SATIRI SİLEBİLİRSİNİZ.
//                kpsData: SDKKpsData(birthDate: "860704", validDate: "130627", serialNo: "YZM33MR63"),
            identCardType: [.idCard, .passport, .oldSchool], // destekleyeceğiniz kart tipleri
            signLangSupport: editedSignLang, // işitme engelliler için müşteri temsilcisi desteği
            nfcMaxErrorCount: 3,
            logLevel: .all,
            bigCustomerCam: editedShowBigCustomer,
            selectedModules: self.selectedModuleList,
            idCardLang: self.idLang
        ) { socketStats, apiResp, webErr in
                
            print("socket resp : \(socketStats)")
            if let err = webErr, err.errorMessages != "" { // web servisten hata gelirse
                self.showToast(type:. fail, title: self.translate(text: .coreError), subTitle: err.errorMessages, attachTo: self.view) {
                    self.hideLoader()
                }
            } else { // hata yoksa işlemlere devam ediyoruz
                if socketStats?.isConnected ==  true {
                    if apiResp.result ?? false {
                        self.manager.moduleStepOrder = 0
                        self.hideLoader()
                        self.manager.getNextModule { nextVC in
                            if !self.subRejected {
                                let navigationC = UINavigationController(rootViewController: nextVC)
                                navigationC.isModalInPresentation = true
                                self.showToast(title: self.translate(text: .coreSuccess), subTitle: self.translate(text: .loadingFirstModule), attachTo: self.view, callback: {
                                    DispatchQueue.main.async {
                                        self.navigationController?.present(navigationC, animated: true) // İlk modül başlıyor
                                    }
                                })
                            }
                        }
                    } else if (socketStats?.isConnected == false) {
                        self.showToast(title: "Socket not connected", attachTo: self.view) {
                            self.hideLoader()
                        }
                        print("socket down")
                    }
                } else {
                    self.hideLoader()
                }
            }
        }
    }
  
    private func forceLoginForReact() {
      self.idLang = .TR
      self.connectSDK()
    }
    
    private func loginSystem() {
        if identIdArea.text == "" {
            self.showToast(type: .fail, title: self.translate(text: .coreError), subTitle: "Ident ID Girmediniz", attachTo: self.view) {
                return
            }
        } else {
            self.showIdLang()
//            self.showNetworkOptions()
        }
    }
    
    func getCustomList() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//                
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EnvServers")
//        
//        do {
//            let fetchResults = try managedContext.fetch(fetchRequest)
//            for item in fetchResults as! [NSManagedObject] {
//                print(item)
////                shoppingItems.append(item.value(forKey: "item") as! String)
//            }
//            
//        } catch let error{
//            print(error.localizedDescription)
//        }
    }
}

extension SDKIdentifyLoginViewController: SDKSocketListener {
    
    func listenSocketMessage(message: SDKCallActions) {
        switch message {
            case .wrongSocketActionErr(let error):
                self.hideLoader()
                self.showToast(type: .fail, title: self.translate(text: .coreError), subTitle: error, attachTo: self.view) {
                    return
                }
                return
                
            case .subrejectedDismiss:
                self.subRejected = true
                self.showToast(type: .fail, title: self.translate(text: .coreError), subTitle: self.translate(text: .anotherUserInToTheRoom), attachTo: self.view) {
                    return
                }
            default:
                self.subRejected = false
                return
        }
    }
}

extension SDKIdentifyLoginViewController { // Dil seçme & değiştirme işlemleriasdadsa
    func showIdLang() {
        let actionSheetController: UIAlertController = UIAlertController(title: "Okutulacak kimlik / pasaport dilini seçin", message: nil, preferredStyle: .actionSheet)

        let firstAction: UIAlertAction = UIAlertAction(title: "Türkçe", style: .default) { action -> Void in
            self.idLang = .TR
//            self.showNetworkOptions()
            self.connectSDK()
        }
        
        let secondAct: UIAlertAction = UIAlertAction(title: "Diğer", style: .default) { action -> Void in
            self.idLang = .OTHER
//            self.showNetworkOptions()
            self.connectSDK()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }

        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAct)
        actionSheetController.addAction(cancelAction)
        actionSheetController.popoverPresentationController?.sourceView = self.view
        present(actionSheetController, animated: true)
    }
    
    @objc func showLangOptions() {
        let actionSheetController: UIAlertController = UIAlertController(title: "SDK Dilini Seçin", message: nil, preferredStyle: .actionSheet)
        
        let firstAction: UIAlertAction = UIAlertAction(title: "Ingilizce", style: .default) { action -> Void in
            self.manager.setSDKLang(lang: .eng)
            self.setupUI()
        }
        
        let secondAct: UIAlertAction = UIAlertAction(title: "Türkçe", style: .default) { action -> Void in
            self.manager.setSDKLang(lang: .tr)
            self.setupUI()
        }
        
        let thirdAct: UIAlertAction = UIAlertAction(title: "Almanca", style: .default) { action -> Void in
            self.manager.setSDKLang(lang: .de)
            self.setupUI()
        }
        
        let russianAct: UIAlertAction = UIAlertAction(title: "Rusça", style: .default) { action -> Void in
            self.manager.setSDKLang(lang: .ru)
            self.setupUI()
        }
        
        let azeriAct: UIAlertAction = UIAlertAction(title: "Azerice", style: .default) { action -> Void in
            self.manager.setSDKLang(lang: .az)
            self.setupUI()
        }
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAct)
        actionSheetController.addAction(thirdAct)
        actionSheetController.addAction(russianAct)
        actionSheetController.addAction(azeriAct)
        
        actionSheetController.popoverPresentationController?.sourceView = self.view
        present(actionSheetController, animated: true)
    }
    
    
}

extension SDKIdentifyLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField.tag == 0 {
            self.view.endEditing(true)
//            self.showNetworkOptions()
            self.showIdLang()
            return true
        }
        
        return true
    }
}
