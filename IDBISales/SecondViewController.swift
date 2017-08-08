//
//  SecondViewController.swift
//  IDBISales
//
//  Created by Sachin Amrale on 29/07/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var sideMenu                    = MVYSideMenuController()
    var productName                 = [String]()
    var assignTo                    = [String]()
    var productNameLabel            : UILabel!
    var assignToLabel            : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commonInitialization()
        //sideMenu.disable()
    }
    
    
    func commonInitialization()
    {
        productName.append("car Loan")
        productName.append("home loan")
        productName.append("bike loan")
        productName.append("home loan")

        
        assignTo.append("Amit")
        assignTo.append("Sachin")
        assignTo.append("vikrant")
        assignTo.append("nish")
        
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
    @IBAction func addLeadButtonClicked(_ sender: Any)
    {
        self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addLeadVCIndentifier"), animated: true)
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
        
        productNameLabel.text = productName[indexPath.row]
        assignToLabel.text = assignTo[indexPath.row]
        
        
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
