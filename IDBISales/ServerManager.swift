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
    
    //func registerNewUser(custID: String ,withMobile: String ,withClientSecret: String ,withClientID: String, completionClouser: @escaping (_ isSuccessful: Bool,_ error: String?,_ result: Any?) -> Void)
    
    
//    func loginFromBankEmployee(userName : String,withPin : String,withClientID : String, withMessage : String,completionClouser :(isSucessful : Bool,error : String,result : Any)) -> Void
//    {
//        self.webServiceCall(url: "", completionClouser: completionClouser)
//    }
//    
    
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
                        print(response.description)
                        do {
                            let dictionary = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                            //print(dictionary)
                            completionClouser(response.result.isSuccess,nil,dictionary)
                        }
                        catch
                        {}
                        return
                    }
                    else
                    {
                        //  print("Error\(response.result.description)")
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
