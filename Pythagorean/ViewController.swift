//
//  ViewController.swift
//  Pythagorean
//
//  Created by Ioannis on 10/3/21.
//

import UIKit
import CoreData
import GoogleMobileAds
import SwiftKeychainWrapper


//Global Variables
let appDelegate = UIApplication.shared.delegate as? AppDelegate


//importAD
struct Constants {
    static let bannerUnitID = "ca-app-pub-7727480235361635/7085042041"
    static let testBannerID = "ca-app-pub-3940256099942544/2934735716"
    static let interUnitID = "ca-app-pub-7727480235361635/2713362823"
    static let testInter = "ca-app-pub-3940256099942544/4411468910"
    static let akkadian = "Akkadian256"
}


class ViewController: UIViewController, UITextFieldDelegate{
    
    
    var rollTracker: Int = 0
    var isPaidVersionOn: Bool = false
    //importADinter
    private var interstitial: GADInterstitial?

    
    @IBOutlet weak var imgActiv: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var btnQuestion: UIButton!
    @IBOutlet weak var btnStore: UIButton!
    @IBOutlet weak var txtScript: UITextField!
    @IBOutlet weak var dtPicker: UIDatePicker!
    @IBOutlet weak var lblStored1: UILabel!
    @IBOutlet weak var lblStored2: UILabel!
    @IBOutlet weak var lblStored3: UILabel!
    //importADBanner
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Pythagorean"
       
        self.txtScript.becomeFirstResponder()
        
        //FontDetection
        /*
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }*/
        
        if let filePath = Bundle.main.path(forResource: icons.icon1.rawValue, ofType:     "png"), let image = UIImage(contentsOfFile: filePath) {    self.imgActiv.contentMode = .scaleAspectFit
            self.imgActiv.image = image
        }
        
        if let filePath = Bundle.main.path(forResource: icons.icon1.rawValue, ofType:     "png"), let image = UIImage(contentsOfFile: filePath) {    self.img1.contentMode = .scaleAspectFit
            self.img1.image = image
        }
        
        if let filePath = Bundle.main.path(forResource: icons.icon2.rawValue, ofType:     "png"), let image = UIImage(contentsOfFile: filePath) {    self.img2.contentMode = .scaleAspectFit
            self.img2.image = image
        }
        
        if let filePath = Bundle.main.path(forResource: icons.icon3.rawValue, ofType:     "png"), let image = UIImage(contentsOfFile: filePath) {    self.img3.contentMode = .scaleAspectFit
            self.img3.image = image
        }
        
