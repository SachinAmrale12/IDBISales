//
//  ViewController.swift
//  IDBISales
//
//  Created by Amit Dhadse on 28/07/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit
import Alamofire
import ReachabilitySwift


class ViewController: UIViewController {

    @IBOutlet weak var loaderView               : UIView!
    @IBOutlet weak var userIdTextField          : RaisePlaceholder!
    @IBOutlet weak var passwordTextField        : RaisePlaceholder!
    @IBOutlet weak var loginButton              : UIButton!
    
    let networkReachability                     = Reachability()
    
    var keyForLoginCrendential                  : String!
    var clientID                                = "lmst"
    var loader                                  : MaterialLoadingIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       // let value = JNKeychain.value(forKey: "DummyNumber") as! String
      //  let key = JNKeychain.value(forKey: "DummyNumberReverse") as! String
        
       keyForLoginCrendential = DataManager.SharedInstance().getGlobalKey()
        
        userIdTextField.text = "129571"
        passwordTextField.text = "Pass@12345"
        self.navigationController?.navigationBar.isHidden = true
        self.commonInitialization()
        
    }

    //navigation
    
    @IBAction func loginClicked(_ sender: Any)
    {
        if userIdTextField.text?.isEmpty == true && passwordTextField.text?.isEmpty == true
        {
            self.AlertMessages(title: "Alert", message: "Please enter EIN and Password", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
        }
        else
        {
            if userIdTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == true
            {
                self.AlertMessages(title: "Alert", message: "Please enter EIN", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
            }
            else
            {
                if userIdTextField.text?.isEmpty == true && passwordTextField.text?.isEmpty == false
                {
                    self.AlertMessages(title: "Alert", message: "Please enter Password", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
                }
                else
                {
                    if (networkReachability?.isReachable)!
                    {
                        self.loaderView.isHidden = false
                        self.loader.startAnimating()
                        
                        let encryptedEINNumber = AESCrypt.encrypt(userIdTextField.text, password: keyForLoginCrendential).stringReplace()
                        print(encryptedEINNumber)
                        let encryptedPassword = AESCrypt.encrypt(passwordTextField.text, password: keyForLoginCrendential).stringReplace()
                        print(encryptedPassword)
                        let encryptedClientID = AESCrypt.encrypt(clientID, password: keyForLoginCrendential).stringReplace()
                        print(encryptedClientID)
                        let deviceIDforPushNotification = AESCrypt.encrypt("abc", password: keyForLoginCrendential).stringReplace()
                        print(deviceIDforPushNotification)
                        
                        DataManager.LoginUser(userName: encryptedEINNumber, clientID: encryptedClientID, pin: encryptedPassword, message: deviceIDforPushNotification, completionClouser: { (isSuccessful, error, result) in
                            
                           // self.loaderView.isHidden = true
                           // self.loader.stopAnimating()
                            
                            if isSuccessful
                            {
                                if let jsonResult = result as? Dictionary<String, String>
                                {
                                    if let test3 = jsonResult["error"]
                                    {
                                        let error = AESCrypt.decrypt(test3, password: self.keyForLoginCrendential) as String
                                        print(error)
                                        
                                        if error == "NA"
                                        {
                                            let value = AESCrypt.decrypt(jsonResult["value"], password: self.keyForLoginCrendential) as String
                                            let valueArray = value.components(separatedBy: "~")
                                            let userID = valueArray[0]
                                            let mobileNumber = valueArray[1]
                                            let emailID = valueArray[2]
                                            JNKeychain.saveValue(userID, forKey: "userID")
                                            JNKeychain.saveValue(mobileNumber, forKey: "mobileNumber")
                                            JNKeychain.saveValue(emailID, forKey: "emailID")
                                            let encryptedEmailId = AESCrypt.encrypt(emailID, password: DataManager.SharedInstance().getKeyForEncryption()).stringReplace()
                                            JNKeychain.saveValue(encryptedEmailId, forKey: "encryptedEmailId")
                                            
                                            let encryptionLey = DataManager.SharedInstance().getKeyForEncryption()
                                            
                                            let encrptedCustid = AESCrypt.encrypt(userID, password: self.keyForLoginCrendential).stringReplace()
                                            let encryptedClientId = AESCrypt.encrypt(self.clientID, password: encryptionLey).stringReplace()
                                            
                                            JNKeychain.saveValue(encrptedCustid, forKey: "encryptedCustID")
                                            JNKeychain.saveValue(encryptedClientId, forKey: "encryptedClientID")
                                            
                                            let reverseID = String((JNKeychain.loadValue(forKey: "userID") as! String).characters.reversed())
                                            let username = AESCrypt.encrypt("lmst" + "-" + userID, password: encryptionLey).stringReplace()
                                            
                                            //self.loaderView.isHidden = false
                                            //self.loader.startAnimating()
                                            
                                            DataManager.getAccessToken(custID: AESCrypt.encrypt(userID, password: self.keyForLoginCrendential).stringReplace(), clientID: AESCrypt.encrypt(self.clientID, password: encryptionLey).stringReplace(), pin: AESCrypt.encrypt(reverseID, password: encryptionLey).stringReplace(), username: username, clientSecret: AESCrypt.encrypt("2209@lms", password: encryptionLey).stringReplace(), completionClouser: { (isSuccessful, error, result) in
                                                
                                                self.loaderView.isHidden = true
                                                self.loader.stopAnimating()
                                                if isSuccessful
                                                {
                                                    if let jsonResult = result as? Dictionary<String, String>
                                                    {
                                                        print(jsonResult["error"]!)
                                                        let error = AESCrypt.decrypt(jsonResult["error"], password: encryptionLey) as String
                                                        if error == "NA"
                                                        {
                                                            let error = AESCrypt.decrypt(jsonResult["error"], password: encryptionLey) as String
                                                            
                                                            if error == "NA"
                                                            {
                                                                let accessToken = AESCrypt.decrypt(jsonResult["accessToken"], password: encryptionLey) as String
                                                                print(accessToken)
                                                                JNKeychain.saveValue(accessToken, forKey: "accessToken")
                                                                
                                                                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                                                                let contentVC = storyboard.instantiateViewController(withIdentifier: "firstVCIdentifier")
                                                                self.navigationController?.pushViewController(contentVC, animated: true)
                                                                let menuVC = storyboard.instantiateViewController(withIdentifier: "menuVC")
                                                                let options = MVYSideMenuOptions()
                                                                options.contentViewScale = 1.0
                                                                options.contentViewOpacity = 0.05
                                                                options.shadowOpacity = 0.0
                                                                let sideMenu1 = MVYSideMenuController(menuViewController: menuVC, contentViewController: contentVC, options: options)
                                                                sideMenu1?.menuFrame = CGRect(x: 0.0, y: 64.0, width: 228.0, height: self.view.bounds.size.height)
                                                                self.navigationController?.pushViewController(sideMenu1!, animated: false)
                                                            }
                                                            else
                                                            {
                                                                self.AlertMessages(title: "Error", message: error, actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
                                                            }
                                                        }
                                                        
                                                    }
                                                }
                                                else
                                                {
                                                    if let errorString = error
                                                    {
                                                        self.AlertMessages(title: "Error", message: errorString, actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
                                                    }
                                                }
                                                
                                            })
                                            
                                        }
                                        else
                                        {
                                            self.loaderView.isHidden = true
                                            self.loader.stopAnimating()
                                            self.AlertMessages(title: "Error", message: error, actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
                                        }
                                    }
                                    
                                }
                            }
                            else
                            {
                                if let errorString = error
                                {
                                     self.loaderView.isHidden = true
                                     self.loader.stopAnimating()
                                    self.AlertMessages(title: "Error", message: errorString, actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
                                }
                            }
                        })
                        
                    }
                    else
                    {
                        self.AlertMessages(title: "Internet connection Error", message: "Your Device is not Connect to \"Internet\"", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
                    }
                }
            }
        }
        
    }
    
    func commonInitialization()
    {
        
        self.loader = MaterialLoadingIndicator(frame: self.loaderView.bounds)
        self.loaderView.addSubview(loader)
        self.loaderView.isHidden = true
        
        userIdTextField.animationDuration = 0.5
        userIdTextField.subjectColor = UIColor.black
        userIdTextField.underLineColor = UIColor(red: (25.0/255.0), green: (111.0/255.0), blue: (61.0/255.0), alpha: 1.0)
        
        passwordTextField.animationDuration = 0.5
        passwordTextField.subjectColor = UIColor.black
        passwordTextField.underLineColor = UIColor(red: (25.0/255.0), green: (111.0/255.0), blue: (61.0/255.0), alpha: 1.0)
        
       // loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
       // loginButton.layer.borderColor = UIColor.orange.cgColor
       // loginButton.layer.borderWidth = 1
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

