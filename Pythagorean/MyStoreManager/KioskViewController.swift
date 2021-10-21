//
//  KioskViewController.swift
//  Pythagorean
//
//  Created by Ioannis on 29/3/21.
//
import Foundation
import UIKit
import StoreKit
import MessageUI
import SwiftKeychainWrapper

var stringOfNSURL = "itms-apps://itunes.apple.com/app/id1560613937"


//PROTOCOLS---------------------------------
/*
protocol ExtraTrialsDelegate {
    func didSelectExtraTrials(units: Int)
}


protocol UnlimitedTrialsDelegate {
    func didSelectUnlimited(isUnlocked: Bool)
}
*/


class KioskViewController: UIViewController {
    
    //PROTOCOLS---------------------------------
    /*
    var extrasDelegate: ExtraTrialsDelegate!
    var unlimitedDelegate: UnlimitedTrialsDelegate!
    */
    
    //initializing the IAPManager I start collecting products from the store
    let storeManager = IAPManager()
    var myProductOnShelf: SKProduct?
    
    var myProductTitle = String()
    var myProductDescripton = String()
    var myProductPrice = String()
    
    var listOfProducts = [SKProduct]()
    //2nd product
    var myExtraTrialsProduct: SKProduct?
    
    var myExtraTrialsTitle = String()
    var myExtraTrialsDescripton = String()
    var myExtraTrialsPrice = String()
    
    
    
    
    //Prizes Of Different products
    var prizeTaken: String = " "
    var prizeTakenForExtraTrials = String()
    let noConnection = "connection required!!!"
    
   
    
    @IBOutlet weak var viewOfUpgrade: UIView!
    @IBOutlet weak var lblPrize: UILabel!
    @IBOutlet weak var viewInternal: UIView!
    @IBOutlet weak var lblAdvantages1: UILabel!
    @IBOutlet weak var lblAdvantages1b: UILabel!
    @IBOutlet weak var lblAdvantages2a: UILabel!
    @IBOutlet weak var lblAdvantages2: UILabel!
    
    @IBOutlet weak var btnContactUs: UIButton!
    @IBOutlet weak var btnRateThisApp: UIButton!
    @IBOutlet weak var btnUpgrade: UIButton!
    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeManager.delegate = self
        
