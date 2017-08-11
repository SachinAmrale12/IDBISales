//
//  AssignLeadViewController.swift
//  IDBISales
//
//  Created by Amit Dhadse on 10/08/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit
import ReachabilitySwift

class AssignLeadViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,LUAutocompleteViewDelegate,LUAutocompleteViewDataSource {

    private let autocompleteView                            = LUAutocompleteView()
    private let autocompleteViewForCity                     = LUAutocompleteView()
    private let autocompleteViewForBranch                   = LUAutocompleteView()

    let networkReachability             = Reachability()
    var loader                          : MaterialLoadingIndicator!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet var takerMailID           : UITextField!
    @IBOutlet var branchTextField       : UITextField!
    @IBOutlet var stateTextField        : UITextField!
    @IBOutlet var cityTextField         : UITextField!
    @IBOutlet var remarkTextView        : UITextView!
    @IBOutlet var assignButton          : UIButton!
    var picker                                             = CZPickerView()
    var emailArray                                          = [String]()
    
    var allStateDictionary                                  = [String:String]()
    var allCityDictionary                                   = [String:String]()
    var allBranchDictionary                                 = [String:String]()
    var solID                           : String!
    var encryptedLead                   : String!
    
    @IBAction func backButtonClicked(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.commonInitialization()

        // Do any additional setup after loading the view.
    }
    
    //MARK:  commonInitialization
    
    func commonInitialization()
    {
        self.loader = MaterialLoadingIndicator(frame: self.loaderView.bounds)
        self.loaderView.addSubview(loader)
        self.loaderView.isHidden = true
        
        stateTextField.drawUnderLineForTextField()
        cityTextField.drawUnderLineForTextField()
        branchTextField.drawUnderLineForTextField()
        takerMailID.drawUnderLineForTextField()
        
        assignButton.layer.cornerRadius = assignButton.frame.size.height / 2
        assignButton.layer.borderColor = UIColor.orange.cgColor
        assignButton.layer.borderWidth = 1
        
        remarkTextView.layer.cornerRadius = 1
        remarkTextView.layer.borderColor = UIColor.orange.cgColor
        remarkTextView.layer.borderWidth = 1
        
    }
    
    //MARK: textfield delegate
    
