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

    var sideMenu                                = MVYSideMenuController()
    var productName                             = [String]()
    var custName                                = [String]()
    var custPhoneNumber                         = [String]()
    var customerEmail                           = [String]()
    var leadCreationDate                        = [String]()
    var leadID                                  = [String]()
    var giverName                               = [String]()
    var giverEmail                              = [String]()
    
    var productNameBranch                       = [String]()
    var custNameBranch                          = [String]()
    var customerEmailBranch                     = [String]()
    var custPhoneNumberBranch                   = [String]()
    var leadCreationDateBranch                  = [String]()
    var leadIDBranch                            = [String]()
    var giverNameBranch                         = [String]()
    var giverEmailBranch                        = [String]()
    
    var leadsArray                              = [[String:String]]()
    
    var assignTo                                = [String]()
    var productNameLabel                        : UILabel!
    var assignToLabel                           : UILabel!
    let networkReachability                     = Reachability()
    var loader                                  : MaterialLoadingIndicator!
    var isMyLead                                : Bool!
    @IBOutlet var containerView                 : UIView!
    @IBOutlet weak var loaderContainerView      : UIView!
    @IBOutlet weak var tableView                : UITableView!
    @IBOutlet weak var loaderView               : UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commonInitialization()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.viewLeadsService()
        self.isMyLead = true
    }
    
    
    func commonInitialization()
    {
        self.loader = MaterialLoadingIndicator(frame: self.loaderView.bounds)
        self.loaderView.addSubview(loader)
        self.loaderView.isHidden = true
        self.loaderContainerView.isHidden = true
        

    }
   
   
    @IBAction func backClicked(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func allLeadClicked(_ sender: Any)
    {
        if custNameBranch.count > 0
        {
            self.isMyLead = false
            self.tableView.reloadData()
        }
        else
        {
            self.AlertMessages(title: "Oops !", message: "No Record Found", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
        }
    }
    
    @IBAction func myLeadsClicked(_ sender: Any)
    {
        if custName.count > 0
        {
            self.isMyLead = true
            self.tableView.reloadData()
        }
        else
        {
            self.AlertMessages(title: "Oops !", message: "No Record Found", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
        }
    }
    
    
    func viewLeadsService()
    {
        if (networkReachability?.isReachable)!
        {
            self.loaderView.isHidden = false
            self.loaderContainerView.isHidden = false
            self.loader.startAnimating()
            
            DataManager.viewLead(custId: JNKeychain.loadValue(forKey: "encryptedCustID") as! String, clientId: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, completionClouser: { (isSuccessful, error, result) in
                
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
                            let errorValue = (error as! String).replacingOccurrences(of: "error ::", with: "")
                            let error = AESCrypt.decrypt(errorValue, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                            
                            if error == "NA"
                            {
                                if let myList = element["myList"]
                                {
                                    let listArray = myList as? Array<Any>
                                    if (listArray?.count)! > 0
                                    {
                                        self.custName.removeAll(keepingCapacity: false)
                                        self.custPhoneNumber.removeAll(keepingCapacity: false)
                                        self.leadCreationDate.removeAll(keepingCapacity: false)
                                        self.productName.removeAll(keepingCapacity: false)
                                        self.leadID.removeAll(keepingCapacity: false)
                                        self.giverName.removeAll(keepingCapacity: false)
                                        self.giverEmail.removeAll(keepingCapacity: false)
                                        self.customerEmail.removeAll(keepingCapacity: false)
                                        self.leadsArray.removeAll(keepingCapacity: false)
                                        
                                        for value in listArray!
                                        {
                                            let lead = AESCrypt.decrypt(value as! String, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                            
                                            let leadDetailArray = lead.components(separatedBy: "~")
                                            let leadData = ["name":leadDetailArray[0],"phoneNumber":leadDetailArray[1],"email":leadDetailArray[2],"date":leadDetailArray[3],"productName":leadDetailArray[4],"id":leadDetailArray[5],"giverName":leadDetailArray[6],"giverEmail":leadDetailArray[7]]
                                            self.leadsArray.append(leadData)
                                            
                                        }
                                        
                                    }
                                    else
                                    {
                                        self.custName.removeAll(keepingCapacity: false)
                                        self.custPhoneNumber.removeAll(keepingCapacity: false)
                                        self.leadCreationDate.removeAll(keepingCapacity: false)
                                        self.productName.removeAll(keepingCapacity: false)
                                        self.leadID.removeAll(keepingCapacity: false)
                                        self.giverName.removeAll(keepingCapacity: false)
                                        self.giverEmail.removeAll(keepingCapacity: false)
                                        self.customerEmail.removeAll(keepingCapacity: false)
                                        self.leadsArray.removeAll(keepingCapacity: false)
                                        
                                        self.AlertMessages(title: "Oops !", message: "No Record Found", actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
                                    }
                                    
                                    if self.leadsArray.count > 0
                                    {
                                        self.leadsArray = self.leadsArray.sorted(by: { $0["date"]?.compare($1["date"]!) == .orderedDescending })
                                        
                                        for lead in self.leadsArray
                                        {
                                            
                                            self.custName.append(lead["name"]!)
                                            self.custPhoneNumber.append(lead["phoneNumber"]!)
                                            self.customerEmail.append(lead["email"]!)
                                            self.leadCreationDate.append(lead["date"]!)
                                            self.productName.append(lead["productName"]!)
                                            self.leadID.append(lead["id"]!)
                                            self.giverName.append(lead["giverName"]!)
                                            self.giverEmail.append(lead["giverEmail"]!)
                                        }
                                        
                                    }
                    
                                    self.tableView.reloadData()
                                }
                                if let mybranchList = element["mybranchList"]
                                {
                                    let listArray = mybranchList as? Array<Any>
                                    if (listArray?.count)! > 0
                                    {
                                        self.custNameBranch.removeAll(keepingCapacity: false)
                                        self.custPhoneNumberBranch.removeAll(keepingCapacity: false)
                                        self.leadCreationDateBranch.removeAll(keepingCapacity: false)
                                        self.productNameBranch.removeAll(keepingCapacity: false)
                                        self.leadIDBranch.removeAll(keepingCapacity: false)
                                        self.giverNameBranch.removeAll(keepingCapacity: false)
                                        self.giverEmailBranch.removeAll(keepingCapacity: false)
                                        self.customerEmailBranch.removeAll(keepingCapacity: false)
                                        
                                        for value in listArray!
                                        {
                                            let lead = AESCrypt.decrypt(value as! String, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                            let leadDetailArray = lead.components(separatedBy: "~")
                                            
                                            self.custNameBranch.append(leadDetailArray[0])
                                            self.custPhoneNumberBranch.append(leadDetailArray[1])
                                            self.customerEmailBranch.append(leadDetailArray[2])
                                            self.leadCreationDate.append(leadDetailArray[3])
                                            self.productNameBranch.append(leadDetailArray[4])
                                            self.leadIDBranch.append(leadDetailArray[5])
                                            self.giverNameBranch.append(leadDetailArray[6])
                                            self.giverEmailBranch.append(leadDetailArray[7])
                                            
                                        }
                                        
                                    }
                                    
                                    
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
        if self.isMyLead
        {
            return custName.count
        }
        else
        {
            return custNameBranch.count
            
        }
        
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
        
        if isMyLead
        {
            productNameLabel.text = custName[indexPath.row]
            assignToLabel.text = productName[indexPath.row]
           
        }
        else
        {
            productNameLabel.text = custNameBranch[indexPath.row]
            assignToLabel.text = productNameBranch[indexPath.row]
        }
        
        
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let leadDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeadDetailsVCIdentifier") as! LeadDetails
        
        if isMyLead
        {
            leadDetailsVC.name = custName[indexPath.row]
            leadDetailsVC.product = productName[indexPath.row]
            leadDetailsVC.mobile = custPhoneNumber[indexPath.row]
            leadDetailsVC.leadID = self.leadID[indexPath.row]
            leadDetailsVC.givername = self.giverName[indexPath.row]
            leadDetailsVC.mail = self.customerEmail[indexPath.row]
            leadDetailsVC.givermail = self.giverEmail[indexPath.row]
            leadDetailsVC.createddate = self.leadCreationDate[indexPath.row]
            
          //  leadDetailsVC.email = [indexPath.row]
           // leadDetailsVC.giverName.text = custName[indexPath.row]
           // leadDetailsVC.giverEmailID.text =
        }
        else
        {
            leadDetailsVC.name = custNameBranch[indexPath.row]
            leadDetailsVC.product = productNameBranch[indexPath.row]
            leadDetailsVC.mobile = custPhoneNumberBranch[indexPath.row]
            leadDetailsVC.leadID = self.leadIDBranch[indexPath.row]
            leadDetailsVC.givername = self.giverNameBranch[indexPath.row]
            leadDetailsVC.mail = self.customerEmailBranch[indexPath.row]
            leadDetailsVC.givermail = self.giverEmailBranch[indexPath.row]
            leadDetailsVC.createddate = self.leadCreationDateBranch[indexPath.row]
            //  leadDetailsVC.email = [indexPath.row]
            // leadDetailsVC.giverName.text = custName[indexPath.row]
            // leadDetailsVC.giverEmailID.text =
        }
        
        self.navigationController?.pushViewController(leadDetailsVC, animated: true)
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
