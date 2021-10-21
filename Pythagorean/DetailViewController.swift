//
//  DetailViewController.swift
//  Pythagorean
//
//  Created by Ioannis on 22/3/21.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var receivedAnswer: String = ""
    var receivedDate = Date()
    var receivedSegment: Int = 0
    var arrayOfWilling = [Answer]()
  
    @IBOutlet weak var txtInUse: UITextField!
    @IBOutlet weak var pickerOfDateInUse: UIDatePicker!
    @IBOutlet weak var btnKind: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnCancel.setTitle(LocalizedString.cancelPopUp.localized, for: .normal)
        self.btnSave.setTitle(LocalizedString.sa1ve.localized, for: .normal)
        
        
        
        self.pickerOfDateInUse.date = receivedDate
        self.txtInUse.text = receivedAnswer
        if receivedSegment == 0 {
            if let filePath = Bundle.main.path(forResource: icons.icon1.rawValue, ofType:     "png"), let image = UIImage(contentsOfFile: filePath) {self.btnKind.setImage(image, for: .normal)}
           
            //self.btnKind.backgroundColor = UIColor.red
            self.btnKind.tintColor = UIColor.red
            
        } else if receivedSegment == 1 {
            
            if let filePath = Bundle.main.path(forResource: icons.icon2.rawValue, ofType:     "png"), let image = UIImage(contentsOfFile: filePath) {self.btnKind.setImage(image, for: .normal)}
            
           // self.btnKind.backgroundColor = UIColor.green
            self.btnKind.tintColor = UIColor.green
            
        } else if receivedSegment == 2 {
            
            if let filePath = Bundle.main.path(forResource: icons.icon3.rawValue, ofType:     "png"), let image = UIImage(contentsOfFile: filePath) {self.btnKind.setImage(image, for: .normal)}
           // self.btnKind.backgroundColor = UIColor.black
            self.btnKind.tintColor = UIColor.white
        }
        
    }//viewDidLoad
    

    
    @IBAction func changeKind(_ sender: Any) {
        if receivedSegment == 0 {
            if let filePath = Bundle.main.path(forResource: icons.icon2.rawValue, ofType:     "png"), let image = UIImage(contentsOfFile: filePath) {self.btnKind.setImage(image, for: .normal)}
            //self.btnKind.backgroundColor = UIColor.green
            self.btnKind.tintColor = UIColor.green
           receivedSegment += 1
        } else if receivedSegment == 1 {
            
            if let filePath = Bundle.main.path(forResource: icons.icon3.rawValue, ofType:     "png"), let image = UIImage(contentsOfFile: filePath) {self.btnKind.setImage(image, for: .normal)}
            //self.btnKind.backgroundColor = UIColor.black
            self.btnKind.tintColor = UIColor.white
            receivedSegment += 1
        } else  {
            if let filePath = Bundle.main.path(forResource: icons.icon1.rawValue, ofType:     "png"), let image = UIImage(contentsOfFile: filePath) {self.btnKind.setImage(image, for: .normal)}
            //self.btnKind.backgroundColor = UIColor.red
            self.btnKind.tintColor = UIColor.red
            receivedSegment = 0
        }
        
    }
    
    
    
    @IBAction func cancelAndGoBack(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToList", sender: self)
    }
    
    
    @IBAction func saveAndGoBack(_ sender: Any) {
        if !(self.txtInUse.text?.isEmpty)! {
            deleteThePreviousCoreItem()
            saveNewCoreItem()
            
        } else {
            emptyFieldAlert()
        }
        self.performSegue(withIdentifier: "unwindToList", sender: self)
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



extension DetailViewController {
    
    
    func deleteThePreviousCoreItem(){
        
        let dateLoaded = self.receivedDate as NSDate
        let noteLoaded = self.receivedAnswer
        fetchOneSpecificExpense(date: dateLoaded as Date, note: noteLoaded)
            
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        if let itemToDelete = arrayOfWilling.first {managedContext.delete(itemToDelete)}
    
        
            do {
                try managedContext.save()
                print("TABLEVIEW-EDIT: saved!")
            } catch {
                print("TABLEVIEW-EDIT: Not saved!")
            }
            
            
    }//Func
    
    func fetchOneSpecificExpense( date: Date, note: String){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let myRequestedAnswer = NSFetchRequest<NSFetchRequestResult>(entityName: "Answer")
        myRequestedAnswer.fetchLimit = 1
        
      //  let specificPredicate = NSCompoundPredicate(type: .and, subpredicates: [NSPredicate(format: "size = %@", size as CVarArg), NSPredicate(format: "cash = %@", cash as CVarArg), NSPredicate(format: "date = %@", date as CVarArg), NSPredicate(format: "kind = %@", kind as CVarArg), NSPredicate(format: "note = %@", note as CVarArg)])
        
        let specificPredicate = NSCompoundPredicate(type: .and, subpredicates: [NSPredicate(format: "date = %@", date as CVarArg), NSPredicate(format: "textOfAnswer = %@", note as CVarArg)])
        
        
        
        
        myRequestedAnswer.predicate = specificPredicate
        
        do {
            self.arrayOfWilling = try (managedContext.fetch(myRequestedAnswer) as? [Answer])!
          //  print("The object to be deleted : \(String(describing: self.arrayOfWilling[0].note))")
        } catch {
            print("Unable to fetch data:", error.localizedDescription)
        }
        
        
    }//Func
    
    
    func saveNewCoreItem() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let myAnswer = Answer(context: managedContext)
    
        
        if receivedSegment == 0 {
            
            myAnswer.kind = kinds.kind1.rawValue
            myAnswer.textOfAnswer =  self.txtInUse.text
            myAnswer.date = self.pickerOfDateInUse.date as Date
            
        }  else if receivedSegment == 1 {
            
            myAnswer.kind = kinds.kind2.rawValue
            myAnswer.textOfAnswer =  self.txtInUse.text
            myAnswer.date = self.pickerOfDateInUse.date as Date
            
            
        }  else {
            myAnswer.kind = kinds.kind3.rawValue
            myAnswer.textOfAnswer =  self.txtInUse.text
            myAnswer.date = self.pickerOfDateInUse.date as Date
            
        }
        do {
            try managedContext.save()
            print("Expense saved with note filled")
            
        } catch {
            print("Failed to save with note filled", error.localizedDescription)
            
        }
      
        
    }//func
    
    
}//class



// MARK: - Alerts
extension DetailViewController {
    func   emptyFieldAlert(){
            let emptyFieldAlert = UIAlertController(title: LocalizedString.attentionAlert.localized,
                                                     message: LocalizedString.dateOrderAlert.localized,
                                                     preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: LocalizedString.okInAlert.localized,
                                         style: UIAlertAction.Style.default,
                                         handler: nil)
            
            emptyFieldAlert.addAction(okAction)
            
            self.present(emptyFieldAlert, animated:true, completion: nil)
    
    }
   
    
}//ext
