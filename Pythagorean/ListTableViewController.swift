//
//  ListTableViewController.swift
//  Pythagorean
//
//  Created by Ioannis on 12/3/21.
//

import UIKit
import CoreData
import SwiftKeychainWrapper
import GoogleMobileAds

class ListTableViewController: UITableViewController {

    // MARK: - Variables
    var arrayOfAnswers = [Answer]()
    var arrayOfFilteredAnswers = [Answer]()
    var nbrOf1: Double = 0
    var nbrOf2: Double = 0
    var nbrOf3: Double = 0
    var stringOfDate: String = "dd/MM/yyyy, HH:mm"
    var isPaidVersionOn: Bool = false
    //==========================Effort to have the right date on Report==================================
    //=========because if load is not pressed the date label shows wrong dates on report=================
    var selectedDStartingDate = Date()
    var selectedEndingDate = Date()
    
    //=====================================================================================================
    
    //Search Related
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    var search = UISearchController(searchResultsController: nil)
    var searchActive: Bool = false
    var isSearching: Bool = false
    var filteredTable = [Answer]()
    var textThatWasSearched: String?
    
    //importADinter
    private var interstitial: GADInterstitial?
    var boolInterstitialTracker: Bool = false
    var intInterstitialCounter: Int = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var segmentOfKind: UISegmentedControl!
    @IBOutlet weak var segmentOfPeriod: UISegmentedControl!
    @IBOutlet weak var pickerOfStartingDate: UIDatePicker!
    @IBOutlet weak var pickerOfEndingDate: UIDatePicker!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    //importADBanner
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    
    
    
    // MARK: - ViewDidLoad & Actions
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pythagorean"
        self.segmentOfPeriod.setTitle(LocalizedString.segTit0.localized, forSegmentAt: 0)
        self.segmentOfPeriod.setTitle(LocalizedString.segTit1.localized, forSegmentAt: 1)
        self.segmentOfPeriod.setTitle(LocalizedString.segTit2.localized, forSegmentAt: 2)
        self.segmentOfPeriod.setTitle(LocalizedString.segTit3.localized, forSegmentAt: 3)
        self.segmentOfPeriod.setTitle(LocalizedString.segTit4.localized, forSegmentAt: 4)
        self.segmentOfPeriod.setTitle(LocalizedString.segTit5.localized, forSegmentAt: 5)
        
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        
        //ClearDatabase
        //deleteAllData("Answer")
      
        
        fetchData {(done) in
            if done {
                if arrayOfAnswers.count > 0{
                    print("There are stored items")
                }
                
            } else {
                print("data not Fetched")
            }
            
            
        }//Fetch
        
        importSearchBar()
        if isFiltering(){
            sort(myArray: self.arrayOfFilteredAnswers)
        } else {
            sort(myArray: self.arrayOfAnswers)
        }
        
        setStartingPickersDateToMonthsFirstDay()
        if self.arrayOfAnswers.count > 0{
            arrangeLabels(forArray: self.arrayOfAnswers)
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
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        //super.viewDidAppear(animated)
        tableView.reloadData()
        
        if isFiltering(){
            print("Here I am in viewDidAppeear")
            showListOfFilteredExpenses()
            tableView.reloadData()
        } else {
            load()
            tableView.reloadData()
        }
        
        
        
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        //super.viewDidAppear(animated)
        tableView.reloadData()
        
        if isFiltering(){
            print("Here I am in viewWillAppeear")
            showListOfFilteredExpenses()
            tableView.reloadData()
        } else {
            load()
            tableView.reloadData()
        }
    }
    
    
    
    
    
    
    
    

    @IBAction func showDifferentKindSegment(_ sender: Any) {
        if pickerOfStartingDate.date <= pickerOfEndingDate.date {
            load()
        }
    }//action
    
    
    @IBAction func showOnlyFirst(_ sender: Any) {
        segmentOfKind.selectedSegmentIndex = 1
        load()
    }
    
    
    
    @IBAction func showOnlySecond(_ sender: Any) {
        segmentOfKind.selectedSegmentIndex = 2
        load()
    }
    
    
    
    @IBAction func showOnlyThird(_ sender: Any) {
        segmentOfKind.selectedSegmentIndex = 3
        load()
    }
    
    
    
    
    @IBAction func changeStartingDate(_ sender: Any) {
       refetchForPicker()
    }
    
    @IBAction func changeEndingDate(_ sender: Any) {
        refetchForPicker()
    }//Action
    
    //importADinter
    @IBAction func showDifferentTimeSegment(_ sender: Any) {
        setPickersDateAccordingToTheSelectedPeriodSegment()
        load()
    }//Action
    