        configureView()
        showAnimate()
    }
    
    func configureView(){
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.viewOfUpgrade.layer.cornerRadius = 10
        self.viewInternal.layer.cornerRadius = 10
        
        //self.lblAdvantages1.adjustsFontSizeToFitWidth = false
        //self.lblAdvantages1.sizeToFit()
        //self.lblPrizel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.lblAdvantages1.lineBreakMode = .byWordWrapping // notice the 'b' instead of 'B'
        self.lblAdvantages1.numberOfLines = 0
        
        //Layout adjustments----------->>>>>>>>>>>
        let  widthOfIOSDevice = UIScreen.main.bounds.size.width
        self.lblAdvantages1.preferredMaxLayoutWidth = widthOfIOSDevice - 70
        self.lblAdvantages1b.preferredMaxLayoutWidth = widthOfIOSDevice - 70
        self.lblAdvantages2a.preferredMaxLayoutWidth = widthOfIOSDevice - 70
        self.lblAdvantages2.preferredMaxLayoutWidth = widthOfIOSDevice - 70
        
    
        self.lblAdvantages2a.font = UIFont(name: "Akkadian256", size: 36)
            
            
        btnContactUs.titleLabel?.numberOfLines = 0
        btnContactUs.titleLabel?.adjustsFontSizeToFitWidth = true
        btnContactUs.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
       // btnContactUs.setTitle(LocalizedString.contactUs.localized, for: .normal)
        
        btnRateThisApp.titleLabel?.numberOfLines = 0
        btnRateThisApp.titleLabel?.adjustsFontSizeToFitWidth = true
        btnRateThisApp.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
       // btnRateThisApp.setTitle(LocalizedString.rateThisApp.localized, for: .normal)
        
        btnUpgrade.titleLabel?.numberOfLines = 0
        btnUpgrade.titleLabel?.adjustsFontSizeToFitWidth = true
        btnUpgrade.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
       // btnUpgrade.setTitle(LocalizedString.upgrade.localized, for: .normal)
        
        btnRestore.titleLabel?.numberOfLines = 0
        btnRestore.titleLabel?.adjustsFontSizeToFitWidth = true
        btnRestore.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        //btnRestore.setTitle(LocalizedString.restorePurchase.localized, for: .normal)
        
        btnCancel.titleLabel?.numberOfLines = 0
        btnCancel.titleLabel?.adjustsFontSizeToFitWidth = true
        btnCancel.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
       // btnCancel.setTitle(LocalizedString.cancelPopUp.localized, for: .normal)
        //Layout adjustments-----------<<<<<<<<<<<<<<<
        
        
        self.lblAdvantages1.text = LocalizedString.advantageKiosk1a.localized
        self.lblAdvantages1b.text = LocalizedString.advantageKiosk1b.localized
        self.lblAdvantages2a.text = LocalizedString.advantageKiosk2a.localized
        self.lblAdvantages2.text = LocalizedString.advantageKiosk2b.localized
        
        self.btnContactUs.setTitle(LocalizedString.contactUs.localized, for: .normal)
        self.btnRateThisApp.setTitle(LocalizedString.rateThisApp.localized, for: .normal)
        self.btnUpgrade.setTitle(LocalizedString.upgrade.localized, for: .normal)
        self.btnRestore.setTitle(LocalizedString.restorePurchase.localized, for: .normal)
        self.btnCancel.setTitle(LocalizedString.cancelPopUp.localized, for: .normal)
        self.lblPrize.text = LocalizedString.connectionRequired.localized
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
        self.showThePrizesOnTheLabels()
            
        })
      
       
    }
     
    
    
    
    @IBAction func rateApp(_ sender: Any) {
        if let url = NSURL(string: stringOfNSURL    /*"itms-apps://itunes.apple.com/app/id1490575678"*/) {
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                        
    }
    }//F
    
    
    
    
    
   
    
    @IBAction func contactUs(_ sender: Any) {
        composeMail()
    }
    
   
    
    
    @IBAction func cancel(_ sender: Any) {
        removeAnimate()
    }
    
    
    
    @IBAction func upgradeNow(_ sender: Any) {
        if self.lblPrize.text == LocalizedString.connectionRequired.localized || self.lblPrize.text == " " {
            showConnectionAlert()
        } else {
            //PROTOCOLS---------------------------------
            //In order the gameView labels to be informed immediatelly
            //unlimitedDelegate.didSelectUnlimited(isUnlocked: true)
            
            storeManager.makePaymentForProduct(myProduct: myProductOnShelf!)
            removeAnimate()
        }
    }
    
    
    
    
    @IBAction func restore(_ sender: Any) {
        storeManager.restoreCompletedTransactions()
        removeAnimate()
    }
    
    
    
    
    
    
    
    
    
  
    
    
    
    
    
    
 /* ιν ορδε το Restart your application ςηεν restored
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
          nonConsumablePurchaseMade7 = true
          UserDefaults.standard.set(nonConsumablePurchaseMade7, forKey: "nonConsumablePurchaseMade7")
    
          UIAlertView(title: "DeriveesPRO",
                      message: "You've successfully restored your purchase! Restart your application!",
                      delegate: nil, cancelButtonTitle: "OK").show()
      }
    
  */
    
    
    
    
   
}//class



extension KioskViewController: StoreManagerDelegate {
   
    
    
    
    func updateWithProducts(products: [SKProduct]) {
        self.myProductOnShelf = products[0]
        //self.myExtraTrialsProduct = products[0]
        
        self.prizeTaken = LocalizedString.onlyFor.localized + self.myProductOnShelf!.localizedPrice()
       // self.prizeTakenForExtraTrials = "Play 10 extra times for " + //self.myExtraTrialsProduct!.localizedPrice()
    }
    
    func showThePrizesOnTheLabels(){
        self.lblPrize.text = self.prizeTaken
       // self.lblPrizeOfExtraTrials.text = self.prizeTakenForExtraTrials
    }
    
    
}



extension KioskViewController: MFMailComposeViewControllerDelegate {
    
    func composeMail(){
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["info@iappetos.com"])
            mail.setSubject("Comments about Pythagorean")
            mail.setMessageBody("<p>Hi,</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            print("Mail services are not available")
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
           controller.dismiss(animated: true)
       }
    
    
    
}//ext




extension KioskViewController   {
     //Effects
    func showAnimate(){
           self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
           self.view.alpha = 0.0;
           UIView.animate(withDuration: 0.25, animations: {
               self.view.alpha = 1.0
               self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
           });
       }//F
       
       func removeAnimate(){
           UIView.animate(withDuration: 0.25, animations: {
               self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
               self.view.alpha = 0.0;
           }, completion:{(finished : Bool)  in
               if (finished)
               {
                  self.view.removeFromSuperview()
               
               }
           });
       }//F
    
    
     //Alerts
    func showConnectionAlert(){
        let noCnnectionAlert = UIAlertController(title: LocalizedString.attentionAlert.localized,
                                             message: LocalizedString.waitThePrices.localized ,
                                    preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: LocalizedString.okInAlert.localized,
                                 style: UIAlertAction.Style.default,
                                 handler: nil)
    
    noCnnectionAlert.addAction(okAction)
    
    self.present(noCnnectionAlert, animated:true, completion: nil)
    

}

}//ext
