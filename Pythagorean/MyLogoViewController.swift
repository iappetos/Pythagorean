//
//  MyLogoViewController.swift
//  Pythagorean
//
//  Created by Ioannis on 31/3/21.
//

import UIKit
import MessageUI

class MyLogoViewController: UIViewController {

    let storeManager = IAPManager()
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
   
    
    @IBOutlet weak var viewOfLogo: UIView!
    
    
    @IBOutlet weak var internalLogoView: UIView!
    @IBOutlet weak var btnContactUs: UIButton!
    @IBOutlet weak var btnRateThisApp: UIButton!
    //@IBOutlet weak var btnUpgrade: UIButton!
    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    @IBAction func contactUs(_ sender: Any) {
        composeMail()
        
    }
    
    
    @IBAction func rateUp(_ sender: Any) {
        if let url = NSURL(string: stringOfNSURL    /*"itms-apps://itunes.apple.com/app/id1490575678"*/) {
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    
    
    @IBAction func restore(_ sender: Any) {
        storeManager.restoreCompletedTransactions()
        removeAnimate()
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        removeAnimate()
    }
    
    
    
    
    func configureView(){
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.viewOfLogo.layer.cornerRadius = 10
        self.internalLogoView.layer.cornerRadius = 10
        
        
        
        
        //self.lblAdvantages1.adjustsFontSizeToFitWidth = false
        //self.lblAdvantages1.sizeToFit()
        //self.lblPrizel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.lbl1.lineBreakMode = .byWordWrapping // notice the 'b' instead of 'B'
        self.lbl1.numberOfLines = 0
        
        //Layout adjustments----------->>>>>>>>>>>
        let  widthOfIOSDevice = UIScreen.main.bounds.size.width
        self.lbl1.preferredMaxLayoutWidth = widthOfIOSDevice - 70
        self.lbl2.preferredMaxLayoutWidth = widthOfIOSDevice - 70
        self.lbl3.preferredMaxLayoutWidth = widthOfIOSDevice - 70
        self.lbl4.preferredMaxLayoutWidth = widthOfIOSDevice - 70
        
        self.lbl3.font = UIFont(name: "Akkadian256", size: 36)
        
        //self.lbl3.font = UIFont(name: Constants.akkadian , size: 36.0)
        
        
        
        
        btnContactUs.titleLabel?.numberOfLines = 0
        btnContactUs.titleLabel?.adjustsFontSizeToFitWidth = true
        btnContactUs.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        btnRateThisApp.titleLabel?.numberOfLines = 0
        btnRateThisApp.titleLabel?.adjustsFontSizeToFitWidth = true
        btnRateThisApp.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        /*
        btnUpgrade.titleLabel?.numberOfLines = 0
        btnUpgrade.titleLabel?.adjustsFontSizeToFitWidth = true
        btnUpgrade.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        */
        
        btnRestore.titleLabel?.numberOfLines = 0
        btnRestore.titleLabel?.adjustsFontSizeToFitWidth = true
        btnRestore.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        btnCancel.titleLabel?.numberOfLines = 0
        btnCancel.titleLabel?.adjustsFontSizeToFitWidth = true
        btnCancel.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        //Layout adjustments-----------<<<<<<<<<<<<<<<
        
        
        self.lbl1.text = LocalizedString.logoLine1.localized
        self.lbl2.text = LocalizedString.logoLine2.localized
        self.lbl3.text = LocalizedString.logoLine3.localized
        self.lbl4.text = LocalizedString.logoLine4.localized
        
        self.btnContactUs.setTitle(LocalizedString.contactUs.localized, for: .normal)
        self.btnRateThisApp.setTitle(LocalizedString.rateThisApp.localized, for: .normal)
       // self.btnUpgrade.setTitle(LocalizedString.upgrade.localized, for: .normal)
        self.btnRestore.setTitle(LocalizedString.restorePurchase.localized, for: .normal)
        self.btnCancel.setTitle(LocalizedString.cancelPopUp.localized, for: .normal)
       // self.lblPrize.text = LocalizedString.connectionRequired.localized
        
        
      
       
    }
     
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension MyLogoViewController   {
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




extension MyLogoViewController: MFMailComposeViewControllerDelegate {
    
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
