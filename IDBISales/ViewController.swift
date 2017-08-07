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

    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var userIdTextField          : RaisePlaceholder!
    @IBOutlet weak var passwordTextField        : RaisePlaceholder!
    @IBOutlet weak var loginButton              : UIButton!
    let networkReachability             = Reachability()
    
    var keyForLoginCrendential                  : String!
    var clientID                                 = "lmst"
    var loader                     : MaterialLoadingIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       // let value = JNKeychain.value(forKey: "DummyNumber") as! String
      //  let key = JNKeychain.value(forKey: "DummyNumberReverse") as! String
        
       keyForLoginCrendential = DataManager.SharedInstance().getGlobalKey()
        
        userIdTextField.text = "129572"
        passwordTextField.text = "Pass@12345"
        self.navigationController?.navigationBar.isHidden = true
        self.commonInitialization()
        
    }

    //navigation
    
    @IBAction func loginClicked(_ sender: Any)
    {
        if (networkReachability?.isReachable)!
        {
            self.loaderView.isHidden = false
            self.loader.startAnimating()
            
            let encryptedEINNumber = AESCrypt.encrypt(userIdTextField.text, password: keyForLoginCrendential).replacingOccurrences(of: "/", with: ":~:")
            print(encryptedEINNumber)
            let encryptedPassword = AESCrypt.encrypt(passwordTextField.text, password: keyForLoginCrendential).replacingOccurrences(of: "/", with: ":~:")
            print(encryptedPassword)
            let encryptedClientID = AESCrypt.encrypt(clientID, password: keyForLoginCrendential).replacingOccurrences(of: "/", with: ":~:")
            print(encryptedClientID)
            let deviceIDforPushNotification = AESCrypt.encrypt("abc", password: keyForLoginCrendential).replacingOccurrences(of: "/", with: ":~:")
            print(deviceIDforPushNotification)
            
            DataManager.LoginUser(userName: encryptedEINNumber, clientID: encryptedClientID, pin: encryptedPassword, message: deviceIDforPushNotification, completionClouser: { (isSuccessful, error, result) in
                
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
                                
                                let encryptionLey = DataManager.SharedInstance().getKeyForEncryption()
                                
                                JNKeychain.saveValue(AESCrypt.encrypt(userID, password: self.keyForLoginCrendential).replacingOccurrences(of: "/", with: ":~:"), forKey: "encryptedCustID")
                                JNKeychain.saveValue(AESCrypt.encrypt(self.clientID, password: encryptionLey).replacingOccurrences(of: "/", with: ":~:"), forKey: "encryptedClientID")
                                
                                DataManager.getAccessToken(custID: AESCrypt.encrypt(userID, password: self.keyForLoginCrendential), clientID: AESCrypt.encrypt(self.clientID, password: encryptionLey), pin: AESCrypt.encrypt("275921", password: encryptionLey), username: AESCrypt.encrypt(self.clientID + "-" + userID, password: encryptionLey), clientSecret: AESCrypt.encrypt("2209@lms", password: encryptionLey), completionClouser: { (isSuccessful, error, result) in
                            
                                    self.loaderView.isHidden = true
                                    self.loader.stopAnimating()
                                    
                                    if isSuccessful
                                    {
                                        if let jsonResult = result as? Dictionary<String, String>
                                        {
                                            let error = AESCrypt.decrypt(jsonResult["error"], password: encryptionLey) as String
                                            if error == "NA"
                                            {
                                                let accessToken = AESCrypt.decrypt(jsonResult["accessToken"], password: encryptionLey) as String
                                                print(accessToken)
                                                JNKeychain.saveValue(accessToken, forKey: "accessToken")
                    
                                                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                                                let contentVC = storyboard.instantiateViewController(withIdentifier: "secondVC")
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
            self.AlertMessages(title: "Internet connection Error", message: "Your Device is not Connect to \"Internet\"", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
        }
        
    }
    
    func commonInitialization()
    {
        
        self.loader = MaterialLoadingIndicator(frame: self.loaderView.bounds)
        self.loaderView.addSubview(loader)
        self.loaderView.isHidden = true
        
        userIdTextField.animationDuration = 0.5
        userIdTextField.subjectColor = UIColor.orange
        userIdTextField.underLineColor = UIColor.orange
        
        passwordTextField.animationDuration = 0.5
        passwordTextField.subjectColor = UIColor.orange
        passwordTextField.underLineColor = UIColor.orange
        
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
        loginButton.layer.borderColor = UIColor.orange.cgColor
        loginButton.layer.borderWidth = 1
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

