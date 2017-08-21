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

    
    @IBOutlet weak var parrentRootView          : UIView!
    @IBOutlet weak var childRootView            : UIView!
    @IBOutlet weak var rootCheckButton          : UIButton!
    @IBOutlet weak var loaderViewContainer      : UIView!
    @IBOutlet weak var loaderView               : UIView!
    @IBOutlet weak var userIdTextField          : RaisePlaceholder!
    @IBOutlet weak var passwordTextField        : RaisePlaceholder!
    @IBOutlet weak var loginButton              : UIButton!
    
    @IBOutlet weak var showPasswordButton: UIButton!
    let networkReachability                     = Reachability()
    let jailBrokeCheck                          = JailBrokenDevice()
    
    var keyForLoginCrendential                  : String!
    var clientID                                = "lmst"
    var loader                                  : MaterialLoadingIndicator!
    var showHideButton                          : UIButton!
  //  let networkManager                          = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       // let value = JNKeychain.value(forKey: "DummyNumber") as! String
      //  let key = JNKeychain.value(forKey: "DummyNumberReverse") as! String
    
    //    self.testPinning()
        
        if jailBrokeCheck.isDeviceJailbroken()
        {
            if let testValue = UserDefaults.standard.value(forKey: "isRootPolicyAccepted")
            {
                if testValue as? String == "TermsConditionsAccepted"
                {
                     self.parrentRootView.isHidden = true
                }
            }
            else
            {
                self.parrentRootView.isHidden = false
            }
        }
        
        self.rootCheckButton.setBackgroundImage(UIImage(named: "uncheck.jpeg"), for: .normal)
        self.rootCheckButton.addTarget(self, action: #selector(self.rootCheckClicked), for: .touchUpInside)
        
        keyForLoginCrendential = DataManager.SharedInstance().getGlobalKey()
        userIdTextField.text = "129571"
        passwordTextField.text = "Pass@12345"
        self.navigationController?.navigationBar.isHidden = true
        self.commonInitialization()
        
    }
    
   