    @IBAction func unwindToList(segue: UIStoryboardSegue){
        if segue.identifier == "unwindToList" {
            
            if isFiltering(){
                print("Here I am unwinded")
               /*
                print("how many items?: \(String(describing: arrayOfFilteredAnswers.count))")
                let date1 = self.pickerOfStartingDate.date
                let date2 = self.pickerOfEndingDate.date
                let searchText = self.searchController.searchBar.searchTextField.text
                print("searchText: \(String(describing: searchText)))")
                fetchByDateAndSearchedText(from: date1, until: date2, withText: searchText!)
                
                */
                
                
                //self.tableView.reloadData()
               // arrangeLabels(forArray: self.arrayOfFilteredAnswers)
               
               self.searchController.searchBar.searchTextField.text = "" // self.textThatWasSearched
             
                
                
                load()
                self.tableView.reloadData()
            } else {
                print("Here I am unwinded Not Filtering")
                load()
                self.tableView.reloadData()
            }
            
               
          }
    }
   

    
    // MARK: - Navigation
     
     
    
     

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailView = segue.destination as! DetailViewController
        
        
        let myIndexPath = self.tableView.indexPathForSelectedRow!
        let row = myIndexPath.row
        
        if isFiltering() {
            detailView.receivedAnswer = arrayOfFilteredAnswers[row].textOfAnswer!
            detailView.receivedDate = arrayOfFilteredAnswers[row].date! as Date
           
            
            if arrayOfFilteredAnswers[row].kind! == kinds.kind1.rawValue {
                detailView.receivedSegment = 0
            } else if arrayOfFilteredAnswers[row].kind! == kinds.kind2.rawValue  {
                detailView.receivedSegment = 1
            } else {
                detailView.receivedSegment = 2
            }
        } else {
            detailView.receivedAnswer = arrayOfAnswers[row].textOfAnswer!
            detailView.receivedDate = arrayOfAnswers[row].date! as Date
           
            
            if arrayOfAnswers[row].kind! == kinds.kind1.rawValue {
                detailView.receivedSegment = 0
            } else if arrayOfAnswers[row].kind! == kinds.kind2.rawValue  {
                detailView.receivedSegment = 1
            } else {
                detailView.receivedSegment = 2
            }
        }
       
        
    }


}//CLASS





//MARK: - Table view data source


extension ListTableViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            return self.arrayOfFilteredAnswers.count
        } else {
            return self.arrayOfAnswers.count
        }
       
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        if isFiltering(){
            
            // Configure the cell...
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell
            let myAnswer  = self.arrayOfFilteredAnswers[indexPath.row]
            
            
            //pass the data
            
            //1.script
            cell.lblInCell.text = myAnswer.textOfAnswer
            
            //2.date
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = stringOfDate.regionizeWithoutHours()
            cell.lblDateInCell.text =  dateFormatter.string(from: myAnswer.date! as Date)
            
            //3.image
            if myAnswer.kind == kinds.kind1.rawValue {
                if let filePath = Bundle.main.path(forResource: icons.icon1.rawValue , ofType:     "png"), let image = UIImage(contentsOfFile: filePath) {    cell.imgInCell.contentMode = .scaleAspectFit
                    cell.imgInCell.image = image
                }
            } else if myAnswer.kind == kinds.kind2.rawValue {
                if let filePath = Bundle.main.path(forResource: icons.icon2.rawValue , ofType:     "png"), let image = UIImage(contentsOfFile: filePath) {    cell.imgInCell.contentMode = .scaleAspectFit
                    cell.imgInCell.image = image
                }
            } else if myAnswer.kind == kinds.kind3.rawValue {
                if let filePath = Bundle.main.path(forResource: icons.icon3.rawValue , ofType:     "png"), let image = UIImage(contentsOfFile: filePath) {    cell.imgInCell.contentMode = .scaleAspectFit
                    cell.imgInCell.image = image
                }
            }
            
            
            
            
            
            return cell
        } else {

        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell
        let myAnswer  = self.arrayOfAnswers[indexPath.row]
        
        
        //pass the data
        
        //1.script
        cell.lblInCell.text = myAnswer.textOfAnswer
        
        //2.date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = stringOfDate.regionizeWithoutHours()
        cell.lblDateInCell.text =  dateFormatter.string(from: myAnswer.date! as Date)
        
        //3.image
        if myAnswer.kind == kinds.kind1.rawValue {
            if let filePath = Bundle.main.path(forResource: icons.icon1.rawValue , ofType:     "png"), let image = UIImage(contentsOfFile: filePath) {    cell.imgInCell.contentMode = .scaleAspectFit
                cell.imgInCell.image = image
            }
        } else if myAnswer.kind == kinds.kind2.rawValue {
            if let filePath = Bundle.main.path(forResource: icons.icon2.rawValue , ofType:     "png"), let image = UIImage(contentsOfFile: filePath) {    cell.imgInCell.contentMode = .scaleAspectFit
                cell.imgInCell.image = image
            }
        } else if myAnswer.kind == kinds.kind3.rawValue {
            if let filePath = Bundle.main.path(forResource: icons.icon3.rawValue , ofType:     "png"), let image = UIImage(contentsOfFile: filePath) {    cell.imgInCell.contentMode = .scaleAspectFit
                cell.imgInCell.image = image
            }
        }
        
        
        return cell
            
        }//isNotFiltering
    }//cellForRow
    

    
    
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if isFiltering() {
                // Delete the row from the data source
                self.deleteFilteredData(indexPath: indexPath)
                 fetchyFilteredData()
                 tableView.deleteRows(at: [indexPath], with: .fade)
                 
                //So that the app want crash when the last item of the queue is deleted
                let n = self.arrayOfFilteredAnswers.count
                if indexPath.row == n {
                    //Do nothing
                } else {
                    self.arrayOfFilteredAnswers.remove(at: indexPath.row)
                    
                }
                //So that the app want crash when the last item of the queue is deleted
                load()
                arrangeLabels(forArray: self.arrayOfFilteredAnswers)
                
            } else {
        
            // Delete the row from the data source
            self.deleteData(indexPath: indexPath)
             fetchyData()
             tableView.deleteRows(at: [indexPath], with: .fade)
             
                
            
            //So that the app want crash when the last item of the queue is deleted
            let n = self.arrayOfAnswers.count
            if indexPath.row == n {
                //Do nothing
            } else {
                self.arrayOfAnswers.remove(at: indexPath.row)
                
            }
            //So that the app want crash when the last item of the queue is deleted
             
                
                
                
            load()
            arrangeLabels(forArray: self.arrayOfAnswers)
            
            }//not Searching
            
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering() {
            let searchText = self.searchController.searchBar.text?.lowercased()
            self.textThatWasSearched = searchText
            performSegue(withIdentifier: "detailSegue", sender: arrayOfFilteredAnswers[indexPath.row])
        } else {
            performSegue(withIdentifier: "detailSegue", sender: arrayOfAnswers[indexPath.row])
        }
       
       
    }

    
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
}//ext

