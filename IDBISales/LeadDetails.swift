//
//  LeadDetails.swift
//  IDBISales
//
//  Created by Amit Dhadse on 08/08/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit
import ReachabilitySwift
import MessageUI
class LeadDetails: UIViewController,UITextFieldDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate {
    
    
        @IBOutlet weak var loaderContainerView: UIView!
    @IBOutlet weak var custName         : V2LabeledTextField!
    @IBOutlet weak var productName      : V2LabeledTextField!
    @IBOutlet weak var giverEmail       : V2LabeledTextField!
    @IBOutlet weak var mobileNumber     : V2LabeledTextField!
    @IBOutlet weak var giverName        : V2LabeledTextField!
    @IBOutlet weak var createdDate      : V2LabeledTextField!
    @IBOutlet weak var customerEmail    : V2LabeledTextField!
    
    let networkReachability             = Reachability()
    var closureReasonDictionary         = [String:String]()
    
    @IBOutlet weak var loaderView: UIView!
  //  @IBOutlet var leadName              : UILabel!
  //  @IBOutlet var productName           : UILabel!
  //  @IBOutlet var mobileNumber          : UILabel!
  //  @IBOutlet var email                 : UILabel!
  //  @IBOutlet var giverEmailID          : UILabel!
 //   @IBOutlet var giverName             : UILabel!
    
  //  @IBOutlet weak var createdDate: UILabel!
    
    @IBOutlet weak var fromLabel        : UILabel!
    
    var name                            : String!
    var product                         : String!
    var mobile                          : String!
    var mail                            : String!
    var givermail                       : String!
    var givername                       : String!
    var createddate                     : String!
    var loader                          : MaterialLoadingIndicator!
    var leadID                          : String!
    
    var closureReson                    : String!

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
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.mobileButtonClicked))
        gesture.numberOfTapsRequired = 1
        self.mobileNumber.addGestureRecognizer(gesture)

        let emailTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.EmailViewTap))
        emailTapGesture.numberOfTapsRequired = 1
        customerEmail.addGestureRecognizer(emailTapGesture)
        
        
        self.loader = MaterialLoadingIndicator(frame: self.loaderView.bounds)
        self.loaderView.addSubview(loader)
        self.loaderContainerView.isHidden = true
        self.loaderView.isHidden = true
        
        mobileNumber.textField.delegate = self
        
        custName.label.text = "Name"
        productName.label.text = "Product"
        mobileNumber.label.text = "Mobile Number"
        createdDate.label.text = "Created Date"
        customerEmail.label.text = "Customer Email"
        giverName.label.text = "Name"
        giverEmail.label.text = "Email"
        
        custName.textField.text = name
        productName.textField.text = product
        mobileNumber.textField.text = mobile
        createdDate.textField.text = createddate
        customerEmail.textField.text = mail
        giverName.textField.text = givername
        giverEmail.textField.text = givermail
        
       // self.leadName.text = name
     //   self.productName.text = product
     //   self.mobileNumber.text = mobile
       // self.giverName.text = givername
     //   self.giverEmailID.text = givermail
     //   self.email.text = mail
    //    self.createdDate.text = createddate
        
        remarkTextView.layer.borderWidth = 1
        remarkTextView.layer.cornerRadius = 4
        remarkTextView.layer.borderColor = UIColor.orange.cgColor

        
