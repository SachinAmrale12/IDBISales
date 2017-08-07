//
//  DataManager.swift
//  IDBISales
//
//  Created by Sachin Amrale on 03/08/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    
    class func SharedInstance() -> DataManager{
        
        struct Static {
            //Singleton instance. Initializing Data manager.
            static let sharedInstance = DataManager()
        }
        /** @return Returns the default singleton instance. */
        return Static.sharedInstance
    }

    func getKeyForEncryption() -> String
    {
        return KeyCode.sharedInstance().getKey(JNKeychain.loadValue(forKey: "userID") as! String, withMobile: JNKeychain.loadValue(forKey: "mobileNumber") as! String)
    }
    
    func getGlobalKey() -> String
    {
        return KeyCode.sharedInstance().getKey("2981012620", withMobile: "0262101892")
    }
    
    
    class func getCustomerDetails(custID: String,clientID: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        ServerManager.SharedInstance().getCustomerDetails(custID: custID, clientID: clientID) { (isSuccessful, error, result) in
            
            if isSuccessful
            {
                completionClouser(isSuccessful,nil,result)
            }
            else
            {
                completionClouser(isSuccessful,error,nil)
            }
        }
    }
    
    
    class func getProgrammList(custID: String,clientID: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        ServerManager.SharedInstance().getProgrammList(custID: custID, clientID: clientID) { (isSuccessful, error, result) in
            
            if isSuccessful
            {
                completionClouser(isSuccessful,nil,result)
            }
            else
            {
                completionClouser(isSuccessful,error,nil)
            }
        }
    }
    
    class func getBranches(custID: String,clientID: String,message: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        ServerManager.SharedInstance().getBranches(custID: custID, clientID: clientID, message: message) { (isSuccessful, error, result) in
            
            if isSuccessful
            {
                completionClouser(isSuccessful,nil,result)
            }
            else
            {
                completionClouser(isSuccessful,error,nil)
            }
        }
    }
    
    class func getCities(custID: String,clientID: String,message: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        ServerManager.SharedInstance().getCities(custID: custID, clientID: clientID, message: message) { (isSuccessful, error, result) in
            
            if isSuccessful
            {
                completionClouser(isSuccessful,nil,result)
            }
            else
            {
                completionClouser(isSuccessful,error,nil)
            }
        }
    }
    
    class func getStates(custID: String,clientID: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        ServerManager.SharedInstance().getStates(custID: custID, clientID: clientID) { (isSuccessful, error, result) in
        
            if isSuccessful
            {
                completionClouser(isSuccessful,nil,result)
            }
            else
            {
                completionClouser(isSuccessful,error,nil)
            }
        }
    }
    
    class func getAccessToken(custID: String,clientID: String,pin :String,username: String,clientSecret: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        ServerManager.SharedInstance().getAccessToken(custID: custID, clientID: clientID, pin: pin, username: username, clientSecret: clientSecret) { (isSucessful, error, result) in
            
            if isSucessful
            {
                completionClouser(isSucessful,nil,result)
            }
            else
            {
                completionClouser(isSucessful,error,nil)
            }
        }
    }
    
    class func LoginUser(userName: String,clientID: String,pin: String,message: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        ServerManager.SharedInstance().LoginUser(userName: userName, clientID: clientID, pin: pin, message: message) { (isSucessful, error, result) in
            
            if isSucessful
            {
                completionClouser(isSucessful,nil,result)
            }
            else
            {
                completionClouser(isSucessful,error,nil)
            }
        }
    }

}