// MARK: - Table & Data

extension ListTableViewController {
    
func deleteData(indexPath: IndexPath){
  guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
 managedContext.delete(arrayOfAnswers[indexPath.row])
    do {
        try managedContext.save()
        print(" --------Deleted")
       
    } catch {
        print("Failed to Delete", error.localizedDescription)
      
    }
}

func deleteFilteredData(indexPath: IndexPath){
      guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
     managedContext.delete(arrayOfFilteredAnswers[indexPath.row])
        do {
            try managedContext.save()
            print(" --------Deleted")
           
        } catch {
            print("Failed to Delete", error.localizedDescription)
          
        }
    }
    
    
    
    
    
}//ext





// MARK: - Fetching

extension ListTableViewController {
    
    
    func fetchKind(){
        let date1 = pickerOfStartingDate.date
        let date2 = getPhileasFogDate()
        
        //fetchByDateAndKind(from: date1, until: date2, ofKind: kinds.kind1.rawValue)
        if self.segmentOfKind.selectedSegmentIndex == 0 {
            fetchByDate(from: date1, until: date2)
        } else if self.segmentOfKind.selectedSegmentIndex == 1 {
            fetchByDateAndKind(from: date1, until: date2, ofKind: kinds.kind1.rawValue)
        } else if self.segmentOfKind.selectedSegmentIndex == 2 {
             fetchByDateAndKind(from: date1, until: date2, ofKind: kinds.kind2.rawValue)
        } else {
            fetchByDateAndKind(from: date1, until: date2, ofKind: kinds.kind3.rawValue)
        }
       
    }//Func
    
      
    
