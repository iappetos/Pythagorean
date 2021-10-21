//
//  IAPManager.swift
//  Pythagorean
//
//  Created by Ioannis on 26/3/21.
//

import Foundation
import StoreKit


//-------change String/variable for every new App-----------------
 var stringOfAppSecret = "9288c2e82ff74837a354dad563238c54"


protocol StoreManagerDelegate: class {
    //The class that will adapt this protocol will have these  functions
    //StoreManager will ask for the products and then will give them back to the class that asked
    func updateWithProducts(products:[SKProduct])
   // func refreshPurchaseStatus()
}


protocol RefreshViewDelegate: class {
    func updatePurchasedItemsInTheView()
}


class IAPManager: NSObject {
    //instance variables
       weak var delegate: StoreManagerDelegate?
       weak var viewDelegate: RefreshViewDelegate?
       var loadedProducts: [SKProduct] = []
    
    //var verifier: IAPReceiptVerifier?
    let appSecret = stringOfAppSecret //"5ec539ac65fa4415bd90094f0c770fa9"
    let receiptURL = Bundle.main.appStoreReceiptURL
    //var receiptIsValid: Bool = false
 
   let receiptRequestor = ReceiptRequestor()
   let purchasedProductHandler = PurchasedProductHandler()
    
    
    
    override init() {
           super.init()
           SKPaymentQueue.default().add(self)
           checkCustomerAndStock()
       }
    
    func checkCustomerAndStock() {
           if SKPaymentQueue.canMakePayments() {
               print("customer can make payments so we are ready to sell")
            let products = NSSet(array: myProductList.arrayOfProducts)
               let request = SKProductsRequest(productIdentifiers: products as! Set<String>)
               request.delegate = self
               request.start()
           } else {
               print("please enable IAP")
        }
           
       }//Func
    
    func makePaymentForProduct(myProduct: SKProduct){
               print("someone pays for " + myProduct.productIdentifier)
               let payment = SKPayment(product: myProduct)
               SKPaymentQueue.default().add(self)  //Seemu
               SKPaymentQueue.default().add(payment)
               
    }
    
    
    func restoreCompletedTransactions(){
           SKPaymentQueue.default().add(self)
           SKPaymentQueue.default().restoreCompletedTransactions()
        print("restored")
       }
    
    
    
    
    
    
    
}//class


extension IAPManager: SKProductsRequestDelegate {
    //Parte Kosme
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
           print("requesting for product")
           print("Parte kosme")
           //let myProducts = response.products
        self.loadedProducts = response.products
        
        if self.loadedProducts.count != 0 {
            delegate?.updateWithProducts(products: loadedProducts)
        }
        
       }//Func
    
}//ext



extension IAPManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]){
        
        //  for transaction:AnyObject in transactions {
        //      if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                
                for transaction in transactions  {
                
                
            
             // switch trans.transactionState {
                switch transaction.transactionState {
                
                
              case .purchased, .restored: print("someone wants to buy")
                               
              //Andrew Bandcroft--Masterpiece
              if let receiptData = AppStoreReceiptValidator.loadReceipt() {
                //validate
                AppStoreReceiptValidator.validate(receiptData) {
                    validationResult in
                     print("did I got a receipt back?")
                    print(validationResult)
                    //unlock purchased content
                    if validationResult.statusDescription == .valid {
                        
                        ProductDelivery.deliverProduct(product: transaction.payment.productIdentifier)
                        self.viewDelegate?.updatePurchasedItemsInTheView()
                        
                    }//is valid
                }//validate
                
              } else {
                //Receipt Refresh
                self.receiptRequestor.start {
                    if let receiptData = AppStoreReceiptValidator.loadReceipt() {
                        AppStoreReceiptValidator.validate(receiptData) {
                            validationResult in
                            print("did I got a receipt back?")
                            print(validationResult)
                             //unlock purchased content
                             if validationResult.statusDescription == .valid {
                                               
                            ProductDelivery.deliverProduct(product: transaction.payment.productIdentifier)
                            self.viewDelegate?.updatePurchasedItemsInTheView()
                            
                            self.purchasedProductHandler.handle(transaction.payment.productIdentifier, with: validationResult)
                                               
                        }//is valid
                    }//validate
                  } //if let
                } //start
              }//else
              
              //Finish Transaction
              SKPaymentQueue.default().finishTransaction(transaction)
                            break
              
            
                
                
              case .failed: SKPaymentQueue.default().finishTransaction(transaction)
                            print("buy error")
                            break
                
        
                
              default:  print("product not found")
                        break
              }
            }
          //}
        }//Func
        
        
        
        

        

}//ext


extension SKProduct {
  
  func localizedPrice() -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = self.priceLocale
    return formatter.string(from: self.price)!
  }
    
  
}//ext




