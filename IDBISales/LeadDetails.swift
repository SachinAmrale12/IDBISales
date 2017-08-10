//
//  LeadDetails.swift
//  IDBISales
//
//  Created by Amit Dhadse on 08/08/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit
import ReachabilitySwift

class LeadDetails: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    let networkReachability             = Reachability()
    var closureReasonDictionary         = [String:String]()
    
    @IBOutlet var leadName              : UILabel!
    @IBOutlet var productName           : UILabel!
    @IBOutlet var mobileNumber          : UILabel!
    @IBOutlet var email                 : UILabel!
    @IBOutlet var giverEmailID          : UILabel!
    @IBOutlet var giverName             : UILabel!
    
    @IBOutlet weak var fromLabel: UILabel!
    var name                            : String!
    var product                         : String!
    var mobile                          : String!
    var mail                            : String!
    var givermail                       : String!
    var givername                       : String!

    @IBOutlet var scheduleParentContainerView: UIView!
    @IBOutlet var scheduleChildView: UIView!
    
    @IBOutlet var dateTimeTextField: UITextField!
    @IBOutlet var remarkTextView: UITextView!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.commonInitialization()
        // Do any additional setup after loading the view.
    }
    
    // MARK: commonInitialization
    
    func commonInitialization()
    {
        self.leadName.text = name
        self.productName.text = product
        self.mobileNumber.text = mobile
        
        remarkTextView.layer.borderWidth = 1
        remarkTextView.layer.cornerRadius = 4
        remarkTextView.layer.borderColor = UIColor.orange.cgColor
        
        leadName.drawUnderLineForLabel()
        productName.drawUnderLineForLabel()
        mobileNumber.drawUnderLineForLabel()
        email.drawUnderLineForLabel()
        giverEmailID.drawUnderLineForLabel()
        giverName.drawUnderLineForLabel()
        
        fromLabel.layer.borderWidth = 1
        fromLabel.layer.cornerRadius = 4
        fromLabel.layer.borderColor = UIColor.orange.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClicked(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    //MARK: Keyboard Dismiss Functions
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height - 110
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
    }
    
    // MARK: closure methods
    
    
    @IBAction func closureClicked(_ sender: Any)
    {
        if (networkReachability?.isReachable)!
        {
            
            DataManager.getLeadClosureReasons(custID: JNKeychain.loadValue(forKey: "encryptedCustID") as! String, clientID: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, completionClouser: { (isSuccessful, error, result) in
                //self.loaderView.isHidden = true
                //self.loader.stopAnimating()
                if isSuccessful
                {
                    print(result as Any)
                    
                    if let jsonResult = result as? Array<Dictionary<String, String>>
                    {
                        for data in jsonResult
                        {
                            let statusName = AESCrypt.decrypt(data["statusName"], password: DataManager.SharedInstance().getKeyForEncryption())
                            //print(statusName as Any)
                            let statusID = AESCrypt.decrypt(data["statusId"], password: DataManager.SharedInstance().getKeyForEncryption())
                            //print(statusID as Any)
                            self.closureReasonDictionary.updateValue(statusName!, forKey: statusID!)
                            
                        }
                        
                        let picker = CZPickerView(headerTitle: "Products", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
                        picker?.delegate = self
                        picker?.dataSource = self
                        picker?.needFooterView = false
                        picker?.allowMultipleSelection = false
                        picker?.show()
                        print(self.closureReasonDictionary as Any)
                    }
                }
            })
        }
    }
    
    
    
    
    // MARK: resheduleMeeting methods
    
    @IBAction func resheduleMeeting(_ sender: Any)
    {
        self.scheduleParentContainerView.isHidden = false
        self.scheduleChildView.isHidden = false

    }
    
    @IBAction func scheduleAppointment(_ sender: Any)
    {
        self.scheduleParentContainerView.isHidden = true
        self.scheduleChildView.isHidden = true
    }
    @IBAction func assignClicked(_ sender: Any)
    {
    }
    
    @IBAction func hideAppointmentView(_ sender: Any)
    {
        scheduleChildView.isHidden = true
        scheduleParentContainerView.isHidden = true
    }
    func closeLead()
    {
        DataManager.leadClose(custID: JNKeychain.loadValue(forKey: "encryptedCustID") as! String, clientID: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, forceLeadId: "", status: "", remarks: "", completionClouser: { (isSuccessful, error, result) in
            
            
            //self.loaderView.isHidden = true
            //self.loader.stopAnimating()
            
            if isSuccessful
            {
                //                let jsonResult = result as? NSDictionary
                //
                //                if jsonResult["error"] == "NA"
                //                {
                //
                //                }
                //{"error":"-","message":"AUyXMVKm3WYZgcmxvtibJp2Mky8vbOoV/c5k9hjFOs8=","value":"-"}
            }
            
        })
    }
    
   // MARK: textfield delegate methods
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        self.showPicker()
        return false
    }
    // MARK: textview delegate methods
    
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        remarkTextView.text = ""
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: picker method
    
    func showPicker()
    {
        self.view.endEditing(true)
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
            self.dateTimeTextField.text = formatter.string(from: date)
        }

    }

}





extension LeadDetails: CZPickerViewDelegate, CZPickerViewDataSource {
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        //if pickerView == pickerWithImage {
        //     return fruitImages[row]
        // }
        return nil
    }
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return Array(self.closureReasonDictionary.values).count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return Array(self.closureReasonDictionary.values)[row]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // self.programmTextView.text = productList.[IndexPath].row.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        print(Array(self.closureReasonDictionary.values)[row])
        
        let message = "Are you sure\n You want to close this Lead with reason \"\((Array(self.closureReasonDictionary.values)[row]))\""
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.closeLead()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
        
        
    }
}