    func fetchData(completion: (_ complete:Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Answer")
        
        do{
            arrayOfAnswers = try managedContext.fetch(request) as! [Answer]
            completion(true)
            print("Data fetched, no issues")
        } catch {
            print("Unable to fetch data:", error.localizedDescription)
            completion(false)
        }
    }//Fetch1
    
    
    func fetchFilteredData(completion: (_ complete:Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Answer")
        
        do{
            arrayOfFilteredAnswers = try managedContext.fetch(request) as! [Answer]
            completion(true)
            print("Data fetched, no issues")
        } catch {
            print("Unable to fetch data:", error.localizedDescription)
            completion(false)
        }
    }//Fetch1
    
    
    
    
    
    
    
    
    
    
    func fetchyData(){
        fetchData {(done) in
            if done {
                if arrayOfAnswers.count > 0{
                    print("There are stoered items")
                }
                
            } else {
                print("data not Fetched")
            }
        }
    }
    
    
    func fetchyFilteredData(){
        fetchFilteredData {(done) in
            if done {
                if arrayOfFilteredAnswers.count > 0{
                    print("There are stoered items")
                }
                
            } else {
                print("data not Fetched")
            }
        }
    }
    
    
    
    
    
    
    
    
    func fetchByDate(from: Date, until: Date){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let myRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Answer")
        
        // let predicateFiltered = NSPredicate(format: "note == '\(String(describing: filteredBy))'")
        //let predicateFiltered = NSPredicate(format: "(date >= %@)", from AND "(date <= %@)", until)
        let datePredicate = NSCompoundPredicate(type: .and, subpredicates: [NSPredicate(format: "date >= %@", from as CVarArg), NSPredicate(format: "date =< %@", until as CVarArg)])
        
        
        myRequest.predicate = datePredicate
        
        do {
            self.arrayOfAnswers = try managedContext.fetch(myRequest) as! [Answer]
        } catch {
            print("Unable to fetch data:", error.localizedDescription)
        }
        
    }//Fetch2
    
    func fetchByDateAndKind(from: Date, until: Date, ofKind: String){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let myRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Answer")
        
        // let predicateFiltered = NSPredicate(format: "note == '\(String(describing: filteredBy))'")
        //let predicateFiltered = NSPredicate(format: "(date >= %@)", from AND "(date <= %@)", until)
        let datePredicate = NSCompoundPredicate(type: .and, subpredicates: [NSPredicate(format: "date >= %@", from as CVarArg), NSPredicate(format: "date =< %@", until as CVarArg), NSPredicate(format: "kind = %@", ofKind as CVarArg)])
        
        
        myRequest.predicate = datePredicate
        
        do {
            self.arrayOfAnswers = try managedContext.fetch(myRequest) as! [Answer]
        } catch {
            print("Unable to fetch data:", error.localizedDescription)
        }
        
    }//Fetch3
    
    
    
    
    func fetchByDateAndSearchedText(from: Date, until: Date, withText: String){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let myRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Answer")
        
        // let predicateFiltered = NSPredicate(format: "note == '\(String(describing: filteredBy))'")
        //let predicateFiltered = NSPredicate(format: "(date >= %@)", from AND "(date <= %@)", until)
        let datePredicate = NSCompoundPredicate(type: .and, subpredicates: [NSPredicate(format: "date >= %@", from as CVarArg), NSPredicate(format: "date =< %@", until as CVarArg), NSPredicate(format: "textOfAnswer CONTAINS[cd] %@", withText as CVarArg)])
        
        
        myRequest.predicate = datePredicate
        
        do {
            self.arrayOfFilteredAnswers = try managedContext.fetch(myRequest) as! [Answer]
        } catch {
            print("Unable to fetch data:", error.localizedDescription)
        }
        
    }//Fetch4
    
    
    func fetchByDateKindAndSearchedText(from: Date, until: Date, ofKind: String, withText: String){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let myRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Answer")
        
        // let predicateFiltered = NSPredicate(format: "note == '\(String(describing: filteredBy))'")
        //let predicateFiltered = NSPredicate(format: "(date >= %@)", from AND "(date <= %@)", until)
        let datePredicate = NSCompoundPredicate(type: .and, subpredicates: [NSPredicate(format: "date >= %@", from as CVarArg), NSPredicate(format: "date =< %@", until as CVarArg), NSPredicate(format: "kind = %@", ofKind as CVarArg), NSPredicate(format: "textOfAnswer CONTAINS[cd] %@", withText as CVarArg)]) //$letter
        
        
        myRequest.predicate = datePredicate
        
        do {
            self.arrayOfFilteredAnswers = try managedContext.fetch(myRequest) as! [Answer]
        } catch {
            print("Unable to fetch data:", error.localizedDescription)
        }
        
    }//Fetch5
    
 
    
    //ClearDatabase
    func deleteAllData(_ entity:String) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
 
    
    
    
    
    
}//ext





// MARK: - SearchAbility
extension ListTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func importSearchBar() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = self.searchController
        self.searchController.searchResultsUpdater = self
      // self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        //self.searchController.searchBar.becomeFirstResponder()
        self.definesPresentationContext = true
        
        self.searchController.searchBar.searchTextField.textColor = .white
    }
    

    func updateSearchResults(for searchController: UISearchController) {
       filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            self.filteredTable = self.arrayOfFilteredAnswers.filter( { (e:Answer) -> Bool in
                return (e.textOfAnswer?.lowercased().contains(searchText.lowercased()))!
            })
            self.tableView.reloadData()
            arrangeLabels(forArray: self.arrayOfFilteredAnswers)
        }
        //self.tableView.reloadData()
        //sumFilteredExpenses()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchActive = true
        self.isSearching = true
        print("DID BEGIN")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchActive = false
       self.isSearching = false
         print("DID END")
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
        self.isSearching = false
         print("CANCELED")
    }
    
    func  searchBarIsEmpty() -> Bool {
        //Returns true if the text is Empty or Nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    
    func filterContentForSearchText(_ searchText: String) {
        
        if  searchText == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
            
            
           // self.setPickersDateAccordingToTheSelectedPeriodSegment()
           // self.loadFullOrFilteredExpenses()
            print("nothing to search for")
        } else {
             isSearching = true
            
           self.arrayOfFilteredAnswers = self.arrayOfAnswers.filter( { (e:Answer) -> Bool in
               return (e.textOfAnswer?.lowercased().contains(searchText.lowercased()))!
           })
            self.tableView.reloadData()
            sort(myArray: self.arrayOfFilteredAnswers)
            arrangeLabels(forArray: self.arrayOfFilteredAnswers)
        }
    }
