//
//  PurchasedProductHandler.swift
//  Pythagorean
//
//  Created by Ioannis on 26/3/21.
//

import Foundation
class PurchasedProductHandler {
    //MARK: Primary Handle Function
    
    func handle(_ purchasedProductIdentifier: String, with validationResult: AppStoreValidationResult) {
        if purchasedProductIdentifier == myProductList.appPro {
           // if validationResult.receipt.inApp.contains(where: )
        }
}
    
    
    
    fileprivate let keychainAppIdentifier = "com.iappetos.ExpenseOne"
    fileprivate let calqulistProKey = "com.ikaragogos.CalqulistPro"

    
    
    func getValue(forKey keychainItemKey: String) -> String?  {
        let searchQuerry: [String:Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: keychainAppIdentifier,
            kSecAttrAccount as String: keychainItemKey,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var keychainItem: CFTypeRef?
        let status = SecItemCopyMatching(searchQuerry as CFDictionary, &keychainItem)
        
        guard status != errSecItemNotFound,
              let item = keychainItem as? [String:Any],
              let data = item[kSecValueData as String] as? Data,
              let stringValue = String(data: data, encoding: .utf8)
        else { return nil }
        
        return stringValue
    }
    
    
    func save(_ value: String, forKey keychainItemKey: String) {
        
        if getValue(forKey: keychainItemKey) != nil {
            
            if let encodedValue = value.data(using: .utf8) {
                
                let existingItemQuerry: [String:Any] = [
                    kSecClass as String: kSecClassInternetPassword,
                    kSecAttrAccount as String: keychainItemKey,
                    kSecAttrServer as String: keychainAppIdentifier
                ]
                
                
                let updateItemQuerry: [String:Any] =  [
                    kSecValueData as String: encodedValue]
                
                
                SecItemUpdate(existingItemQuerry as CFDictionary, updateItemQuerry as CFDictionary  )
                
                
                
                
                
            }
            
            
            
            
            
            
            
        } else {
            if let encodedValue = value.data(using: .utf8) {
                let addItemQuerry: [String:Any] = [
                    kSecClass as String: kSecClassInternetPassword,
                    kSecAttrAccount as String: keychainItemKey,
                    kSecAttrServer as String: keychainAppIdentifier,
                    kSecValueData as String: encodedValue
                ]
                
                SecItemAdd(addItemQuerry as CFDictionary, nil)
                
                
            }
            
        }
    }//func
    
    
    
    
    var isCalqulistPro: Bool {
        get {
            //make sure keychain item exists
            guard let calqulistProSting = getValue(forKey: calqulistProKey) else { return false }
            //convert it to bool
            guard let isCalqulistPro = Bool(calqulistProSting) else { return false }
            
            return isCalqulistPro
        }
        set {
            save(String(newValue), forKey: calqulistProKey)
        }
    }
    
    
    
    
    
    
}//class




extension PurchasedProductHandler {
    func describePurchases(){
        print("isCalqulistPro: \(self.isCalqulistPro)")
    }
}
