//
//  AddLeadViewController.swift
//  IDBISales
//
//  Created by Sachin Amrale on 01/08/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit
class AddLeadViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,LUAutocompleteViewDelegate,LUAutocompleteViewDataSource{
    
    @IBOutlet weak var stateTextfield           : UITextField!
    @IBOutlet weak var cityTextfield            : UITextField!
    @IBOutlet weak var branchTextfield          : UITextField!
    @IBOutlet weak var firstNameTextfield       : RaisePlaceholder!
    @IBOutlet weak var mobileNoTextfield        : RaisePlaceholder!
    @IBOutlet weak var lastNameTextfield        : RaisePlaceholder!
    @IBOutlet weak var emailIdTextfield         : RaisePlaceholder!
    @IBOutlet weak var contactTimeTextfield     : RaisePlaceholder!
    @IBOutlet weak var ageTextfield             : RaisePlaceholder!
    @IBOutlet weak var checkboxCustomer         : CCheckbox!
    @IBOutlet weak var checkboxNonCustomer      : CCheckbox!
    @IBOutlet weak var customerIDTextfield      : RaisePlaceholder!
    var preferredTimeArray                      = ["10AM-12PM","12PM-2PM","2PM-4PM","4PM-6PM"]
    var ageArray                                = ["0-17","18-24","25-34","35-44","45-60","60+"]
    var Products                                  = [String]()
    var testPicker                              : UIPickerView!
    var isBool                                  : Bool!
    private let autocompleteView                = LUAutocompleteView()
    var stateArray                              = ["Andhra Pradesh","Arunachal Pradesh","Assam","Bihar","Chhattisgarh","Goa","Gujarat","Haryana","Himachal Pradesh","Jammu and Kashmir","Jharkhand","Karnataka","Kerala","Madhya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","Odisha","Punjab","Rajasthan","Sikkim","Tamil Nadu","Telangana","Tripura","Uttar Pradesh","Uttarakhand","West Bengal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.commonInitialization()
        
        // Do any additional setup after loading the view.
    }
    
    func commonInitialization()
    {
       
        
        
        
        Products = ["Agri Loan", "Auto Loan", "Being My Account", "Capital Gain Account", "Cash Card","Corporate Salary Account","Credit Card","Dealer Finance","DeMat Account","Education Loan","Flexi Current Account","Floating Rate Term Account","Gift Card","Godhuli Retail Term Deposite","Home Loan","Jublee Plus(Senior Citizen) Account","Loan Against Property","Loan Against Securities","Mutual Funds","National Pension Scheme","Personal Loan","Power Kids Account","Recurring Deposite","Reverse Mortgage Loan","Sabka Savings Account","Savings Account","Super Shakti Womens","Suvidha Fix Deposite","Suvidha Suraksha Recurring Deposite","Trader Finance","Word Currency Card"]
        
        view.addSubview(autocompleteView)
        autocompleteView.textField = self.stateTextfield
        autocompleteView.dataSource = self
        autocompleteView.delegate = self
        autocompleteView.rowHeight = 45
        
        contactTimeTextfield.delegate = self
        ageTextfield.delegate = self
        
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
        
        self.contactTimeTextfield.inputView = testPicker
        self.ageTextfield.inputView = testPicker
        //    self.contactTimeTextfield.inputAccessoryView = toolBar
        
        firstNameTextfield.animationDuration = 0.5
        firstNameTextfield.subjectColor = UIColor.orange
        firstNameTextfield.underLineColor = UIColor.orange
        
        lastNameTextfield.animationDuration = 0.5
        lastNameTextfield.subjectColor = UIColor.orange
        lastNameTextfield.underLineColor = UIColor.orange
        
        mobileNoTextfield.animationDuration = 0.5
        mobileNoTextfield.subjectColor = UIColor.orange
        mobileNoTextfield.underLineColor = UIColor.orange
        
        emailIdTextfield.animationDuration = 0.5
        emailIdTextfield.subjectColor = UIColor.orange
        emailIdTextfield.underLineColor = UIColor.orange
        
        contactTimeTextfield.animationDuration = 0.5
        contactTimeTextfield.subjectColor = UIColor.orange
        contactTimeTextfield.underLineColor = UIColor.orange
        
        ageTextfield.animationDuration = 0.5
        ageTextfield.subjectColor = UIColor.orange
        ageTextfield.underLineColor = UIColor.orange
        
        stateTextfield.drawUnderLineForTextField()
        cityTextfield.drawUnderLineForTextField()
        branchTextfield.drawUnderLineForTextField()
        
        
        // checkmark
        checkboxNonCustomer.isCheckboxSelected = true
        checkboxNonCustomer.delegate=self
        checkboxCustomer.delegate=self
        
        // customer ID textfiled
        
        customerIDTextfield.animationDuration = 0.5
        customerIDTextfield.subjectColor = UIColor.orange
        customerIDTextfield.underLineColor = UIColor.orange
              
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }

    // MARK: Picker Done And Cancel Methods
    
    func cancelPicker()
    {
        self.contactTimeTextfield.resignFirstResponder()
    }
    
    func donePicker()
    {
        self.contactTimeTextfield.resignFirstResponder()
    }
    
    // MARK: Textfield Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == contactTimeTextfield
        {
            isBool = true
        }
        else if textField == ageTextfield
        {
            isBool = false
        }
        testPicker.reloadAllComponents()
        return true
    }
    
    // MARK: PICKER VIEW Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if isBool
        {
            return preferredTimeArray.count
        }
        else
        {
            return ageArray.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if isBool
        {
            self.contactTimeTextfield.text = preferredTimeArray[row]
            return preferredTimeArray[row]
        }
        else
        {
            self.ageTextfield.text = ageArray[row]
            return ageArray[row]
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - LUAutocompleteView Methods
    
    func autocompleteView(_ autocompleteView: LUAutocompleteView, elementsFor text: String, completion: @escaping ([String]) -> Void) {
        let elementsThatMatchInput = stateArray.filter { $0.lowercased().contains(text.lowercased()) }
        completion(elementsThatMatchInput)
    }
    
    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        print(text + " was selected from autocomplete view")
    }
    
    
    @IBAction func productListClicked(_ sender: Any)
    {
        let picker = CZPickerView(headerTitle: "Products", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        picker?.delegate = self
        picker?.dataSource = self
        picker?.needFooterView = false
        picker?.allowMultipleSelection = true
        picker?.show()
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
        return Products.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return Products[row]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        print(Products[row])
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
        for row in rows {
            if let row = row as? Int {
                print("values : \(Products[row])")
            }
        }
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


extension AddLeadViewController: CheckboxDelegate
{
    func didSelect(_ checkbox: CCheckbox)
    {
        if checkbox == checkboxCustomer
        {
            checkboxCustomer.isCheckboxSelected=true
            checkboxNonCustomer.isCheckboxSelected=false
        }
        if checkbox == checkboxNonCustomer
        {
            checkboxCustomer.isCheckboxSelected=false
            checkboxNonCustomer.isCheckboxSelected=true
        }
    }
    
    
    func didDeselect(_ checkbox: CCheckbox)
    {
        
    }

}

//    func didDeselect(_ checkbox: CCheckbox)
//    {
//    }