/*
    func loadFullOrFilteredExpenses() {
        
        if pickerOfStartingDate.date <= pickerOfEndingDate.date + 1 {
            
            if isSearching {
                
                fetchFilteredLoadNow()
                sort(myArray: self.arrayOfFilteredAnswers)
                self.tableView.reloadData()
                arrangeLabels(forArray: self.arrayOfFilteredAnswers)
                
            } else {
            
                fetchAndLoadNow()
                sort(myArray: self.arrayOfAnswers)
                self.tableView.reloadData()
                arrangeLabels(forArray: self.arrayOfAnswers)
                
            }
         
        }
    }
    
    */
    
    func fetchFilteredLoadNow(){
        let date1 = pickerOfStartingDate.date
        let date2 = getPhileasFogDate()
        let searchText = self.searchController.searchBar.text?.lowercased()
        self.textThatWasSearched = searchText
        print("TEXTWRRR\( String(describing: self.textThatWasSearched))")
        
        if self.segmentOfKind.selectedSegmentIndex == 0 {
            fetchByDateAndSearchedText(from: date1, until: date2, withText: searchText!)
        } else if self.segmentOfKind.selectedSegmentIndex == 1 {
            fetchByDateKindAndSearchedText(from: date1, until: date2, ofKind: kinds.kind1.rawValue, withText: searchText!)
        } else if self.segmentOfKind.selectedSegmentIndex == 2 {
            fetchByDateKindAndSearchedText(from: date1, until: date2, ofKind: kinds.kind2.rawValue, withText: searchText!)
        } else {
            fetchByDateKindAndSearchedText(from: date1, until: date2, ofKind: kinds.kind3.rawValue, withText: searchText!)
        }
        
        
        
       // self.arrayOfFilteredAnswers = []
        
    }
    
    func fetchAndLoadNow(){
       
        let date1 = pickerOfStartingDate.date
        let date2 = getPhileasFogDate()
        
        if self.segmentOfKind.selectedSegmentIndex == 0 {
            fetchByDate(from: date1, until: date2)
        } else if self.segmentOfKind.selectedSegmentIndex == 1 {
            fetchByDateAndKind(from: date1, until: date2, ofKind: kinds.kind1.rawValue)
        } else if self.segmentOfKind.selectedSegmentIndex == 2 {
             fetchByDateAndKind(from: date1, until: date2, ofKind: kinds.kind1.rawValue)
        } else {
            fetchByDateAndKind(from: date1, until: date2, ofKind: kinds.kind1.rawValue)
        }
        
        
        
        self.arrayOfAnswers = []
        /*
        if coredExpensesArray.count > 0 {
           self.tableOfExpences = coredExpensesArray
        }*/
    }
    
    
    func showListOfFilteredExpenses(){
        let date1 = self.pickerOfStartingDate.date
        let date2 = self.pickerOfEndingDate.date
        let searchText = self.textThatWasSearched
        
        fetchByDateAndSearchedText(from: date1, until: date2, withText: searchText!)
        /*
        if coredExpensesArray.count > 0 {
            self.filteredTable = self.coredExpensesArray
        }*/
        
    }
    
    
    
    
    
    
    
}//ext



// MARK: - Arrays and Calculations

extension ListTableViewController {
    
    func getSumOfAnswers(forKind: String) -> Double{
       // print("this is my array before I sum: \(arrayOfAnswers)")
        

        var mySum: Double = 0
        guard self.arrayOfAnswers.count < 1 else {
        for i in 0...arrayOfAnswers.count - 1  {
            if arrayOfAnswers[i].kind == forKind {
                mySum += 1
            }
        }
        return mySum
        }//guard
        
        return mySum
    }//Func
    
    
    func getSumFromArray(myArray: Array<Answer>, forKind: String) -> Double{
       // print("this is my array before I sum: \(arrayOfAnswers)")
        var mySum: Double = 0
        guard myArray.count < 1 else {
        for i in 0...myArray.count - 1  {
            if myArray[i].kind == forKind {
                mySum += 1
            }
        }
        return mySum
        }//guard
        
        return mySum
    }//Func
    
    
   
    func sort(myArray: Array<Answer>){
        let sortedArray = myArray.sorted(by: {$0.date?.compare($1.date! as Date) == ComparisonResult.orderedDescending })
        
        if isFiltering(){
            self.arrayOfFilteredAnswers = sortedArray
        } else {
            self.arrayOfAnswers = sortedArray
        }
       
    }
    
}//ext


