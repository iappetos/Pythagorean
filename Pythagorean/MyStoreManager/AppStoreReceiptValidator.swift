//
//  AppStoreReceiptValidator.swift
//  Pythagorean
//
//  Created by Ioannis on 26/3/21.
//

import Foundation
//-----------------------------------------------Dig in it--------------------------------------
var stringOfURLRequest =
           "https://pythagorean.azurewebsites.net/api/HttpTrigger1?code=UH02aW33hVKwlt2xMkelA5xVJ3vTSqW6Aaxj83IrRPeQnKYZraa06w=="

struct AppStoreReceiptValidator {
    
   
    
    
    static func loadReceipt() -> Data? {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else {return nil}
        guard (try? receiptURL.checkResourceIsReachable()) != nil else {return nil}
        guard let receiptData = try? Data(contentsOf: receiptURL) else {return nil}
        
        return receiptData
    }//load
    
    
    static func validate(_ receiptData: Data, completion: @escaping (AppStoreValidationResult) -> Void = {_ in}) {
        //prepare an http request
        var request = URLRequest(url: URL(string: stringOfURLRequest /*"https://luckypunk.azurewebsites.net/api/ValidateAppStoreReceipt?code=RfK3TV9TTQKWwlde4kBaaaujdW8PlXTqT/A/4jsQXd2/oAlt5r4wAQ=="*/)!)
        //and configure it to communicat. with the server side function URL
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = receiptData.base64EncodedData()
        
        
        print("----------------------------RECEIPT--------------------")
        print(receiptData.base64EncodedString())
        
        
        
        
        
        //prepare a URLsession data task to handle the response
        let task = URLSession.shared.dataTask(with: request) { (responseData, urlResponse, error) in
            guard let appStoreValidationResultJSON = responseData else { return}
            print("I got the data")
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            do {
                  let validationResult = try
                    decoder.decode(AppStoreValidationResult.self, from: appStoreValidationResultJSON)
                   //how to get validation result back to the caller of the validatefunction?
                   //design and call a completion closure
                 completion(validationResult)
    
            } catch {
                print("This is the error I catch my old good fried:")
                print(error.localizedDescription)
            }
            
        }//task
        
        
        
        
        
        
        //resume Task
        task.resume()
        
    }//validate
}//struct
























// https://developer.apple.com/documentation/appstorereceipts/responsebody
struct AppStoreValidationResult: Decodable {
    let environment: String?
    let latestReceipt: String?
    let latestReceiptInfo: [InAppPurchaseTransaction]?
    let pendingRenewalInfo: [PendingRenewalInformation]?
    let receipt: Receipt
    let status: Int
    var statusDescription: ReceiptStatusDescription {
        get {
            return ReceiptStatusDescription(rawValue: self.status) ?? .unknown
        }
    }
}

// https://developer.apple.com/documentation/appstorereceipts/responsebody/receipt
struct Receipt: Decodable {
    let adamId: Double
    let appItemId: Double
    let applicationVersion: String
    let bundleId: String
    let downloadId: Int
    let expirationDate: Date?
    let expirationDateMs: String?
    let expirationDatePst: String?
    let inApp: [InAppPurchaseTransaction]
    let originalApplicationVersion: String
    let originalPurchaseDate: String
    let originalPurchaseDateMs: String
    let originalPurchaseDatePst: String
    let preorderDate: Date?
    let preorderDateMs: String?
    let preorderDatePst: Date?
    let receiptCreationDate: Date
    let receiptCreationDateMs: String
    let receiptCreationDatePst: Date
    let receiptType: String
    let requestDate: Date
    let requestDateMs: String
    let requestDatePst: Date
    let versionExternalIdentifier: Int
}

// https://developer.apple.com/documentation/appstorereceipts/responsebody/latest_receipt_info
struct InAppPurchaseTransaction: Decodable {
    let cancellationDate: Date?
    let cancellationDateMs: String?
    let cancellationDatePst: Date?
    let cancellationReason: String?
    let expiresDate: Date?
    let expiresDateMs: String?
    let expiresDatePst: Date?
    let isInIntroOfferPeriod: String?
    let isTrialPeriod: String?
    let originalPurchaseDate: Date
    let originalPurchaseDateMs: String
    let originalPurchaseDatePst: Date
    let originalTransactionId: String
    let productId: String
    let promotionalOfferId: String?
    let purchaseDate: Date
    let purchaseDateMs: String
    let purchaseDatePst: Date
    let quantity: String
    let transactionId: String
    let webOrderLineItemId: String?
}

// https://developer.apple.com/documentation/appstorereceipts/responsebody/pending_renewal_info
struct PendingRenewalInformation: Decodable {
    let autoRenewProductId: String?
    let autoRenewStatus: String
    let expirationIntent: String?
    let gracePeriodExpiresDate: Date?
    let gracePeriodExpiresDateMs: String?
    let gracePeriodExpiresDatePst: Date?
    let isInBillingRetryPeriod: String?
    let originalTransactionId: String
    let priceConsentStatus: String?
    let productId: String
}

