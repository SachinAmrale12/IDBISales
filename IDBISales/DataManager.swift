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

    
    // //http://localhost:8080/AbhayCard/register/ldapLogin/{"username":"YuqLeXfu6ESSYNQRjh9g==","pin":":*:T5bctRG3wVxsbqYeIeA ==","clientId":"tzLonXeVMWmyi1reRhqw==","message":"wG:*:4epyCFCMmjFXcswcg=="}
    
    //class func Registration(custID: String ,withMobile: String ,withClientSecret: String ,withClientID: String, completionClouser: @escaping (_ isSuccessful:Bool,_ error:String?,_ result: Any?) -> Void){
    
//    class func Login(userName : String,withPin : String,withClientID : String, withMessage : StringcompletionClouser: @escaping (_ isSuccessful:Bool,_ error:String?,_ result: Any?) -> Void)
//    {
//        ServerManager.SharedInstance().loginFromBankEmployee(userName: userName, withPin : withPin, withClientID : withClientID, withMessage : withMessage, completionClouser: {(isSucessful,error,result) in
//        if isSucessful
//        {
//            completionClouser(isSucessful,nil,result)
//        }
//        else
//        {
//            completionClouser(isSucessful,error,nil)
//
//        }
//        
//        })
//    }

}
