//
//  LeadDetails.swift
//  IDBISales
//
//  Created by Amit Dhadse on 08/08/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit
import ReachabilitySwift

class LeadDetails: UIViewController {
    
    let networkReachability             = Reachability()
    var closureReasonDictionary         = [String:String]()
    
    @IBOutlet var leadName: UILabel!
    
    @IBOutlet var productName: UILabel!
    
    
    @IBOutlet var mobileNumber: UILabel!
    
    
    @IBOutlet var email: UILabel!
    
    @IBOutlet var giverEmailID: UILabel!
    @IBOutlet var giverName: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClicked(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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