    @IBAction func assignButtonClicked(_ sender: Any)
    {
        if (networkReachability?.isReachable)!
        {
            self.loaderView.isHidden = false
            self.loader.startAnimating()
            
            let encryptedRemark = AESCrypt.encrypt(self.remarkTextView.text, password: DataManager.SharedInstance().getKeyForEncryption()).stringReplace()
            let encryptedMail = AESCrypt.encrypt(self.takerMailID.text, password: DataManager.SharedInstance().getKeyForEncryption()).stringReplace()
            let encryptedSolID = AESCrypt.encrypt(self.solID, password: DataManager.SharedInstance().getKeyForEncryption()).stringReplace()
            print(self.encryptedLead)
            let encryptedlead = AESCrypt.encrypt(self.encryptedLead, password: DataManager.SharedInstance().getKeyForEncryption()).stringReplace()
            
            DataManager.assignLead(tranLeadId: encryptedlead, giverEmail: JNKeychain.loadValue(forKey: "encryptedEmailId") as! String, giverRemarks: encryptedRemark, takerEmail: encryptedMail, takerSol: encryptedSolID, custId: JNKeychain.loadValue(forKey: "encryptedCustID") as! String, clientId: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, completionClouser: { (isSuccessful, error, result) in
                
                self.loaderView.isHidden = true
                self.loader.stopAnimating()
                
                if isSuccessful
                {
                    if let element = result as? NSDictionary
                    {
                        print(element)
                        if let error = element["error"]
                        {
                            if !(error is NSNull)
                            {
                                let error = AESCrypt.decrypt(error as! String, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                print(error)
                                if error == "NA"
                                {
                                    if let value = element["value"]
                                    {
                                        let value = AESCrypt.decrypt(value as! String, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                        print(value)
                                    }
                                    if let message = element["message"]
                                    {
                                        let message = AESCrypt.decrypt(message as! String, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                        print(message)
                                    }
                                }
                                else
                                {
                                    self.AlertMessages(title: "Error", message: error, actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
                                    return
                                }
                            }
                            else
                            {
                                self.AlertMessages(title: "Error", message: "Please Try Again", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
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
   
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == stateTextField
        {
            if self.allStateDictionary.count == 0
            {
                if (networkReachability?.isReachable)!
                {
                    self.loaderView.isHidden = false
                    self.loader.startAnimating()
                    DataManager.getStates(custID: JNKeychain.loadValue(forKey: "encryptedCustID") as! String, clientID: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, completionClouser: { (isSuccessful, error, result) in
                        
                        self.loaderView.isHidden = true
                        self.loader.stopAnimating()
                        
                        if isSuccessful
                        {
                            if let jsonResult = result as? Array<Dictionary<String, String>>
                            {
                                for data in jsonResult
                                {
                                    let value = AESCrypt.decrypt(data["refdesc"], password: DataManager.SharedInstance().getKeyForEncryption())
                                    let value2 = AESCrypt.decrypt(data["refCode"], password: DataManager.SharedInstance().getKeyForEncryption())
                                    self.allStateDictionary.updateValue(value2!, forKey: value!)
                                }
                                
                                self.view.addSubview(self.autocompleteView)
                                self.autocompleteView.textField = self.stateTextField
                                self.autocompleteView.dataSource = self
                                self.autocompleteView.delegate = self
                                self.autocompleteView.rowHeight = 45
                                
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
                    return true
                }
                else
                {
                    self.AlertMessages(title: "Internet connection Error", message: "Your Device is not Connect to \"Internet\"", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
                }
            }
            
            return true
        }
       
        
        return true
    }

    
    // MARK: - LUAutocompleteView Methods
    
    func autocompleteView(_ autocompleteView: LUAutocompleteView, elementsFor text: String, completion: @escaping ([String]) -> Void)
    {
        if autocompleteView.textField == self.stateTextField
        {
            let elementsThatMatchInput = Array(self.allStateDictionary.keys).filter { $0.lowercased().contains(text.lowercased()) }
            completion(elementsThatMatchInput)
        }
        else if autocompleteView.textField == self.cityTextField
        {
            let elementsThatMatchInput = Array(self.allCityDictionary.keys).filter { $0.lowercased().contains(text.lowercased()) }
            completion(elementsThatMatchInput)
        }
        else if autocompleteView.textField == self.branchTextField
        {
            let elementsThatMatchInput = Array(self.allBranchDictionary.keys).filter { $0.lowercased().contains(text.lowercased()) }
            completion(elementsThatMatchInput)
        }
    }
    
    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        
        self.view.endEditing(true)
        if autocompleteView.textField == self.stateTextField
        {
            self.cityTextField.text = ""
            self.branchTextField.text = ""
            if (networkReachability?.isReachable)!
            {
                self.loaderView.isHidden = false
                self.loader.startAnimating()
                DataManager.getCities(custID: JNKeychain.loadValue(forKey: "encryptedCustID") as! String, clientID: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, message: AESCrypt.encrypt(self.allStateDictionary[text]!, password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:"), completionClouser: { (isSuccessful, error, result) in
                    self.loaderView.isHidden = true
                    self.loader.stopAnimating()
                    if isSuccessful
                    {
                        self.allCityDictionary.removeAll(keepingCapacity: false)
                        if let jsonResult = result as? Array<Dictionary<String, String>>
                        {
                            for data in jsonResult
                            {
                                let value = AESCrypt.decrypt(data["refdesc"], password: DataManager.SharedInstance().getKeyForEncryption())
                                let value2 = AESCrypt.decrypt(data["refCode"], password: DataManager.SharedInstance().getKeyForEncryption())
                                self.allCityDictionary.updateValue(value2!, forKey: value!)
                            }
                            
                            self.view.addSubview(self.autocompleteViewForCity)
                            self.autocompleteViewForCity.textField = self.cityTextField
                            self.autocompleteViewForCity.dataSource = self
                            self.autocompleteViewForCity.delegate = self
                            self.autocompleteViewForCity.rowHeight = 45
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
        else if autocompleteView.textField == self.cityTextField
        {
            self.branchTextField.text = ""
            if (networkReachability?.isReachable)!
            {
                self.loaderView.isHidden = false
                self.loader.startAnimating()
                DataManager.getBranches(custID: JNKeychain.loadValue(forKey: "encryptedCustID") as! String, clientID: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, message: AESCrypt.encrypt(self.allCityDictionary[text]!, password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:"), completionClouser: { (isSuccessful, error, result) in
                    self.loaderView.isHidden = true
                    self.loader.stopAnimating()
                    if isSuccessful
                    {
                        if let jsonResult = result as? Array<Dictionary<String, String>>
                        {
                            for data in jsonResult
                            {
                                let solID = AESCrypt.decrypt(data["solId"], password: DataManager.SharedInstance().getKeyForEncryption())
                                // let stateCode = AESCrypt.decrypt(data["stateCode"], password: DataManager.SharedInstance().getKeyForEncryption())
                                // let cityCode = AESCrypt.decrypt(data["cityCode"], password: DataManager.SharedInstance().getKeyForEncryption())
                                let solDesc = AESCrypt.decrypt(data["solDesc"], password: DataManager.SharedInstance().getKeyForEncryption())
                                self.allBranchDictionary.updateValue(solID!, forKey: solDesc!)
                            }
                            
                            self.view.addSubview(self.autocompleteViewForBranch)
                            self.autocompleteViewForBranch.textField = self.branchTextField
                            self.autocompleteViewForBranch.dataSource = self
                            self.autocompleteViewForBranch.delegate = self
                            self.autocompleteViewForBranch.rowHeight = 45
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
        else if autocompleteView.textField == self.branchTextField
        {
            if (networkReachability?.isReachable)!
            {
                self.loaderView.isHidden = false
                self.loader.startAnimating()
                
                self.solID = self.allBranchDictionary[text]!
                
                DataManager.getEmailIDFromSol(sol: AESCrypt.encrypt(self.allBranchDictionary[text]!, password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:"), custID: JNKeychain.loadValue(forKey: "encryptedCustID") as! String, clientID: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, completionClouser: { (isSuccessful, error, result) in
                    
                    self.loaderView.isHidden = true
                    self.loader.stopAnimating()
                    if isSuccessful
                    {
                        
                        for element in result as! Array<AnyObject>
                        {
                            let data = element as! Dictionary<String, Any>
                            let emailId = AESCrypt.decrypt(data["emailId"] as! String, password: DataManager.SharedInstance().getKeyForEncryption())
                            self.emailArray.append(emailId!)
                        }
                        
                        if self.emailArray.count > 0
                        {
                            //                            self.assignTextView.text = self.emailArray[0]
                            //                            self.takerEmailID = self.assignTextView.text
                            
                            self.picker = CZPickerView(headerTitle: "Products", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
                            self.picker.tag = 2
                            self.picker.delegate = self
                            self.picker.dataSource = self
                            self.picker.needFooterView = false
                            self.picker.allowMultipleSelection = false
                            self.picker.show()
                            
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
        
    }
    
    ////MARK: textfield delegate
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        return true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension AssignLeadViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        //if pickerView == pickerWithImage {
        //     return fruitImages[row]
        // }
        return nil
    }
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int
    {
        return self.emailArray.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String!
    {
        return Array(self.emailArray)[row]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.takerMailID.text = self.emailArray[row]
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!)
    {
    }
}