// https://developer.apple.com/documentation/appstorereceipts/status
public enum ReceiptStatusDescription: Int {
    // valid status
    case valid = 0
    
    // The request to the App Store was not made using the HTTP POST request method.
    case appStoreRequestNotHTTPPost = 21000
    
    // The data in the receipt-data property was malformed or the service experienced a temporary issue.  Try again.
    case malformedOrMissingReceiptData = 21002
    
    // The receipt could not be authenticated.
    case receiptCouldNotBeAuthenticated = 21003
    
    // The shared secret you provided does not match the shared secret on file for your account.
    case sharedSecretDoesNotMatch = 21004
    
    // The receipt server was temporarily unable to provide the receipt. Try again.
    case receiptServerUnavailable = 21005
    
    // This receipt is valid but the subscription has expired. When this status code is returned to your server, the receipt data is also decoded and returned as part of the response. Only returned for iOS 6-style transaction receipts for auto-renewable subscriptions.
    case iOS6StyleSubscriptionExpired = 21006 // Legacy
    
    // This receipt is from the test environment, but it was sent to the production environment for verification.
    case testReceiptSentToProduction = 21007
    
    // This receipt is from the production environment, but it was sent to the test environment for verification.
    case productionReceiptSentToTest = 21008
    
    // Internal data access error. Try again later.
    case internalDataAccessError = 21009
    
    // The user account cannot be found or has been deleted.
    case userAccountNotFoundOrDeleted = 21010
    
    case unknown
}










/*

// https://developer.apple.com/documentation/appstorereceipts/responsebody
struct AppStoreValidationResult: Decodable {
    let environment: String?
    let latestReceipt: String?
    let latestReceiptInfo: [InAppPurchaseTransaction]?
    let pendingRenewalInfo: [PendingRenewalInformation]?
    let receipt: Receipt
    let status: Int
    var statusDescription: ReceiptStatusDescription {
        get {
            return ReceiptStatusDescription(rawValue: self.status) ?? .unknown
        }
    }
}

// https://developer.apple.com/documentation/appstorereceipts/responsebody/receipt
struct Receipt: Decodable {
    let adamId: Double
    let appItemId: Double
    let applicationVersion: String
    let bundleId: String
    let downloadId: Int
    let expirationDate: Date?
    let expirationDateMs: String?
    let expirationDatePst: String?
    let inApp: [InAppPurchaseTransaction]
    let originalApplicationVersion: String
    let originalPurchaseDate: String
    let originalPurchaseDateMs: String
    let originalPurchaseDatePst: String
    let preorderDate: Date?
    let preorderDateMs: String?
    let preorderDatePst: Date?
    let receiptCreationDate: Date
    let receiptCreationDateMs: String
    let receiptCreationDatePst: Date
    let receiptType: String
    let requestDate: Date
    let requestDateMs: String
    let requestDatePst: Date
    let versionExternalIdentifier: Int
}

// https://developer.apple.com/documentation/appstorereceipts/responsebody/latest_receipt_info
struct InAppPurchaseTransaction: Decodable {
    let cancellationDate: Date?
    let cancellationDateMs: String?
    let cancellationDatePst: Date?
    let cancellationReason: String?
    let expiresDate: Date?
    let expiresDateMs: String?
    let expiresDatePst: Date?
    let isInIntroOfferPeriod: String?
    let isTrialPeriod: String?
    let originalPurchaseDate: Date
    let originalPurchaseDateMs: String
    let originalPurchaseDatePst: Date
    let originalTransactionId: String
    let productId: String
    let promotionalOfferId: String?
    let purchaseDate: Date
    let purchaseDateMs: String
    let purchaseDatePst: Date
    let quantity: String
    let transactionId: String
    let webOrderLineItemId: String?
}

// https://developer.apple.com/documentation/appstorereceipts/responsebody/pending_renewal_info
struct PendingRenewalInformation: Decodable {
    let autoRenewProductId: String?
    let autoRenewStatus: String
    let expirationIntent: String?
    let gracePeriodExpiresDate: Date?
    let gracePeriodExpiresDateMs: String?
    let gracePeriodExpiresDatePst: Date?
    let isInBillingRetryPeriod: String?
    let originalTransactionId: String
    let priceConsentStatus: String?
    let productId: String
}

// https://developer.apple.com/documentation/appstorereceipts/status
public enum ReceiptStatusDescription: Int {
    // valid status
    case valid = 0
    
    // The request to the App Store was not made using the HTTP POST request method.
    case appStoreRequestNotHTTPPost = 21000
    
    // The data in the receipt-data property was malformed or the service experienced a temporary issue.  Try again.
    case malformedOrMissingReceiptData = 21002
    
    // The receipt could not be authenticated.
    case receiptCouldNotBeAuthenticated = 21003
    
    // The shared secret you provided does not match the shared secret on file for your account.
    case sharedSecretDoesNotMatch = 21004
    
    // The receipt server was temporarily unable to provide the receipt. Try again.
    case receiptServerUnavailable = 21005
    
    // This receipt is valid but the subscription has expired. When this status code is returned to your server, the receipt data is also decoded and returned as part of the response. Only returned for iOS 6-style transaction receipts for auto-renewable subscriptions.
    case iOS6StyleSubscriptionExpired = 21006 // Legacy
    
    // This receipt is from the test environment, but it was sent to the production environment for verification.
    case testReceiptSentToProduction = 21007
    
    // This receipt is from the production environment, but it was sent to the test environment for verification.
    case productionReceiptSentToTest = 21008
    
    // Internal data access error. Try again later.
    case internalDataAccessError = 21009
    
    // The user account cannot be found or has been deleted.
    case userAccountNotFoundOrDeleted = 21010
    
    case unknown
}


*/


















