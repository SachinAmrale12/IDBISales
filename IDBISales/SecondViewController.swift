//
//  SecondViewController.swift
//  IDBISales
//
//  Created by Sachin Amrale on 29/07/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit
import ReachabilitySwift

class SecondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var sideMenu                    = MVYSideMenuController()
    var productName                 = [String]()
    var custName                    = [String]()
    var custPhoneNumber             = [String]()
    var leadCreationDate            = [String]()
    var leadID                      = [String]()
    
    var assignTo                    = [String]()
    var productNameLabel            : UILabel!
    var assignToLabel               : UILabel!
    let networkReachability         = Reachability()
    var loader                      : MaterialLoadingIndicator!
    
    @IBOutlet var containerView       : UIView!
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loaderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commonInitialization()
        //sideMenu.disable()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.containerView.isHidden = false
    }
    
    
    func commonInitialization()
    {
        self.loader = MaterialLoadingIndicator(frame: self.loaderView.bounds)
        self.loaderView.addSubview(loader)
        self.loaderView.isHidden = true
        
        assignTo.append("Amit")
        assignTo.append("Sachin")
        assignTo.append("vikrant")
        assignTo.append("nish")
    }
    @IBAction func viewLeadsClicked(_ sender: Any)
    {
        self.containerView.isHidden = true
    }
    @IBAction func addLeadsClicked(_ sender: Any)
    {
        self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addLeadVCIndentifier"), animated: true)
    }
    @IBAction func backClicked(_ sender: Any)
    {
        containerView.isHidden = false
    }

    @IBAction func menuButtonClicked(_ sender: Any)
    {
        sideMenu = self.sideMenuController()
        if (sideMenu != nil)
        {
            sideMenu.openMenu()
        }
    }
    
    //
    
    @IBAction func allLeadsClicked(_ sender: Any)
    {
      //  self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addLeadVCIndentifier"), animated: true)
    }
    
    
    @IBAction func viewLeadButtonClicked(_ sender: Any)
    {
        if (networkReachability?.isReachable)!
        {
            self.loaderView.isHidden = false
            self.loader.startAnimating()
            
            DataManager.viewLead(custId: JNKeychain.loadValue(forKey: "encryptedCustID") as! String, clientId: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, completionClouser: { (isSuccessful, error, result) in
                
                self.loaderView.isHidden = true
                self.loader.stopAnimating()
                
                if isSuccessful
                {
                    if let element = result as? NSDictionary
                    {
                        print(element)
                        if let error = element["error"]
                        {
                            let error = AESCrypt.decrypt(element["error"] as! String, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                            
                            if error == "NA"
                            {
                                if let myList = element["myList"]
                                {
                                    let listArray = myList as? Array<Any>
                                    for value in listArray!
                                    {
                                        let lead = AESCrypt.decrypt(value as! String, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                        let leadDetailArray = lead.components(separatedBy: "~")
                                        self.custName.append(leadDetailArray[0])
                                        self.custPhoneNumber.append(leadDetailArray[1])
                                        self.leadCreationDate.append(leadDetailArray[2])
                                        self.productName.append(leadDetailArray[3])
                                        self.leadID.append(leadDetailArray[4])
                                    }
                                    
                                    self.tableView.reloadData()
                                }
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
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return productName.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        }
        
          cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        productNameLabel = cell?.viewWithTag(1) as! UILabel
        assignToLabel = cell?.viewWithTag(2) as! UILabel
        
        productNameLabel.text = custName[indexPath.row]
        assignToLabel.text = productName[indexPath.row]
        
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeadDetailsVCIdentifier"), animated: true)
        //LeadDetailsVCIdentifier
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 69.0
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
