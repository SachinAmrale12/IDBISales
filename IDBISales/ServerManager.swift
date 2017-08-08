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
        print(urlString)
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser :completionClouser)
    }
    
    //http://10.144.118.20:1919/iBus/service/lead/createlead/{"isNewCustomer":"bfgdc:~:6vqCs0MRT aypwj8w==","prgId":"581xllT8xOfmUdd3:~:jSJ:*:g==","invstAmtEstmtd":"S5XrnXJEMUi9xG bsoyRzkA==","periodNumEstmtd":"S5XrnXJEMUi9xGbsoyRzkA==","periodUnitEstmtd":"HA mG4NBaMiPy:~:Mf2Rljdpw==","remarks":"yvSfDNcbRjYDCHjIEaxq0g==","sourceBycode":" KBePLD:*:yZHJERbjuzxMUUA==","campaignId":"0iQAdBp6nQJZVtSEsZqB6Q==","leadCus tId":"zN980EOX6LI:~:60vXkICkiw==","custName":"6915X0r0sexKdKkzSFOrPEuQmD0d4SbI 0uK4cQ42OvI=","address1":"WNqlzDCBvmsAJAMKD16St4Y3n5T:~:XBDrahi8UNQ3CNXW aVDV5zbS5ScJtDHNHQSb","address2":"TPpIfOGl:~:iF:*:VLz7m3pQIkUxJWIoVoYBKwxzn Q:*:1VA0=","pin":"DrxmlMagFdBOUlBGQu:*:dZw==","citycode":"mZLybM2eyAnzD7Huf:~: yMsw==","stateCode":"xjRix9EnoQYTh8NKKbFyqA==","emailId":"sI08WOZ6hf4X1WBT68l p:*:1kQzKvokLPZGGHhCCqAY1I=","telcell":"J5erLfEtu:~:vSt3sNrvTSyA==","phone1":"78V e77clJ:~:GMVkDqhCv2DA==","phone2":"78Ve77clJ:~:GMVkDqhCv2DA==","custId":"iDF3k QlXsEDx:~:fNQyHpKEA==","mobileNo":"P4AIvSqXGUOawxIqb2WN0g==","appointDt":"E WrWGnObxmc1WQzYsbYAIw==","empEmailId":"KLERYA4Gw8WzWEZ5kTbgvKVeW:*:Js DmF3XJhfwNY5PvU=","takerEmailId":"KLERYA4Gw8WzWEZ5kTbgvKVeW:*:JsDmF3XJhf wNY5PvU=","takerSolId":"EwWQLzTqVAE3R8Kp:*:0QbXw==","centerCode":"gIDFgjsEmZi 7iRlIHGznzg==","clientId":"N06PaZ0IvkdcmiLfH3vmBg=="}?access_token=7994bcf5-f578- 4531-bf1f-5d35805bef03
    
    func createLead(programId: String,sourceBycode :String,custName: String,cityCode: String,stateCode: String,emailID: String,empEmailId :String,takerEmailId :String,custId: String,takerSolId :String,mobileNo :String,clientID: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        let encryptedValue = AESCrypt.encrypt("false", password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
        let encryptedNA = AESCrypt.encrypt("NA", password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
        let encryptedCenterCode = AESCrypt.encrypt("1", password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
        
        let urlString = "http://10.144.118.20:1919/iBus/service/lead/createlead/{\"isNewCustomer\":\"\(encryptedValue)\",\"prgId\":\"\(programId)\",\"invstAmtEstmtd\":\"\(encryptedNA)\",\"periodNumEstmtd\":\"\(encryptedNA)\",\"periodUnitEstmtd\":\"\(encryptedNA)\",\"remarks\":\"\(encryptedNA)\",\"sourceBycode\":\"\(sourceBycode)\",\"campaignId\":\"\(encryptedNA)\",\"leadCustId\":\"\(encryptedNA)\",\"custName\":\"\(custName)\",\"address1\":\"\(encryptedNA)\",\"address2\":\"\(encryptedNA)\",\"pin\":\"\(encryptedNA)\",\"citycode\":\"\(cityCode)\",\"stateCode\":\"\(stateCode)\",\"emailId\":\"\(emailID)\",\"telcell\":\"\(encryptedNA)\",\"phone1\":\"\(encryptedNA)\",\"phone2\":\"\(encryptedNA)\",\"custId\":\"\(custId)\",\"mobileNo\":\"\(mobileNo)\",\"appointDt\":\"\(encryptedNA)\",\"empEmailId\":\"\(empEmailId)\",\"takerEmailId\":\"\(takerEmailId)\",\"takerSolId\":\"\(takerSolId)\",\"centerCode\":\"\(encryptedCenterCode)\",\"clientId\":\"\(clientID)\"}?access_token=\(JNKeychain.loadValue(forKey: "accessToken")!)"
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
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser :completionClouser)
    }
    
    func LoginUser(userName: String,clientID: String,pin: String,message: String,completionClouser:@escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    {
        let urlString = "http://10.144.118.20:1919/iBus/register/ldapLogin/" + "{\"username\":\"\(userName)\",\"pin\":\"\(pin)\",\"clientId\":\"\(clientID)\",\"message\":\"\(message)\"}"
        let url = urlString.addingPercentEscapes(using: .ascii)
        self.webServiceCall(url: url!, completionClouser :completionClouser)
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
                        print("Error\(response.result.description)")
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