//    func testPinning()
//    {
//        let url = "http://10.144.118.20:1919/iBus/user/access/ {\"username\":\"wgttu29rqJtcQdR+DSac2w==\",\"pin\":\"2KivveN7s8is14VJ:~:3aNqA==\",\"clientId\":\"Is9I:~:Y5ops5uh8gB3oKJhw==\",\"clientSecret\":\"KRrIpLIAMe9Jd4IyjNGejg==\",\"custId\":\"aKpSY5Rdc7ulcImMDTFVtQ==\"}"
//        let requestParams = [String:Any]()
//        networkManager.manager?.request(url.addingPercentEscapes(using: .ascii)!,method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: [:]).response(completionHandler: { response in
//            
//             print(response)
//             print(response.response?.statusCode as Any)
//        })
//        
//        
////        networkManager.manager!.request(.GET, "http://10.144.118.20:1919/iBus/user/access/ {\"username\":\"wgttu29rqJtcQdR+DSac2w==\",\"pin\":\"2KivveN7s8is14VJ:~:3aNqA==\",\"clientId\":\"Is9I:~:Y5ops5uh8gB3oKJhw==\",\"clientSecret\":\"KRrIpLIAMe9Jd4IyjNGejg==\",\"custId\":\"aKpSY5Rdc7ulcImMDTFVtQ==\"}").response { response in
////            if response.1 != nil {
////                print("Success")
////                print(response.1)
////                print(response.1?.statusCode)
////            } else {
////                print("Error")
////                print(response.3)
////            }
////        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.userIdTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    func rootCheckClicked()
    {
        if self.rootCheckButton.backgroundImage(for: .normal) == UIImage(named: "check.jpeg")
        {
            self.rootCheckButton.setBackgroundImage(UIImage(named: "uncheck.jpeg"), for: .normal)
        }
        else
        {
            self.rootCheckButton.setBackgroundImage(UIImage(named: "check.jpeg"), for: .normal)
        }
    }
    
    @IBAction func rootDeviceDisagree(_ sender: Any)
    {
        let rootDeviceDisAgree = UIAlertController(title: "Warning", message: "Are you sure you want to discontinue with IDBI Sales Partner ?", preferredStyle: .alert)
        let noButton = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yesButton = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            
            let rootDeviceVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rootdeviceidentifier")
            self.present(rootDeviceVC, animated: true, completion: nil)
        }
        
        rootDeviceDisAgree.addAction(noButton)
        rootDeviceDisAgree.addAction(yesButton)
        self.present(rootDeviceDisAgree, animated: true, completion: nil)
    }
    
   
    @IBAction func rootDeviceAgree(_ sender: Any)
    {
        if rootCheckButton.backgroundImage(for: .normal) == UIImage(named: "check.jpeg")
        {
            UserDefaults.standard.set("TermsConditionsAccepted", forKey: "isRootPolicyAccepted")
            UserDefaults.standard.synchronize()
            self.parrentRootView.isHidden = true
            let defaults = UserDefaults.standard
            if defaults.object(forKey: "onlyonce") == nil
            {
                defaults.set("YES", forKey: "onlyonce")
            }
        }
        else
        {
            self.AlertMessages(title: "Jail Broken Device Alert", message: "Sorry, you have to accept Terms and Condition to continue with \"IDBI Sales Partner\" on Jail Broken device.", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
        }
        
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
            if userIdTextField.text?.isEmpty == true && passwordTextField.text?.isEmpty == false
            {
                self.AlertMessages(title: "Alert", message: "Please enter EIN", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
            }
            else
            {
                if userIdTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == true
                {
                    self.AlertMessages(title: "Alert", message: "Please enter Password", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
                }
                else
                {
                    if (networkReachability?.isReachable)!
                    {
                        self.loaderView.isHidden = false
                        self.loaderViewContainer.isHidden = false
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
                                                self.loaderViewContainer.isHidden = true
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
                                                                self.AlertMessages(title: "Error", message: error, actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: {(action) in
                                                                    
                                                                    self.userIdTextField.text = ""
                                                                    self.passwordTextField.text = ""
                                                                })
                                                            }
                                                        }
                                                        
                                                    }
                                                }
                                                else
                                                {
                                                    if let errorString = error
                                                    {
                                                        self.AlertMessages(title: "Error", message: errorString, actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: {(action) in
                                                            
                                                            self.userIdTextField.text = ""
                                                            self.passwordTextField.text = ""
                                                        })
                                                    }
                                                }
                                                
                                            })
                                            
                                        }
                                        else
                                        {
                                            self.loaderView.isHidden = true
                                            self.loaderViewContainer.isHidden = true
                                            self.loader.stopAnimating()
                                            self.AlertMessages(title: "Error", message: error, actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: {(action) in
                                                
                                                self.userIdTextField.text = ""
                                                self.passwordTextField.text = ""
                                            })
                                        }
                                    }
                                    
                                }
                            }
                            else
                            {
                                if let errorString = error
                                {
                                    
                                     self.loaderView.isHidden = true
                                    self.loaderViewContainer.isHidden = true
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
    
        showPasswordButton.setImage(UIImage(named: "hide.png"), for: .normal)
        
        self.loader = MaterialLoadingIndicator(frame: self.loaderView.bounds)
        self.loaderView.addSubview(loader)
        self.loaderViewContainer.isHidden = true
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.poptoRootViewController), name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)

    }
    
    
    //MARK: Show Hide Password Method
    
    @IBAction func showPasswordClicked(_ sender: Any)
    {
        if showPasswordButton.image(for: .normal) == UIImage(named: "hide.png")
        {
            self.passwordTextField.isSecureTextEntry = false
            showPasswordButton.setImage(UIImage(named: "show.png"), for: .normal)
        }
        else
        {
            self.passwordTextField.isSecureTextEntry = true
            showPasswordButton.setImage(UIImage(named: "hide.png"), for: .normal)
        }
    }
    
    //MARK: Notification method
    
    func poptoRootViewController()
    {
        self.AlertMessages(title: "Alert", message: "Seesion time out \n Please Login again.", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel)
        { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

