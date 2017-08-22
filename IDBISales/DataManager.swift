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
    
    
    class func createAppointment(tranLeadId: String,takerEmail: String,appointmentDt: String,appmntRemarks: String,custId: String,clientId: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        ServerManager.SharedInstance().createAppointment(tranLeadId: tranLeadId, takerEmail: takerEmail, appointmentDt: appointmentDt, appmntRemarks: appmntRemarks, custId: custId, clientId: clientId) { (isSuccessful, error, result) in
            
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
    
    
    class func assignLead(tranLeadId: String,giverEmail: String,giverRemarks: String,takerEmail: String,takerSol: String,custId: String,clientId: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        ServerManager.SharedInstance().assignLead(tranLeadId: tranLeadId, giverEmail: giverEmail, giverRemarks: giverRemarks,takerEmail: takerEmail,takerSol: takerSol,custId: custId, clientId: clientId) { (isSuccessful, error, result) in
            
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
    
    class func getReports(ein: String,clientId: String,flg: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        ServerManager.SharedInstance().getReports(ein: ein, clientId: clientId, flg: flg) { (isSuccessful, error, result) in
            
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
    
    class func viewLead(custId: String,clientId: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        ServerManager.SharedInstance().viewLead(custId: custId, clientId: clientId) { (isSuccessful, error, result) in
            
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
    
    class func createLead(isNewCustomer: String,programId: String,leadCustId: String,sourceBycode :String,custName: String,cityCode: String,stateCode: String,emailID: String,empEmailId :String,takerEmailId :String,custId: String,takerSolId :String,mobileNo :String,clientID: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        ServerManager.SharedInstance().createLead(isNewCustomer: isNewCustomer,programId: programId,sourceBycode: sourceBycode, leadCustId: leadCustId, custName: custName, cityCode: cityCode, stateCode: stateCode, emailID: emailID, empEmailId: empEmailId, takerEmailId: takerEmailId, custId: custId, takerSolId: takerSolId, mobileNo: mobileNo, clientID: clientID) { (isSuccessful, error, result) in
            
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
    
    class func getEmailIDFromSol(sol: String,custID: String,clientID: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        ServerManager.SharedInstance().getEmailIDFromSol(sol: sol, custID: custID, clientID: clientID) { (isSuccessful, error, result) in
            
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
    
    class func getCustomerDetails(ein: String,custID: String,clientID: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        ServerManager.SharedInstance().getCustomerDetails(ein: ein,custID: custID, clientID: clientID) { (isSuccessful, error, result) in
            print(result)
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
    
    class func getLeadClosureReasons(custID: String,clientID: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        ServerManager.SharedInstance().getLeadClosureReasons(custID: custID, clientID: clientID) { (isSucessful, error, result) in
            
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
    
    class func leadClose(custID: String,clientID: String,forceLeadId: String,status: String,remarks: String,amount: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        ServerManager.SharedInstance().leadClose(custID: custID, clientID: clientID, forceLeadId: forceLeadId, status: status, remarks: remarks,amount: amount) {
            (isSucessful, error, result) in
            
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