//        fromLabel.layer.borderWidth = 1
//        fromLabel.layer.cornerRadius = 4
//        fromLabel.layer.borderColor = UIColor.orange.cgColor
    }
    
    
    func mobileButtonClicked()
    {
        
        if self.isValidPhoneNumber(value: self.mobileNumber.textField.text!)
        {
            if let url = URL(string: "tel://\(String(describing: self.mobileNumber.textField.text))"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        else
        {
            self.AlertMessages(title: "Alert", message: "Invalid Mobile Number To Make a Phone Call", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
        }
        
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
            self.loaderView.isHidden = false
            self.loaderContainerView.isHidden = false
            self.loader.startAnimating()
            
            DataManager.getLeadClosureReasons(custID: JNKeychain.loadValue(forKey: "encryptedCustID") as! String, clientID: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, completionClouser: { (isSuccessful, error, result) in
                
                self.loaderView.isHidden = true
                self.loaderContainerView.isHidden = true
                self.loader.stopAnimating()
                
                if isSuccessful
                {
                    print(result as Any)
                    
                    if let jsonResult = result as? Array<Dictionary<String, String>>
                    {
                        for data in jsonResult
                        {
                            let statusName = AESCrypt.decrypt(data["statusName"], password: DataManager.SharedInstance().getKeyForEncryption())
                            print(statusName as Any)
                            let statusID = AESCrypt.decrypt(data["statusId"], password: DataManager.SharedInstance().getKeyForEncryption())
                            print(statusID as Any)
                            self.closureReasonDictionary.updateValue(statusName!, forKey: statusID!)
                            
                        }
                        
                        let picker = CZPickerView(headerTitle: "Closure List", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
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
        else
        {
            self.AlertMessages(title: "Internet connection Error", message: "Your Device is not Connect to \"Internet\"", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
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
        if (networkReachability?.isReachable)!
        {
            
            if dateTimeTextField.text == "Please select \"Date & Time\""
            {
                self.AlertMessages(title: "Alert", message: "Please add Date and Time to \"Reschedule Meeting\"", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
                return
            }
            if remarkTextView.text == "Please add Remark here" || remarkTextView.text == ""
            {
                self.AlertMessages(title: "Alert", message: "Please add Remark", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
                return
            }
           
            
            self.loaderView.isHidden = false
            self.loaderContainerView.isHidden = false
            self.loader.startAnimating()
            
            let encryptedLeadId = AESCrypt.encrypt(self.leadID, password: DataManager.SharedInstance().getKeyForEncryption()).stringReplace()
            let encryptedAppointmentDate = AESCrypt.encrypt(self.dateTimeTextField.text, password: DataManager.SharedInstance().getKeyForEncryption()).stringReplace()
            let encryptedRemark = AESCrypt.encrypt(self.remarkTextView.text, password: DataManager.SharedInstance().getKeyForEncryption()).stringReplace()
            //remarkTextView
            
            DataManager.createAppointment(tranLeadId: encryptedLeadId, takerEmail: JNKeychain.loadValue(forKey: "encryptedEmailId") as! String, appointmentDt: encryptedAppointmentDate, appmntRemarks: encryptedRemark, custId: JNKeychain.loadValue(forKey: "encryptedCustID") as! String, clientId: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, completionClouser: { (isSuccessful, error, result) in
                
                self.loaderView.isHidden = true
                self.loaderContainerView.isHidden = true
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
                                    self.view.endEditing(true)
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
                                    
                                    self.AlertMessages(title: "Error", message: "Appointment created successfully", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: { (action) in
                                        self.navigationController?.popViewController(animated: true)
                                    })
                                    
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
        
        self.scheduleParentContainerView.isHidden = true
        self.scheduleChildView.isHidden = true
        
        
    }
    @IBAction func assignClicked(_ sender: Any)
    {
        let assignLeadVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "assignLeadIdentifier") as! AssignLeadViewController
        assignLeadVC.encryptedLead = self.leadID
        self.navigationController?.pushViewController(assignLeadVC, animated: true)
        //assignLeadIdentifier
    }
    
    @IBAction func hideAppointmentView(_ sender: Any)
    {
        scheduleChildView.isHidden = true
        scheduleParentContainerView.isHidden = true
    }
    func closeLead()
    {
        if (networkReachability?.isReachable)!
        {
            self.loaderView.isHidden = false
            self.loaderContainerView.isHidden = false
            self.loader.startAnimating()
            
            let encryptedStatusCode = AESCrypt.encrypt(self.closureReasonDictionary[self.closureReson], password: DataManager.SharedInstance().getKeyForEncryption()).stringReplace()
            let encryptedNA = AESCrypt.encrypt("NA", password: DataManager.SharedInstance().getKeyForEncryption()).stringReplace()
            let encryptedLeadID = AESCrypt.encrypt(self.leadID, password: DataManager.SharedInstance().getKeyForEncryption()).stringReplace()
            
            DataManager.leadClose(custID: JNKeychain.loadValue(forKey: "encryptedCustID") as! String, clientID: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, forceLeadId: encryptedLeadID, status: encryptedStatusCode, remarks: encryptedNA, completionClouser: { (isSuccessful, error, result) in
            
                self.loaderView.isHidden = true
                self.loaderContainerView.isHidden = true
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
                                
                                if let message = element["message"]
                                {
                                    let message = AESCrypt.decrypt(message as! String, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                    print(message)
                                }
                                
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
            
            })
        }
        else
        {
            self.AlertMessages(title: "Internet connection Error", message: "Your Device is not Connect to \"Internet\"", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
        }
    }
   
    
    // MARK: email Tap gesture methods
   
    func EmailViewTap(sender: UITapGestureRecognizer? = nil)
    {
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([customerEmail.textField.text!])
            mail.setSubject("")
            mail.setMessageBody("Text Body", isHTML: false)
            present(mail, animated: true, completion: nil)
        }
    }

    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
    
    // MARK: textfield delegate methods
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == dateTimeTextField
        {
            self.showPicker()
        }
        
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
            formatter.dateFormat = "dd/MMM/YY"
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
        self.closureReson = Array(self.closureReasonDictionary.values)[row]
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
        
        
        /*let composer = MFMailComposeViewController()
         
         if MFMailComposeViewController.canSendMail() {
         composer.mailComposeDelegate = self
         composer.setToRecipients(["Email1", "Email2"])
         composer.setSubject("Test Mail")
         composer.setMessageBody("Text Body", isHTML: false)
         present(composer, animated: true, completion: nil)
         }*/
        
    }
}