/*
//https://developer.apple.com/documentation/appstorereceipts/responsebody
struct AppStoreValidationResult: Decodable {
    let environment: String?
    let latestReceipt: String?
    let latestReceiptInfo: [InAppPurchaseTransaction]?
    let pendingRenewalInfo: [PendingRenewalInformation]?
    let receipt: Receipt
    //if status is 0 then the receipt is valid
    let status: Int
    //from the enum "ReceiptStatusDescription) I will get the raw value and put it in a new var named "statusDescription"
    var statusDescription: ReceiptStatusDescription {
        get {
            return ReceiptStatusDescription(rawValue: self.status) ?? .unknown
        }//get
    }//var
}//struct


//https://developer.apple.com/documentation/appstorereceipts/responsebody/receipt
struct Receipt: Decodable {
    let adamid: Double
    let appItemID: Double
    let applicationVersion: String
    let bundleID: String
    let dowloadID: Int
    let expirationDate: Date?
    let expirationDateMs: String?
    let expirationDatePst: String
    let inApp: [InAppPurchaseTransaction]
    let originalApplicationVersion: String
    let originalPurchaseDate: String
    let originalPurchaseDateMS: String
    let originalPurchaseDatePst: String
    let preorderDate: Date?
    let preorderDateMs: String?
    let preorderDatePst: Date?
    let receiptCreationDate: Date
    let receiptCreationDateMs: String
    let receiptCreationDatePst: Date
    let receiptType: String
    let requestDate: Date
    let requestDateMs: String
    let requestDatePst: Date
    let versionExternalIdentifier: Int

}

//https://developer.apple.com/documentation/appstorereceipts/responsebody/latest_receipt_info
struct InAppPurchaseTransaction: Decodable {
    let cancellationDate: Date?
    let cancellationDateMS: String?
    let cancellationDatePst: Date?
    let cancellationReason: String?
    let expiresDate: Date?
    let expiresDateMs: String?
    let expiresDatePst: Date?
    let isInIntroOfferPeriod: String?
    let isTrialPeriod: String
    let originalPurchaseDate: Date
    let originalPurchaseDateMS: String
    let originalPurchaseDatePst: Date
    let originalTransactionID: String
    let productId: String
    let promotionalOfferId: String?
    let purchaseDate: Date
    let purchaseDateMs: String
    let purchaseDatePst: Date
    let quantity: String
    let transactionId: String
    let webOrderLineItemId: String?
    
}

//https://developer.apple.com/documentation/appstorereceipts/responsebody/pending_renewal_info
struct PendingRenewalInformation: Decodable {
    
    let autoRenewProductId: String?
    let autoRenewStatus: String
    let expirationIntent: String?
    let gracePeriodExpiresDate: Date?
    let gracePeriodExpiresDateMs: String?
    let gracePeriodExpiresPst: Date?
    let isInBillingRetryPeriod: String?
    let originalTransactionId: String
    let priceConsentStatus: String?
    let produvtId: String
    
}


//https://developer.apple.com/documentation/appstorereceipts/status
public enum ReceiptStatusDescription: Int {
    //valid Status
    case valid = 0
    //the request was not made using the HTTP POST method
    case appStoreRequestNotHTTPPost = 21000
    case malformedOrMissingReceiptDate = 21002
    case receiptCouldNotBeAuthenticated = 21003
    case sharedSecretDoesNotMuch = 21004
    case receiptServerUnavailable = 21005
    case iOS6StyleSubscriptionExpired = 21006
    case testReceiptSentToProducton = 21007
    case productionReceiptSendToTest = 21008
    case internalDataAccessError = 21009
    case userAccountForFoundOrDeleted = 21010
    case unknown
    
}
*/
