//
//  IAPRefreshView.swift
//  Pythagorean
//
//  Created by Ioannis on 26/3/21.
//

import Foundation
import StoreKit

enum ProductType {
    case nonconsumable
    case consumable
}


struct ContentItem {
    var identifier: String
    var purchaseType: ProductType
    var content: String
}

//-----------------------------------------------Dig in it--------------------------------------
struct AppContent {
    static let main = {
        ContentItem(identifier: "com.iappetos.Pythagorean.AdFree", purchaseType: .nonconsumable, content: "youBought Pro")
      //  ContentItem(identifier: "com.iappetos.LuckyPunk.ExtraTrials", purchaseType: .consumable, content: "10 extras bought")
        
    }
}
