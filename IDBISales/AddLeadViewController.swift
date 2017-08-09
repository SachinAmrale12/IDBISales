//
//  AddLeadViewController.swift
//  IDBISales
//
//  Created by Sachin Amrale on 01/08/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit
import ReachabilitySwift
import TNCheckBoxGroup

class AddLeadViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,LUAutocompleteViewDelegate,LUAutocompleteViewDataSource,UITextViewDelegate{
    
    
    @IBOutlet weak var nonCustomerRadioButton               : DLRadioButton!
    @IBOutlet weak var customerRadioButton                  : DLRadioButton!
    @IBOutlet weak var checkBoxContainerView: UIView!
    @IBOutlet weak var checkBoxView                         : UIView!
    @IBOutlet weak var programmTextView                     : UITextView!
    var loader                                              : MaterialLoadingIndicator!
    @IBOutlet weak var loaderView                           : UIView!
    @IBOutlet weak var mainCustomerView                     : UIView!
    @IBOutlet weak var containerViewHeightConstarint        : NSLayoutConstraint!
    @IBOutlet weak var custIDTextfieldHeightConstraint      : NSLayoutConstraint!
    @IBOutlet weak var stateTextfield                       : UITextField!
    @IBOutlet weak var cityTextfield                        : UITextField!
    @IBOutlet weak var branchTextfield                      : UITextField!
    @IBOutlet weak var firstNameTextfield                   : RaisePlaceholder!
    @IBOutlet weak var mobileNoTextfield                    : RaisePlaceholder!
    @IBOutlet weak var emailIdTextfield                     : RaisePlaceholder!
    @IBOutlet weak var contactTimeTextfield                 : RaisePlaceholder!
    @IBOutlet weak var ageTextfield                         : RaisePlaceholder!
    @IBOutlet weak var customerIDTextfield                  : RaisePlaceholder!
    
    let networkReachability                                 = Reachability()
    var allStateDictionary                                  = [String:String]()
    var allCityDictionary                                   = [String:String]()
    var allBranchDictionary                                 = [String:String]()
    var allProgrammDictionary                               = [String:String]()
    
    var preferredTimeArray                                  = ["10AM-12PM","12PM-2PM","2PM-4PM","4PM-6PM"]
    var ageArray                                            = ["0-17","18-24","25-34","35-44","45-60","60+"]
    var Products                                            = [String]()
    var testPicker                                          : UIPickerView!
    var isBool                                              : Bool!
    private let autocompleteView                            = LUAutocompleteView()
    private let autocompleteViewForCity                     = LUAutocompleteView()
    private let autocompleteViewForBranch                   = LUAutocompleteView()
    var isCustomer                                          : Bool!
  // var productList                                          = [String]()
    
    
    var takerEmailID                                        : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.commonInitialization()
        