// MARK: - General Functions
extension ListTableViewController {
    
    //importADBanner
    func configureView(){
        
        
        if isPaidVersionOn {
            self.bannerHeight.constant = 0
        } else {
            self.bannerHeight.constant = 50
        }
    }
    
    
   
    
    
    func setStartingPickersDateToMonthsFirstDay(){
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
       // let day = calendar.component(.day, from: date)

        let components: NSDateComponents = NSDateComponents()
        components.year = year
        components.month = month
        components.day = 1
        let defaultDate: NSDate = calendar.date(from: components as DateComponents)! as NSDate
        self.pickerOfStartingDate.date = defaultDate as Date
       //...and show appropriatesegment
        segmentOfPeriod.selectedSegmentIndex = 2
    }
    
    
    func arrangeLabels(forArray: Array<Answer>) {
        
       let a = getSumFromArray(myArray: forArray, forKind: kinds.kind1.rawValue)
       let b = getSumFromArray(myArray: forArray, forKind: kinds.kind2.rawValue)
       let c = getSumFromArray(myArray: forArray, forKind: kinds.kind3.rawValue)
        
        let timesFormatter = NumberFormatter()
        timesFormatter.maximumFractionDigits = 0
       
        self.lbl1.text = timesFormatter.string(from:  NSNumber(value:a))
        self.lbl2.text = timesFormatter.string(from:  NSNumber(value:b))
        self.lbl3.text = timesFormatter.string(from:  NSNumber(value:c))
            
        
    }//Func
    
    func getPhileasFogDate() ->  Date {
        let date = pickerOfEndingDate.date
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        // let weekday = calendar.component(.weekday, from: date)
        
        let components: NSDateComponents = NSDateComponents()
        
        components.year = year
        components.month = month
        components.day = day + 1
        let philleasFogDate: NSDate = calendar.date(from: components as DateComponents)! as NSDate
       
        //let date1 = pickerOfStartingDate.date
        let date2 = philleasFogDate as Date
        
       return date2
    }
    
    func load(){
        if isFiltering() {
            fetchFilteredLoadNow()
            sort(myArray: arrayOfFilteredAnswers)
            self.tableView.reloadData()
            arrangeLabels(forArray: self.arrayOfFilteredAnswers)
            print("this is the filteredArray:\(self.arrayOfFilteredAnswers)")
        } else {
             fetchKind()
             sort(myArray: arrayOfAnswers)
             self.tableView.reloadData()
             arrangeLabels(forArray: self.arrayOfAnswers)
            print("this is the Array:\(self.arrayOfAnswers)")
        }
       
    }
    
    func loadFreeOrPaid(){
        let isPaid = KeychainWrapper.standard.bool(forKey: myProductList.appPro ) ?? false
        if isPaid {
                   self.isPaidVersionOn = true
               }
    }//Func
    
    
    func refetchForPicker(){
        if pickerOfStartingDate.date < pickerOfEndingDate.date {
        load()
        } else {
         dateOrderAlert()
        }
       segmentOfPeriod.selectedSegmentIndex = 5
    }//Func
    
    
    
