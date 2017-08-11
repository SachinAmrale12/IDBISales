//
//  ServerManager.swift
//  IDBISales
//
//  Created by Sachin Amrale on 03/08/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//


import UIKit
import Alamofire


class ServerManager: NSObject {
    
    class func SharedInstance() -> ServerManager
    {
        struct serverStuct
        {
            static let sharedInstance = ServerManager()
        }
        return serverStuct.sharedInstance
    }
    
    
    func createAppointment(tranLeadId: String,takerEmail: String,appointmentDt: String,appmntRemarks: String,custId: String,clientId: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        let urlString = "http://10.144.118.20:1919/iBus/service/lead/createappointment/{\"tranLeadId\":\"\(tranLeadId)\",\"giverEmail\":\"\(takerEmail)\",\"appointmentDt\":\"\(appointmentDt)\",\"appmntRemarks\":\"\(appmntRemarks)\",\"custId\":\"\(custId)\",\"clientId\":\"\(clientId)\"}?access_token=\(JNKeychain.loadValue(forKey: "accessToken")!)"
        print(urlString)
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser :completionClouser)
    }
    
    func assignLead(tranLeadId: String,giverEmail: String,giverRemarks: String,takerEmail: String,takerSol: String,custId: String,clientId: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        let urlString = "http://10.144.118.20:1919/iBus/service/lead/reassignlead/{\"tranLeadId\":\"\(tranLeadId)\",\"giverEmail\":\"\(giverEmail)\",\"giverRemarks\":\"\(giverRemarks)\",\"takerEmail\":\"\(takerEmail)\",\"takerSol\":\"\(takerSol)\",\"custId\":\"\(custId)\",\"clientId\":\"\(clientId)\",}?access_token=\(JNKeychain.loadValue(forKey: "accessToken")!)"
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser :completionClouser)
    }
    
    func getReports(ein: String,clientId: String,flg: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        let urlString = "http://10.144.118.20:1919/iBus/service/lead/createReport/{\"ein\":\"\(ein)\",\"clientId\":\"\(clientId)\",\"flg\":\"\(flg)\"}?access_token=\(JNKeychain.loadValue(forKey: "accessToken")!)"
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser :completionClouser)
    }
    
    //http://10.144.118.20:1919/iBus/service/lead/viewleads/{"custId":"mScay6eDRV9ZEDfOvyzQ==","clientId":"zL:~:N6QQzWpdZESs6aSbA=="}
    
    func viewLead(custId: String,clientId: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        let urlString = "http://10.144.118.20:1919/iBus/service/lead/viewleads/{\"custId\":\"\(custId)\",\"clientId\":\"\(clientId)\"}?access_token=\(JNKeychain.loadValue(forKey: "accessToken")!)"
        print(urlString)
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser :completionClouser)
    }
    
    
   //http://10.144.118.20:1919/iBus/service/leadcampaignlist/chmpidname/{"custId":"iDF3kQlXsED x:~:fNQyHpKEA==","clientId":"N06PaZ0IvkdcmiLfH3vmBg=="}?access_token=
    
   // func getCampaign
    
    func getEmailIDFromSol(sol: String,custID: String,clientID: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        let urlString = "http://10.144.118.20:1919/iBus/service/hrms/mailid/{\"sol\":\"\(sol)\",\"custId\":\"\(custID)\",\"clientId\":\"\(clientID)\"}?access_token=\(JNKeychain.loadValue(forKey: "accessToken")!)"
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser :completionClouser)
    }
    
    func getCustomerDetails(ein: String,custID: String,clientID: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        let urlString = "http://10.144.118.20:1919/iBus/service/customer/details/{\"ein\":\"\(ein)\",\"custId\":\"\(custID)\",\"clientId\":\"\(clientID)\"}?access_token=\(JNKeychain.loadValue(forKey: "accessToken")!)"
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser :completionClouser)
    }
    
    
    func createLead(isNewCustomer: String,programId: String,sourceBycode :String,leadCustId: String,custName: String,cityCode: String,stateCode: String,emailID: String,empEmailId :String,takerEmailId :String,custId: String,takerSolId :String,mobileNo :String,clientID: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        
        let encryptedNA = AESCrypt.encrypt("NA", password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
        let encryptedCenterCode = AESCrypt.encrypt("1", password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
        let encryptedNumricCode = AESCrypt.encrypt("0", password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
        
        let urlString = "http://10.144.118.20:1919/iBus/service/lead/createlead/{\"isNewCustomer\":\"\(isNewCustomer)\",\"prgId\":\"\(programId)\",\"invstAmtEstmtd\":\"\(encryptedNumricCode)\",\"periodNumEstmtd\":\"\(encryptedNumricCode)\",\"periodUnitEstmtd\":\"\(encryptedNumricCode)\",\"remarks\":\"\(encryptedNA)\",\"sourceBycode\":\"\(sourceBycode)\",\"campaignId\":\"\(encryptedNumricCode)\",\"leadCustId\":\"\(leadCustId)\",\"custName\":\"\(custName)\",\"address1\":\"\(encryptedNA)\",\"address2\":\"\(encryptedNA)\",\"pin\":\"\(encryptedNumricCode)\",\"citycode\":\"\(cityCode)\",\"stateCode\":\"\(stateCode)\",\"emailId\":\"\(emailID)\",\"telcell\":\"\(encryptedNumricCode)\",\"phone1\":\"\(encryptedNumricCode)\",\"phone2\":\"\(encryptedNumricCode)\",\"custId\":\"\(custId)\",\"mobileNo\":\"\(mobileNo)\",\"appointDt\":\"\(encryptedNA)\",\"empEmailId\":\"\(empEmailId)\",\"takerEmailId\":\"\(takerEmailId)\",\"takerSolId\":\"\(takerSolId)\",\"centerCode\":\"\(encryptedCenterCode)\",\"clientId\":\"\(clientID)\"}?access_token=\(JNKeychain.loadValue(forKey: "accessToken")!)"
        print(urlString)
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser :completionClouser)
    }
    
    func getProgrammList(custID: String,clientID: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        let urlString = "http://10.144.118.20:1919/iBus/service/leadpgmlist/{\"custId\":\"\(custID)\",\"clientId\":\"\(clientID)\"}?access_token=\(JNKeychain.loadValue(forKey: "accessToken")!)"
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser :completionClouser)
    }
    
    func getBranches(custID: String,clientID: String,message: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        let urlString = "http://10.144.118.20:1919/iBus/service/LMSTData/getBranches/{\"custId\":\"\(custID)\",\"clientId\":\"\(clientID)\",\"message\":\"\(message)\"}?access_token=\(JNKeychain.loadValue(forKey: "accessToken")!)"
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser :completionClouser)
    }
    
    func getCities(custID: String,clientID: String,message: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        let urlString = "http://10.144.118.20:1919/iBus/service/LMSTData/getCities/{\"custId\":\"\(custID)\",\"clientId\":\"\(clientID)\",\"message\":\"\(message)\"}?access_token=\(JNKeychain.loadValue(forKey: "accessToken")!)"
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser :completionClouser)
    }
    
    func getStates(custID: String,clientID: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        let urlString = "http://10.144.118.20:1919/iBus/service/LMSTData/getStates/{\"custId\":\"\(custID)\",\"clientId\":\"\(clientID)\"}?access_token=\(JNKeychain.loadValue(forKey: "accessToken")!)"
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser :completionClouser)
    }
    
    func getAccessToken(custID: String,clientID: String,pin :String,username: String,clientSecret: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        let urlString = "http://10.144.118.20:1919/iBus/user/access/" + "{\"custId\":\"\(custID)\",\"clientId\":\"\(clientID)\", \"pin\":\"\(pin)\",\"username\":\"\(username)\",\"clientSecret\":\"\(clientSecret)\"}"
        print(urlString)
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser :completionClouser)
    }
    
    func LoginUser(userName: String,clientID: String,pin: String,message: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        let urlString = "http://10.144.118.20:1919/iBus/register/ldapLogin/" + "{\"username\":\"\(userName)\",\"pin\":\"\(pin)\",\"clientId\":\"\(clientID)\",\"message\":\"\(message)\"}"
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser :completionClouser)
    }
    
    // MARK: Closure Option web service
    
    func getLeadClosureReasons(custID: String,clientID: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        let urlString = "http://10.144.118.20:1919/iBus/service/LMSTData/mstidname/" + "{\"custId\":\"\(custID)\",\"clientId\":\"\(clientID)\"}?access_token=\(JNKeychain.loadValue(forKey: "accessToken")!)"
        
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser: completionClouser)
    }
    
    func leadClose(custID: String,clientID: String,forceLeadId: String,status: String,remarks:String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        let urlString = "http://10.144.118.20:1919/iBus/service/lead/closelead/" + "{\"custId\":\"\(custID)\",\"clientId\":\"\(clientID)\",\"forceLeadId\":\"\(forceLeadId)\",\"status\":\"\(status)\",\"remarks\":\"\(remarks)\"}?access_token=\(JNKeychain.loadValue(forKey: "accessToken")!)"
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser: completionClouser)
    }
    
    func webServiceCall(url :String,completionClouser :@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        
        Alamofire.request(
            url,
            method: .get,
            parameters: nil)
            .validate()
            .responseJSON{
                (response) in
                if response.result.error == nil
                {
                    if response.result.isSuccess
                    {
                        do {
                            let dictionary = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                            completionClouser(response.result.isSuccess,nil,dictionary)
                        }
                        catch
                        {}
                        return
                    }
                    else
                    {
                        completionClouser(response.result.isSuccess,response.error as? String,nil)
                    }
                }
                else
                {
                    completionClouser(response.result.isSuccess,response.error?.localizedDescription,nil)
                }
        }
        
    }

}