        // Do any additional setup after loading the view.
    }
    
    func commonInitialization()
    {
       
       // self.firstNameTextfield.text = "amit dhadse"
       // self.mobileNoTextfield.text = "8956128383"
       // self.emailIdTextfield.text = "sachin9083@gmail.com"
        
        self.takerEmailID = ""
        
       // checkBoxView.backgroundColor = UIColor(red: (255.0/255.0), green: (255.0/255.0), blue: (255.0/255.0), alpha: 1.0)
        programmTextView.layer.borderColor = UIColor.orange.cgColor
        programmTextView.layer.borderWidth = 1
        
        self.loader = MaterialLoadingIndicator(frame: self.loaderView.bounds)
        self.loaderView.addSubview(loader)
        self.loaderView.isHidden = true
        
        Products = ["Agri Loan", "Auto Loan", "Being My Account", "Capital Gain Account", "Cash Card","Corporate Salary Account","Credit Card","Dealer Finance","DeMat Account","Education Loan","Flexi Current Account","Floating Rate Term Account","Gift Card","Godhuli Retail Term Deposite","Home Loan","Jublee Plus(Senior Citizen) Account","Loan Against Property","Loan Against Securities","Mutual Funds","National Pension Scheme","Personal Loan","Power Kids Account","Recurring Deposite","Reverse Mortgage Loan","Sabka Savings Account","Savings Account","Super Shakti Womens","Suvidha Fix Deposite","Suvidha Suraksha Recurring Deposite","Trader Finance","Word Currency Card"]
        
        self.stateTextfield.delegate = self
        
      //  contactTimeTextfield.delegate = self
      //  ageTextfield.delegate = self
        
        testPicker = UIPickerView(frame: CGRect(x: 0, y: self.view.frame.size.height - 216, width: self.view.frame.size.width, height: 216))
        testPicker.backgroundColor = UIColor.white
        testPicker.layer.borderColor = UIColor.orange.cgColor
        testPicker.layer.borderWidth = 1
        testPicker.delegate = self
        testPicker.dataSource = self
        
        //        let toolBar = UIToolbar()
        //        toolBar.barStyle = UIBarStyle.default
        //        toolBar.isTranslucent = true
        //        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        //        toolBar.sizeToFit()
        //
        //        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donePicker))
        //        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        //        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelPicker))
        //
        //        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        //        toolBar.isUserInteractionEnabled = true
        
      //  self.contactTimeTextfield.inputView = testPicker
      //  self.ageTextfield.inputView = testPicker
        //    self.contactTimeTextfield.inputAccessoryView = toolBar
        
        firstNameTextfield.animationDuration = 0.5
        firstNameTextfield.subjectColor = UIColor.orange
        firstNameTextfield.underLineColor = UIColor.orange
        
        mobileNoTextfield.animationDuration = 0.5
        mobileNoTextfield.subjectColor = UIColor.orange
        mobileNoTextfield.underLineColor = UIColor.orange
        
        emailIdTextfield.animationDuration = 0.5
        emailIdTextfield.subjectColor = UIColor.orange
        emailIdTextfield.underLineColor = UIColor.orange
        
        stateTextfield.drawUnderLineForTextField()
        cityTextfield.drawUnderLineForTextField()
        branchTextfield.drawUnderLineForTextField()
        
        
        // checkmark
        customerRadioButton.isSelected = true
        
        // customer ID textfiled
        
        customerIDTextfield.animationDuration = 0.5
        customerIDTextfield.subjectColor = UIColor.orange
        customerIDTextfield.underLineColor = UIColor.orange
              
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func SelectTypeOfCustomer(_ sender: DLRadioButton)
    {
        if sender == customerRadioButton
        {
            isCustomer = true
            customerRadioButton.isSelected = true
            nonCustomerRadioButton.isSelected = false
            customerIDTextfield.isHidden = false
            custIDTextfieldHeightConstraint.constant = 40
            containerViewHeightConstarint.constant = 240
        }
        else
        {
            isCustomer = false
            customerRadioButton.isSelected = false
            nonCustomerRadioButton.isSelected = true
            customerIDTextfield.isHidden = true
            custIDTextfieldHeightConstraint.constant = 0
            containerViewHeightConstarint.constant = 200
            
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any)
    {
        if firstNameTextfield.text == ""
        {
            self.AlertMessages(title: "Error", message: "Please Select Name", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
            return
        }
        
        if mobileNoTextfield.text == ""
        {
            self.AlertMessages(title: "Error", message: "Please Select Mobile Number", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
            return
        }
        else
        {
            if !self.isValidPhoneNumber(value: mobileNoTextfield.text!)
            {
                self.AlertMessages(title: "Error", message: "Please Enter Valid Mobile Number", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
                return
            }
        }
        
        if emailIdTextfield.text == ""
        {
            self.AlertMessages(title: "Error", message: "Please Select Email Id", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
            return
        }
        else
        {
            if !self.isValidEmail(testStr: emailIdTextfield.text!)
            {
                self.AlertMessages(title: "Error", message: "Please Enter Valid Email Id", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
                return
            }
        }
        
        if programmTextView.text == "" || programmTextView.text == "Select Product"
        {
            self.AlertMessages(title: "Error", message: "Please Select Product", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
            return
        }
        
        if (networkReachability?.isReachable)!
        {
            self.loaderView.isHidden = false
            self.loader.startAnimating()
            
            let custID : String!
            let isNewCustomer : String!
            let stateCode : String!
            let cityCode : String!
            let branchCode : String!
            
            if stateTextfield.text == ""
            {
                stateCode = AESCrypt.encrypt("0", password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
            }
            else
            {
                stateCode = AESCrypt.encrypt(self.allStateDictionary[self.stateTextfield.text!], password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
            }
            
            if cityTextfield.text == ""
            {
                cityCode = AESCrypt.encrypt("0", password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
            }
            else
            {
                cityCode = AESCrypt.encrypt(self.allCityDictionary[self.cityTextfield.text!], password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
            }
            
            if branchTextfield.text == ""
            {
                branchCode = AESCrypt.encrypt("0", password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
            }
            else
            {
                branchCode = AESCrypt.encrypt(self.allBranchDictionary[self.branchTextfield.text!], password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
            }
            
            if self.takerEmailID == ""
            {
                self.takerEmailID = AESCrypt.encrypt("NA", password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
            }
            else
            {
                self.takerEmailID = AESCrypt.encrypt(self.takerEmailID, password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
            }
            
            if isCustomer == false
            {
                isNewCustomer = AESCrypt.encrypt("true", password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
                custID = AESCrypt.encrypt("NA", password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
            }
            else
            {
                isNewCustomer = AESCrypt.encrypt("false", password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
                custID = JNKeychain.loadValue(forKey: "EncryptedCustomerID") as! String
            }
            
           // var progIdArray = [String]()
          //  for string in productList
          //  {
          //      progIdArray.append(self.allProgrammDictionary[string]!)
          //  }
            
         //   let programid = progIdArray.description.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: ",", with: "~").replacingOccurrences(of: " ", with: "")
            
            let programid = AESCrypt.encrypt(self.programmTextView.text, password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
            
            DataManager.createLead(isNewCustomer: isNewCustomer,programId: programid, leadCustId: custID, sourceBycode: AESCrypt.encrypt("others", password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:"), custName: AESCrypt.encrypt(self.firstNameTextfield.text, password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:"), cityCode: cityCode, stateCode: stateCode, emailID: AESCrypt.encrypt(emailIdTextfield.text, password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:"), empEmailId: AESCrypt.encrypt(JNKeychain.loadValue(forKey: "emailID") as! String, password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:"), takerEmailId: self.takerEmailID, custId: JNKeychain.loadValue(forKey: "encryptedCustID") as! String, takerSolId: branchCode, mobileNo:  AESCrypt.encrypt(mobileNoTextfield.text, password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:"), clientID: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, completionClouser: { (isSuccessful, error, result) in
            
                self.loaderView.isHidden = true
                self.loader.stopAnimating()
                print(result as Any)
                if isSuccessful
                {
                    if let jsonResult = result as? Dictionary<String, String>
                    {
                        print(jsonResult)
                        if let test3 = jsonResult["error"]
                        {
                            let error = AESCrypt.decrypt(test3, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                            print(error)
                            
                            if error == "NA"
                            {
                                let value = AESCrypt.decrypt(jsonResult["value"], password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                print(value)
                                let message = AESCrypt.decrypt(jsonResult["message"], password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                print(message)
                                self.AlertMessages(title: "Info", message: message, actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
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
    
    
    @IBAction func doneButtonClicked(_ sender: Any)
    {
        if nonCustomerRadioButton.isSelected == true
        {
            mainCustomerView.isHidden = true
            checkBoxContainerView.isHidden = true
            return
        }
        if customerIDTextfield.text != "" && customerRadioButton.isSelected == true
        {
            if (networkReachability?.isReachable)!
            {
                mainCustomerView.isHidden = true
                checkBoxContainerView.isHidden = true
                
                self.loaderView.isHidden = false
                self.loader.startAnimating()
                
                DataManager.getCustomerDetails(ein: JNKeychain.loadValue(forKey: "encryptedCustID") as! String,custID: AESCrypt.encrypt(customerIDTextfield.text, password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:"), clientID: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, completionClouser: { (isSuccessful, error, result) in
                    
                    self.loaderView.isHidden = true
                    self.loader.stopAnimating()
                    
                    print(result as Any)
                    if isSuccessful
                    {
                        if let jsonResult = result as? Dictionary<String, String>
                        {
                            if let clientID = jsonResult["clientId"]
                            {
                                let clientId = AESCrypt.decrypt(clientID, password: DataManager.SharedInstance().getKeyForEncryption())
                                print(clientId!)
                            }
                            if let add1 = jsonResult["custComuAddr1"]
                            {
                                let custComuAddr1 = AESCrypt.decrypt(add1, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                print(custComuAddr1)
                            }
                            if let add2 = jsonResult["custComuAddr2"]
                            {
                                let custComuAddr2 = AESCrypt.decrypt(add2, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                print(custComuAddr2)
                            }
                            if let city = jsonResult["custComuCityCode"]
                            {
                                let custComuCityCode = AESCrypt.decrypt(city, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                print(custComuCityCode)
                            }
                            if let phone1 = jsonResult["custComuPhone1"]
                            {
                                let custComuPhone1 = AESCrypt.decrypt(phone1, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                print(custComuPhone1)
                            }
                            if let phone2 = jsonResult["custComuPhone2"]
                            {
                                let custComuPhone2 = AESCrypt.decrypt(phone2, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                print(custComuPhone2)
                            }
                            if let pinCode = jsonResult["custComuPinCode"]
                            {
                                let custComuPinCode = AESCrypt.decrypt(pinCode, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                print(custComuPinCode)
                            }
                            if let stateCode = jsonResult["custComuStateCode"]
                            {
                                let custComuStateCode = AESCrypt.decrypt(stateCode, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                print(custComuStateCode)
                            }
                            if let custID = jsonResult["custId"]
                            {
                                let custId = AESCrypt.decrypt(custID, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                let encryptedCustomerID = AESCrypt.encrypt(custId, password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:")
                                JNKeychain.saveValue(encryptedCustomerID, forKey: "EncryptedCustomerID")
                                print(custId)
                            }
                            if let name = jsonResult["custName"]
                            {
                                let custName = AESCrypt.decrypt(name, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                self.firstNameTextfield.text = custName
                                print(custName)
                            }
                            if let email = jsonResult["emailId"]
                            {
                                let emailId = AESCrypt.decrypt(email, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                self.emailIdTextfield.text = emailId
                                print(emailId)
                            }
                            if let error = jsonResult["error"]
                            {
                                let error = AESCrypt.decrypt(error, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                print(error)
                            }
                            if let mobile = jsonResult["mobileNo"]
                            {
                                let mobileNo = AESCrypt.decrypt(mobile, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                self.mobileNoTextfield.text = mobileNo
                                print(mobileNo)
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
        else
        {
            self.AlertMessages(title: "Error", message: "Please Enter Valid Customer ID", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
        }
    
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.programmTextView.text = "Select Product"
        mainCustomerView.isHidden = false
        checkBoxContainerView.isHidden = false
        isCustomer = true
    }

    // MARK: Picker Done And Cancel Methods
    
//    func cancelPicker()
//    {
//        self.contactTimeTextfield.resignFirstResponder()
//    }
//    
//    func donePicker()
//    {
//        self.contactTimeTextfield.resignFirstResponder()
//    }
    
    // MARK: TextView Delegate Methods
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        self.productListClicked()
        return false
    }
    
    // MARK: Textfield Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
//        if textField == contactTimeTextfield
//        {
//            self.showDateAndTimePicker()
//            return false
//        }
//        else
        
        if textField == stateTextfield
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
                                self.autocompleteView.textField = self.stateTextfield
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
    
    //MARK: Validation Functions
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidPhoneNumber(value: String) -> (Bool)
    {
        let PHONE_REGEX = "^(" + "\\" + "+91[" + "\\" + "-\\" + "s]?)?[0]?(91)?[789]" + "\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        if phoneTest.evaluate(with: value) {
            return (true)
        }
        return (false)
    }
    
    // MARK: PICKER VIEW Methods
    
    func showDateAndTimePicker()
    {
        let min = Date()
        let max = Date().addingTimeInterval(60 * 60 * 24 * 30)
        let picker = DateTimePicker.show(minimumDate: min, maximumDate: max)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "DONE"
        picker.todayButtonTitle = "Today"
        picker.is12HourFormat = true
        picker.dateFormat = "hh:mm aa dd/MM/YYYY"
        //        picker.isDatePickerOnly = true
        picker.completionHandler = { date in
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
        self.contactTimeTextfield.text = formatter.string(from: date)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
//        if isBool
//        {
//            return preferredTimeArray.count
//        }
//        else
//        {
            return ageArray.count
       // }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
//        if isBool
//        {
//            self.contactTimeTextfield.text = preferredTimeArray[row]
//            return preferredTimeArray[row]
//        }
//        else
//        {
          //  self.ageTextfield.text = ageArray[row]
            return ageArray[row]
       // }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - LUAutocompleteView Methods
    
    func autocompleteView(_ autocompleteView: LUAutocompleteView, elementsFor text: String, completion: @escaping ([String]) -> Void)
    {
        if autocompleteView.textField == self.stateTextfield
        {
            let elementsThatMatchInput = Array(self.allStateDictionary.keys).filter { $0.lowercased().contains(text.lowercased()) }
            completion(elementsThatMatchInput)
        }
        else if autocompleteView.textField == self.cityTextfield
        {
            let elementsThatMatchInput = Array(self.allCityDictionary.keys).filter { $0.lowercased().contains(text.lowercased()) }
            completion(elementsThatMatchInput)
        }
        else if autocompleteView.textField == self.branchTextfield
        {
            let elementsThatMatchInput = Array(self.allBranchDictionary.keys).filter { $0.lowercased().contains(text.lowercased()) }
            completion(elementsThatMatchInput)
        }
    }
    
    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        
        if autocompleteView.textField == self.stateTextfield
        {
            self.cityTextfield.text = ""
            self.branchTextfield.text = ""
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
                            self.autocompleteViewForCity.textField = self.cityTextfield
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
        else if autocompleteView.textField == self.cityTextfield
        {
            self.branchTextfield.text = ""
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
                            self.autocompleteViewForBranch.textField = self.branchTextfield
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
        else if autocompleteView.textField == self.branchTextfield
        {
            if (networkReachability?.isReachable)!
            {
                self.loaderView.isHidden = false
                self.loader.startAnimating()
                
                DataManager.getEmailIDFromSol(sol: AESCrypt.encrypt(self.allBranchDictionary[text]!, password: DataManager.SharedInstance().getKeyForEncryption()).replacingOccurrences(of: "/", with: ":~:"), custID: JNKeychain.loadValue(forKey: "encryptedCustID") as! String, clientID: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, completionClouser: { (isSuccessful, error, result) in
                    
                    self.loaderView.isHidden = true
                    self.loader.stopAnimating()
                    if isSuccessful
                    {
                        if let jsonResult = result as? Array<Dictionary<String, String>>
                        {
                            for data in jsonResult
                            {
                                let emailId = AESCrypt.decrypt(data["emailId"], password: DataManager.SharedInstance().getKeyForEncryption())
                                self.takerEmailID = emailId
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
        
    }
    
    
    func productListClicked()
    {
            if (networkReachability?.isReachable)!
            {
                self.loaderView.isHidden = false
                self.loader.startAnimating()
                
                DataManager.getProgrammList(custID: JNKeychain.loadValue(forKey: "encryptedCustID") as! String, clientID: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, completionClouser: { (isSuccessful, error, result) in
                    self.loaderView.isHidden = true
                    self.loader.stopAnimating()
                    if isSuccessful
                    {
                        if let jsonResult = result as? Array<Dictionary<String, String>>
                        {
                            print(jsonResult)
                            for data in jsonResult
                            {
                                let productType = AESCrypt.decrypt(data["prodType"], password: DataManager.SharedInstance().getKeyForEncryption())
                                if productType == "Popular Products"
                                {
                                    let prgId = AESCrypt.decrypt(data["prgId"], password: DataManager.SharedInstance().getKeyForEncryption())
                                    let prgName = AESCrypt.decrypt(data["prgName"], password: DataManager.SharedInstance().getKeyForEncryption())
                                    self.allProgrammDictionary.updateValue(prgId!, forKey: prgName!)
                                }
                    
                            }
                            
                            let picker = CZPickerView(headerTitle: "Products", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
                            picker?.delegate = self
                            picker?.dataSource = self
                            picker?.needFooterView = false
                            picker?.allowMultipleSelection = false
                            picker?.show()
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

extension AddLeadViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        //if pickerView == pickerWithImage {
       //     return fruitImages[row]
       // }
        return nil
    }
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return Array(self.allProgrammDictionary.keys).count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return Array(self.allProgrammDictionary.keys)[row]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
       // self.programmTextView.text = productList.[IndexPath].row.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        self.programmTextView.text = (Array(self.allProgrammDictionary.keys)[row])
       
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
        
       // productList.removeAll(keepingCapacity: false)
//        for row in rows {
//            if let row = row as? Int {
//                
//                //newString = newString + Array(self.allProgrammDictionary.keys)[row] + "~"
//               // productList.append(Array(self.allProgrammDictionary.keys)[row])
//            }
//        }
        
       // self.programmTextView.text = productList.description.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
    }
}


extension UITextField {
    func drawUnderLineForTextField()
    {
        self.layoutIfNeeded()
        let underLineView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1))
        underLineView.backgroundColor = UIColor.orange
        self.addSubview(underLineView)
    }
}


// MARK: - checkmark delegate method