        //importADBanner
        self.bannerView.adUnitID = Constants.bannerUnitID
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        self.bannerView.delegate = self
     
     
        //importADinter
        self.interstitial = createAd()
        loadFreeOrPaid()
        configureView()
       
        
    }//viewDidLoad

    
    
    override func viewWillAppear(_ animated: Bool) {
        self.txtScript.becomeFirstResponder()
    }
    
  
    
    
    
    //MARK: - Actions
    
    @IBAction func changeQuestion(_ sender: Any) {
       rollTheQuestion()
       // checkAndPlayAd()
    }//Action
    
    

    //importADinter
    @IBAction func storeAnswer(_ sender: Any) {
        if self.txtScript.text == "" {
            //Do nothing
        } else {
            saveAnswerInCoreData {(done) in
                if done {
                    print("answer was saved in core data")
                } else {
                    print("not able to save in core data")
                }
            }//saveFunc
            informLabel()
            rollTheQuestion()
            self.txtScript.text = ""
            if self.rollTracker == 0 && !self.isPaidVersionOn{
            checkAndPlayAd()
            }
        }
       
        
        
    
    }
    
    
    
    
    @IBAction func showKioskAlert(_ sender: Any) {
        print("Button Pushed")
        txtScript.resignFirstResponder()
        if isPaidVersionOn {
            showLogo()
        } else {
            showKiosk()
        }
       
       // showPaidVersionAlert()
    }
    
    
    
    
    
    
    //MARK: - Functions
    
    func rollTheQuestion(){
        if self.rollTracker == 0 {
            arrangeQuestionAndIcon(myQuestion: LocalizedString.question2.localized, myIcon: icons.icon2.rawValue)
            self.rollTracker += 1
            
        } else if self.rollTracker == 1 {
            arrangeQuestionAndIcon(myQuestion:LocalizedString.question3.localized, myIcon: icons.icon3.rawValue)
            self.rollTracker += 1
            
        } else if self.rollTracker == 2 {
            arrangeQuestionAndIcon(myQuestion: LocalizedString.question1.localized, myIcon: icons.icon1.rawValue)
            self.rollTracker = 0
        }
    }//roll
    
    
    
    func arrangeQuestionAndIcon(myQuestion: String, myIcon: String){
        self.btnQuestion.setTitle(myQuestion , for: .normal)
        if let filePath = Bundle.main.path(forResource: myIcon, ofType:     "png"), let image = UIImage(contentsOfFile: filePath) {    self.imgActiv.contentMode = .scaleAspectFit
            self.imgActiv.image = image
        }
    }//arrange
    
    
    func saveAnswerInCoreData(completion: (_ finished: Bool) -> ()){
        //layTheCoreFoundation
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let myAnswer = Answer(context: managedContext)
        
        //passTheData
        myAnswer.date = self.dtPicker.date
        myAnswer.textOfAnswer = self.txtScript.text
        if self.rollTracker == 0 {
            myAnswer.kind = kinds.kind1.rawValue
        } else if self.rollTracker == 1 {
            myAnswer.kind = kinds.kind2.rawValue
        } else if self.rollTracker == 2 {
            myAnswer.kind = kinds.kind3.rawValue
        }
        
        //DoTryCatch to SAVE the data
        do {
            try managedContext.save()
            print("Answer saved")
            completion(true)
        } catch {
            print("Failed to save with note filled", error.localizedDescription)
            completion(false)
        }
        
        
    }//save
    
    func informLabel(){
        if self.rollTracker == 0 {
            self.lblStored1.text = self.txtScript.text
            self.lblStored1.font = UIFont(name: "Helvetica", size: 17.0)
            self.lblStored1.textColor = UIColor.white
        } else if self.rollTracker == 1 {
            self.lblStored2.text = self.txtScript.text
            self.lblStored2.font = UIFont(name: "Helvetica", size: 17.0)
            self.lblStored2.textColor = UIColor.white
        } else if self.rollTracker == 2 {
            self.lblStored3.text = self.txtScript.text
            self.lblStored3.font = UIFont(name: "Helvetica", size: 17.0)
            self.lblStored3.textColor = UIColor.white
        }
    }
    /*
    func showPaidVersionAlert() {
        let upgradeAlert = UIAlertController(title: LocalizedString.adsFreeAlert.localized,
                                              message: LocalizedString.removeAds.localized,
                                              preferredStyle: UIAlertController.Style.alert)
        
        let noThanksAction = UIAlertAction(title: LocalizedString.noThanksAction.localized,
                                           style: UIAlertAction.Style.default,
                                     handler: nil)
        
        
        
        let upgradeAction = UIAlertAction(title: LocalizedString.upgradeAction.localized,
                                          style: UIAlertAction.Style.default,
                                     handler: {(action) -> Void in
                                        //action here
                                        
                                        /*
                                        if let url = NSURL(string:"itms-apps://itunes.apple.com/app/idYOUR_APP_ID") {
                                            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                                        }
                                        
                                        */
                                       
        })
        
        
        
        upgradeAlert.addAction(upgradeAction)
        upgradeAlert.addAction(noThanksAction)
        
        self.present(upgradeAlert, animated:true, completion: nil)
        
    }//Func
    */
    
    func showKiosk(){
            let myKiosk = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpCounter") as! KioskViewController
        //Hey "myKiosk"(Boss) you have a variable called "extrasDelegate"which is your "intern" and I(self) want to be your "Intern"(legatos)
        
        //PROTOCOLS---------------------------------
       // myKiosk.extrasDelegate = self
       // myKiosk.unlimitedDelegate = self
        
            self.addChild(myKiosk)
            myKiosk.view.frame = self.view.frame
            self.view.addSubview(myKiosk.view)
            myKiosk.didMove(toParent: self)
    }
    
    
    
    
    
    func showLogo(){
        let myLogo = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpLogo") as! MyLogoViewController
        
        //Hey "myKiosk"(Boss) you have a variable called "extrasDelegate"which is your "intern" and I(self) want to be your "Intern"(legatos)
        
        //PROTOCOLS---------------------------------
       // myKiosk.extrasDelegate = self
       // myKiosk.unlimitedDelegate = self
        
            self.addChild(myLogo)
            myLogo.view.frame = self.view.frame
            self.view.addSubview(myLogo.view)
            myLogo.didMove(toParent: self)
    }
    
    
    func loadFreeOrPaid(){
        let isPaid = KeychainWrapper.standard.bool(forKey: myProductList.appPro ) ?? false
        if isPaid {
                   self.isPaidVersionOn = true
               }
    }//Func
    
    
    //importADBanner
    func configureView(){
        self.btnStore.setTitle(LocalizedString.sa1ve.localized, for: .normal)
        if isPaidVersionOn {
            self.leftBarButton.title = "info"
            self.bannerHeight.constant = 0
        } else {
            self.leftBarButton.title = "Ads free"
            self.bannerHeight.constant = 50
        }
    }
    
    
    
    
    
    
    
    //MARK: TextFields
    //hiding the keyboard=========================================================
      
      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          self.view.endEditing(true)
          txtScript.resignFirstResponder()
          
          return true
      }
      
      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.view.endEditing(true)
          
      }
    
    
}//class



   //MARK: - Universal, Standars & Enumerations


extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "*&*\(self)*&*", comment: "")
    }
}



enum LocalizedString: String {
    case question1 = "question1"
    case question2 = "question2"
    case question3 = "question3"
    case attentionAlert = "Attention!!!"
    case dateOrderAlert = "dateOrderAlert"
    case okInAlert = "okInAlert"
    case emptyFieldAlert = "emptyFieldAlert"
    case advantageKiosk1a = "advantageKiosk1a"
    case advantageKiosk1b = "advantageKiosk1b"
    case advantageKiosk2a = "advantageKiosk2a"
    case advantageKiosk2b = "advantageKiosk2b"
    case contactUs = "contactUs"
    case rateThisApp = "rateThisApp"
    case upgrade = "upgrade"
    case restorePurchase = "restorePurchase"
    case cancelPopUp = "cancelPopUp"
    case connectionRequired = "connectionRequired"
    case onlyFor = "onlyFor"
    case waitThePrices = "waitThePrices"
    case logoLine1 = "logoLine1"
    case logoLine2 = "logoLine2"
    case logoLine3 = "logoLine3"
    case logoLine4 = "logoLine4"
    case sa1ve = "sa1ve"
    case segTit0 = "segTit0"
    case segTit1 = "segTit1"
    case segTit2 = "segTit2"
    case segTit3 = "segTit3"
    case segTit4 = "segTit4"
    case segTit5 = "segTit5"
    
    
    
    
    
    
    
    
    
    /*
    case removeAds = "removeAds"
    case adsFreeAlert = "adsFreeAlert"
    case noThanksAction = "noThanksAction"
    case upgradeAction = "upgradeAction"
    */
    
    var localized: String {
        return self.rawValue.localized(tableName: "Localizable")
    }
}//enum


enum icons: String {
    case icon1 = "icons8-red-circle-100"
    case icon2 = "icons8-green-circle-100"
    case icon3 = "icons8-horizontal-line-90"
   
}//enum

enum kinds: String {
    case kind1 = "Paravasi"
    case kind2 = "Lexi"
    case kind3 = "Oligoria"
   
}//enum



extension String {
    /*
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }*/
    
    func locationize(localID: String)-> String{
        return String(localID.suffix(2))
    }
    
    func regionize() -> String {
        var stringOfLocaleDate: String
    switch  NSLocale.current.identifier.suffix(2) {
    case "US": stringOfLocaleDate = "MM/dd/yyyy, HH:mm"
    case "EU": stringOfLocaleDate = "dd/MM/yyyy, HH:mm"
    case "JP": stringOfLocaleDate = "dd/MM/yyyy, HH:mm"
    default: stringOfLocaleDate = "dd/MM/yyyy, HH:mm"
    }
    return stringOfLocaleDate
    }
    
    func regionizeWithoutHours() -> String {
        var stringOfHourLess: String
        switch  NSLocale.current.identifier.suffix(2) {
       
        case "US": stringOfHourLess = "MM/dd/yyyy"
        case "EU": stringOfHourLess = "dd/MM/yyyy"
        case "JP": stringOfHourLess = "dd/MM/yyyy"
        default: stringOfHourLess = "dd/MM/yyyy"
        }
        return stringOfHourLess
    }
    
}//ext

//importADBanner
extension ViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("received add")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
       print(error)
    }
    
}//ext


//importADinter
extension ViewController: GADInterstitialDelegate {
    func playInter() {
        if interstitial != nil {
            interstitial!.present(fromRootViewController: self)
          } else {
            print("Ad wasn't ready")
          }
    }
    
    func createAd() -> GADInterstitial {
        let ad = GADInterstitial(adUnitID: Constants.interUnitID)
        ad.delegate = self
        ad.load(GADRequest())
        return ad
    }
    
    func checkAndPlayAd(){
        if interstitial?.isReady == true {
            interstitial?.present(fromRootViewController:   self)
        }
    }
    
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAd()
    }
    
    
    
    
    /*
    /// Tells the delegate that the ad failed to present full screen content.
      func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
      }

      /// Tells the delegate that the ad presented full screen content.
      func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
      }

      /// Tells the delegate that the ad dismissed full screen content.
      func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
      }*/
}
