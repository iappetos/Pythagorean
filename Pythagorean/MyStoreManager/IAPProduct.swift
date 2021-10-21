//
//  IAPProduct.swift
//  Pythagorean
//
//  Created by Ioannis on 26/3/21.
//

import Foundation
import StoreKit
import SwiftKeychainWrapper

//import SwiftKeychainWrapper


//-------Three Places to change Strings/variables for every new App-----------------





//-----------------------------------------------Dig in it--------------------------------------
struct myProductList {
    static let appPro : String = "com.iappetos.Pythagorean.AdFree"
    static let arrayOfProducts = [appPro]
    
}


struct ProductDelivery {

    
//-----------------------------------------------Dig in it--------------------------------------
static func deliverProduct(product: String) {
switch product {
case myProductList.appPro: deliverNonconsumable(identifier: myProductList.appPro)
      break
default: break
}
}//Func

  
    
    //This is where we configure for the paid version
static func deliverNonconsumable(identifier: String) {
    KeychainWrapper.standard.set(true, forKey: identifier)
    print("SET TO TRUe")
      // UserDefaults.standard.set(true, forKey: identifier)
      // UserDefaults.standard.synchronize()
    NSUbiquitousKeyValueStore.default.set(true, forKey: identifier)
    NSUbiquitousKeyValueStore.default.synchronize()
    }//func
    
    
static func isProductAvailable(identifier: String) -> Bool {
      if KeychainWrapper.standard.bool(forKey: identifier) == true {
        return true
      } else {
        return false
      }
    }//func
    
    static func deliverConsumable(identifier: String, units: Int) {
      //  let currentUnits: Int = UserDefaults.standard.integer(forKey: identifier)
       
        KeychainWrapper.standard.set(/*currentUnits + */units, forKey: identifier)
        //KeychainWrapper.standard.synchronize()
        NSUbiquitousKeyValueStore.default.set(units, forKey: identifier)
        NSUbiquitousKeyValueStore.default.synchronize()

}//func
    
    
    static func remainingUnits(identifier: String) -> Int {
        return KeychainWrapper.standard.integer(forKey: identifier)!
    }//Func
    
    
    
    //-----------------------------------------------Dig in it--------------------------------------
    static func updateFromiCloud() {
       // let latestExtraTrials = NSUbiquitousKeyValueStore.default.double(forKey: myProductList.extraTrials)
        let latestUnlimited = NSUbiquitousKeyValueStore.default.bool(forKey: myProductList.appPro)
        
        // KeychainWrapper.standard.set(latestExtraTrials, forKey: myProductList.extraTrials)
         KeychainWrapper.standard.set(latestUnlimited, forKey: myProductList.appPro)
    }
    
    
    
}//Struct
    
    

