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
    let customerData                                        = TNCircularCheckBoxData()
    let nonCustomerData                                     = TNCircularCheckBoxData()
    var checkBoxGroup                                       : TNCheckBoxGroup!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.commonInitialization()
        
        // Do any additional setup after loading the view.
    }
    
    func commonInitialization()
    {
       
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
    
        customerData.identifier = "Customer"
        customerData.labelText = "Customer"
        customerData.checked = true
        customerData.borderColor = UIColor.black
        customerData.circleColor = UIColor.black
        customerData.borderRadius = 20
        customerData.circleRadius = 15
        
        nonCustomerData.identifier = "Non Customer"
        nonCustomerData.labelText = "Non Customer"
        nonCustomerData.checked = false
        nonCustomerData.borderColor = UIColor.black
        nonCustomerData.circleColor = UIColor.black
        nonCustomerData.borderRadius = 20
        nonCustomerData.circleRadius = 15
        
        checkBoxGroup = TNCheckBoxGroup(checkBoxData: [customerData,nonCustomerData], style: TNCheckBoxLayoutVertical)
        checkBoxGroup?.create()
        self.checkBoxView.addSubview(checkBoxGroup!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.GroupChanged), name: NSNotification.Name(rawValue: GROUP_CHANGED), object: checkBoxGroup)
        
        // customer ID textfiled
        
        customerIDTextfield.animationDuration = 0.5
        customerIDTextfield.subjectColor = UIColor.orange
        customerIDTextfield.underLineColor = UIColor.orange
              
        
    }
    
    func GroupChanged(notification: NSNotification)
    {
        print(checkBoxGroup.checkedCheckBoxes)
        
        if nonCustomerData.checked
        {
            customerData.checked = false
            nonCustomerData.checked = true
            custIDTextfieldHeightConstraint.constant = 0
            customerIDTextfield.isHidden = true
            containerViewHeightConstarint.constant = 240 - 40
        }
        else
        {
            nonCustomerData.checked = false
            customerData.checked = true
            customerIDTextfield.isHidden = false
            custIDTextfieldHeightConstraint.constant = 40
            containerViewHeightConstarint.constant = 240
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: Any)
    {
        if customerIDTextfield.text != ""
        {
            if (networkReachability?.isReachable)!
            {
                DataManager.getCustomerDetails(custID: AESCrypt.encrypt(customerIDTextfield.text, password: DataManager.SharedInstance().getGlobalKey()).replacingOccurrences(of: "/", with: ":~:"), clientID: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, completionClouser: { (isSuccessful, error, result) in
                    print(result as Any)
                    if isSuccessful
                    {
                        if let jsonResult = result as? Dictionary<String, String>
                        {
                            if let error = jsonResult["error"]
                            {
                                let error = AESCrypt.decrypt(error, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                print(error)
                                let value = AESCrypt.decrypt(jsonResult["value"], password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                print(value)
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
        
        mainCustomerView.isHidden = true
        checkBoxContainerView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.programmTextView.text = "Select Program"
        mainCustomerView.isHidden = false
        checkBoxContainerView.isHidden = false
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
        return true
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
                        for data in jsonResult
                        {
                            let prgId = AESCrypt.decrypt(data["prgId"], password: DataManager.SharedInstance().getKeyForEncryption())
                            let prgName = AESCrypt.decrypt(data["prgName"], password: DataManager.SharedInstance().getKeyForEncryption())
//                            let clientId = AESCrypt.decrypt(data["clientId"], password: DataManager.SharedInstance().getKeyForEncryption())
//                            let custId = AESCrypt.decrypt(data["custId"], password: DataManager.SharedInstance().getKeyForEncryption())
                            self.allProgrammDictionary.updateValue(prgId!, forKey: prgName!)
                           
                        }
                        
                        let picker = CZPickerView(headerTitle: "Products", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
                        picker?.delegate = self
                        picker?.dataSource = self
                        picker?.needFooterView = false
                        picker?.allowMultipleSelection = true
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
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
        
        var newString = ""
        for row in rows {
            if let row = row as? Int {
                
                newString = newString + Array(self.allProgrammDictionary.keys)[row]
            }
        }
        
        self.programmTextView.text = newString
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


