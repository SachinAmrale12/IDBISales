//
//  ViewController.swift
//  IDBISales
//
//  Created by Amit Dhadse on 28/07/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var userIdTextField          : RaisePlaceholder!
    @IBOutlet weak var passwordTextField        : RaisePlaceholder!
    @IBOutlet weak var loginButton              : UIButton!
    
    
    var keyForLoginCrendential                  : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
      // keyForLoginCrendential=AESCrypt.encrypt(JNKeychain.value(forKey: "DummyNumber") as! String, password: JNKeychain.value(forKey: "DummyNumberReverse") as! String)
        
        
        self.navigationController?.navigationBar.isHidden = true
        self.commonInitialization()
        
    }

    //navigation
    
    @IBAction func loginClicked(_ sender: Any)
    {
        
      //  let encryptedEINNumber = AESCrypt.encrypt("", password: keyForLoginCrendential)
    //    let encryptedPassword = AESCrypt.encrypt("", password: keyForLoginCrendential)
    //    let deviceIDforPushNotification = AESCrypt.encrypt("", password: keyForLoginCrendential)
      //  let
     //    let urlString = ""
        
     //   let url = urlString.addingPercentEscapes(using: .ascii)
        
        
        //http://localhost:8080/AbhayCard/register/ldapLogin/{"username":"YuqLeXfu6ESSYNQRjh9g==","pin":":*:T5bctRG3wVxsbqYeIeA ==","clientId":"tzLonXeVMWmyi1reRhqw==","message":"wG:*:4epyCFCMmjFXcswcg=="}
        
//        Alamofire.request(
//            "",
//            method: .get,
//            parameters: nil)
//            .validate()
//            .responseJSON{
//                (response) in
//                if response.result.error == nil
//                {
//                    if response.result.isSuccess
//                    {
//                        print(response.description)
//                        do {
//                            let dictionary = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
//                            //print(dictionary)
//                        }
//                        catch
//                        {}
//                        return
//                    }
//                    else
//                    {
//                        //  print("Error\(response.result.description)")
//                    }
//                }
//                else
//                {
//                }
//        }

    
        
        
        
        
        
        
        
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
    
    func commonInitialization()
    {
        
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