    func setPickersDateAccordingToTheSelectedPeriodSegment(){
        //starting Date----------------
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let weekday = calendar.component(.weekday, from: date)
        
        
        let components: NSDateComponents = NSDateComponents()
        
        
        
        
        
        if segmentOfPeriod.selectedSegmentIndex == 0 {
            
            components.year = year
            components.month = month
            components.day = day
            let defaultDate: NSDate = calendar.date(from: components as DateComponents)! as NSDate
            
            
            
            self.pickerOfStartingDate.date = defaultDate as Date
            
            components.year = year
            components.month = month
            components.day = day
            let endingDefaultDate: NSDate = calendar.date(from: components as DateComponents)! as NSDate
            
            self.pickerOfEndingDate.date = endingDefaultDate as Date
            
            print ("the ending Date is\(pickerOfEndingDate.date)")
            
            //self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            
            
            
            
            
        } else if segmentOfPeriod.selectedSegmentIndex == 1 {
            
            //From the 1st day of the week
            components.year = year
            
            
            //The fisrt day of the month only monday keeps the same month
            
            if day == 1 {
                
                if weekday == 1 {
                    components.month = month
                    components.day = day - 6
                } else if weekday == 2  {
                    components.month = month
                    components.day = day
                } else if weekday == 3 {
                    components.month = month
                    components.day = day - 1
                } else if weekday == 4 {
                    components.month = month
                    components.day = day - 2
                } else if weekday == 5 {
                    components.month = month
                    components.day = day - 3
                    components.month = month
                } else if weekday == 6 {
                    components.month = month
                    components.day = day - 4
                } else if weekday == 7 {
                    components.month = month
                    components.day = day - 5
                }
                
                
                //The 2nd day of the month monday and Tuesday keep the same month
                
            } else if day == 2 {
                
                if weekday == 1 {
                    components.month = month
                    components.day = day - 6
                } else if weekday == 2  {
                    components.month = month
                    components.day = day
                } else if weekday == 3 {
                    components.month = month
                    components.day = day - 1
                } else if weekday == 4 {
                    components.month = month
                    components.day = day - 2
                } else if weekday == 5 {
                    components.month = month
                    components.day = day - 3
                } else if weekday == 6 {
                    components.month = month
                    components.day = day - 4
                } else if weekday == 7 {
                    components.month = month
                    components.day = day - 5
                }
                
                //The 3d day of the month monday and Tuesday and Wednesday keep the same month
            } else if day == 3 {
                
                if weekday == 1 {
                    components.month = month
                    components.day = day - 6
                } else if weekday == 2  {
                    components.month = month
                    components.day = day
                } else if weekday == 3 {
                    components.month = month
                    components.day = day - 1
                } else if weekday == 4 {
                    components.month = month
                    components.day = day - 2
                } else if weekday == 5 {
                    components.month = month
                    components.day = day - 3
                } else if weekday == 6 {
                    components.month = month
                    components.day = day - 4
                } else if weekday == 7 {
                    components.month = month
                    components.day = day - 5
                }
                //The 4th day of the month Monday,Tuesday, Wednesday and Thursday keep the same month
            }  else if day == 4 {
                
                if weekday == 1 {
                    components.month = month - 1
                    components.day = day - 6
                } else if weekday == 2  {
                    components.month = month
                    components.day = day
                } else if weekday == 3 {
                    components.month = month
                    components.day = day - 1
                } else if weekday == 4 {
                    components.month = month
                    components.day = day - 2
                } else if weekday == 5 {
                    components.month = month
                    components.day = day - 3
                } else if weekday == 6 {
                    components.month = month - 1
                    components.day = day - 4
                } else if weekday == 7 {
                    components.month = month - 1
                    components.day = day - 5
                }
                
               
                
                
                //The 5th day of the month Monday,Tuesday,Wednesday,Thursday and Friday keep the same month  AND SATURDAY
            } else if day == 5 {
                
                if weekday == 1 {
                    components.month = month - 1
                    components.day = day - 6
                } else if weekday == 2  {
                    components.month = month
                    components.day = day
                } else if weekday == 3 {
                    components.month = month
                    components.day = day - 1
                } else if weekday == 4 {
                    components.month = month
                    components.day = day - 2
                } else if weekday == 5 {
                    components.month = month
                    components.day = day - 3
                } else if weekday == 6 {
                    components.month = month
                    components.day = day - 4
                } else if weekday == 7 {
                    components.month = month// - 1
                    components.day = day - 5
                }
                //The 6th day of the month Monday,Tuesday,Wednesday,Thursday,Friday and Saturday keep the same month
            } else if day == 6 {
                
                if weekday == 1 {
                    components.month = month //- 1
                    components.day = day - 6
                } else if weekday == 2  {
                    components.month = month
                    components.day = day
                } else if weekday == 3 {
                    components.month = month
                    components.day = day - 1
                } else if weekday == 4 {
                    components.month = month
                    components.day = day - 2
                } else if weekday == 5 {
                    components.month = month
                    components.day = day - 3
                } else if weekday == 6 {
                    components.month = month
                    components.day = day - 4
                } else if weekday == 7 {
                    components.month = month
                    components.day = day - 5
                }
                //The 7th day of the month Monday,Tuesday,Wednesday,Thursday,Friday,Saturday and Sunday keep the same month
            } else if day >= 7 {
                
                if weekday == 1 {
                    components.month = month
                    components.day = day - 6
                } else if weekday == 2  {
                    components.month = month
                    components.day = day
                } else if weekday == 3 {
                    components.month = month
                    components.day = day - 1
                } else if weekday == 4 {
                    components.month = month
                    components.day = day - 2
                } else if weekday == 5 {
                    components.month = month
                    components.day = day - 3
                } else if weekday == 6 {
                    components.month = month
                    components.day = day - 4
                } else if weekday == 7 {
                    components.month = month
                    components.day = day - 5
                }
                
            }//and for everyday with day > 7 every weekday keeps the same month
            
            
            
            
            
            let defaultDate: NSDate = calendar.date(from: components as DateComponents)! as NSDate
            //In order to load correct starting dTE WHEN IN MANUAL MODE
            
            self.pickerOfStartingDate.date = defaultDate as Date
            
            //until today
            components.month = month
            components.day = day
            let endingDate: NSDate = calendar.date(from: components as DateComponents)! as NSDate
            self.pickerOfEndingDate.date = endingDate as Date
            // self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            
            if isPaidVersionOn {
                //Do nothing
            } else if boolInterstitialTracker {
                checkAndPlayAd()
                boolInterstitialTracker = !boolInterstitialTracker
            } else {
                boolInterstitialTracker = !boolInterstitialTracker
            }
            
            
            
            
            
            
        } else if segmentOfPeriod.selectedSegmentIndex == 2 {
            
            // self.navigationItem.rightBarButtonItem?.isEnabled = true
            //From the 1st day of the month
            components.year = year
            components.month = month
            components.day = 1
            let defaultDate: NSDate = calendar.date(from: components as DateComponents)! as NSDate
            self.pickerOfStartingDate.date = defaultDate as Date
            
            //until today
            components.day = day
            let endingDate: NSDate = calendar.date(from: components as DateComponents)! as NSDate
            self.pickerOfEndingDate.date = endingDate as Date
            
            
            
            //importAdinter every 3 taps
            if isPaidVersionOn {
                //Do nothing
            } else if intInterstitialCounter == 2 {
                checkAndPlayAd()
                intInterstitialCounter = 0
            } else {
               intInterstitialCounter += 1
            }
            
            
            
            
            
            
            
            
            
            
        } else if segmentOfPeriod.selectedSegmentIndex == 3 {
            
            // self.navigationItem.rightBarButtonItem?.isEnabled = true
            //From the 1st day of the quarter
            components.year = year
            
            
            
            if month >= 1 && month <= 3 {
                components.month = 1
            } else if month >= 4 && month <= 6 {
                components.month = 4
            }  else if month >= 7 && month <= 9 {
                components.month = 7
            } else if month >= 10 && month <= 12 {
                components.month = 10
            }
            
            
            
            
            
            components.day = 1
            let defaultDate: NSDate = calendar.date(from: components as DateComponents)! as NSDate
            self.pickerOfStartingDate.date = defaultDate as Date
            
            
            //until today
            components.month = month
            components.day = day
            let endingDate: NSDate = calendar.date(from: components as DateComponents)! as NSDate
            self.pickerOfEndingDate.date = endingDate as Date
            
            
            //importAdinter every 3 taps
            if isPaidVersionOn {
                //Do nothing
            } else if intInterstitialCounter == 2 {
                checkAndPlayAd()
                intInterstitialCounter = 0
            } else {
               intInterstitialCounter += 1
            }
            
            
            
            
            
        } else if segmentOfPeriod.selectedSegmentIndex == 4 {
            
            
            //  self.navigationItem.rightBarButtonItem?.isEnabled = true
            
            //From the 1st day of the year
            components.year = year
            components.month = 1
            components.day = 1
            let defaultDate: NSDate = calendar.date(from: components as DateComponents)! as NSDate
            self.pickerOfStartingDate.date = defaultDate as Date
            
            //until today
            components.month = month
            components.day = day
            let endingDate: NSDate = calendar.date(from: components as DateComponents)! as NSDate
            self.pickerOfEndingDate.date = endingDate as Date
            
            if isPaidVersionOn {
                //Do nothing
            } else if boolInterstitialTracker {
                checkAndPlayAd()
                boolInterstitialTracker = !boolInterstitialTracker
            } else {
                boolInterstitialTracker = !boolInterstitialTracker
            }
            
            
            
            
        } else if segmentOfPeriod.selectedSegmentIndex == 5 {
            
            //extemely helpfulf as it brings the pickers to the right place NO MATTER WHAT------------------------
            self.pickerOfStartingDate.date = self.selectedDStartingDate
            self.pickerOfEndingDate.date = self.selectedEndingDate
            
            
            
        }
        
        
        
    }//Func
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}//ext





// MARK: - Alerts
extension ListTableViewController {
    func   dateOrderAlert(){
        if pickerOfStartingDate.date > pickerOfEndingDate.date{
            //DisableReport
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            //ShowAlert
            let dateOrderAlert = UIAlertController(title: LocalizedString.attentionAlert.localized,
                                                     message: LocalizedString.dateOrderAlert.localized,
                                                     preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: LocalizedString.okInAlert.localized,
                                         style: UIAlertAction.Style.default,
                                         handler: nil)
            
            dateOrderAlert.addAction(okAction)
            
            self.present(dateOrderAlert, animated:true, completion: nil)
        }
    }
   
    
}//ext



/*
extension UISearchBar {

     var textColor:UIColor? {
         get {
             if let textField = self.value(forKey: "searchField") as?
 UITextField  {
                 return textField.textColor
             } else {
                 return nil
             }
         }

         set (newValue) {
             if let textField = self.value(forKey: "searchField") as?
 UITextField  {
                 textField.textColor = newValue
             }
         }
     }
 }
*/




//importADBanner
extension ListTableViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("received add")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
       print(error)
    }
    
}//ext



//importADinter
extension ListTableViewController: GADInterstitialDelegate {
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
