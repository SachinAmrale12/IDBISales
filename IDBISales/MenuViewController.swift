//
//  MenuViewController.swift
//  IDBISales
//
//  Created by Sachin Amrale on 29/07/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let contentArray                    = ["Reports","Logout"]
    @IBOutlet weak var menuTableView    : UITableView!
    var parrentViewInstance             : SecondViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuTableView.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialize(instance :SecondViewController)
    {
        parrentViewInstance = instance
    }
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return contentArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 150
        }
        else
        {
            return 60
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
           // cell?.contentView.backgroundColor = uico
            
            let userImage = cell?.viewWithTag(1) as! UIImageView
            userImage.image = UIImage(named: "defaultUser.png")
            userImage.layer.cornerRadius = userImage.frame.size.width / 2
            
            let userName = cell?.viewWithTag(2) as! UILabel
            userName.text = JNKeychain.loadValue(forKey: "userID") as? String
            
            let userID = cell?.viewWithTag(3) as! UILabel
            userID.numberOfLines = 2
            userID.text = JNKeychain.loadValue(forKey: "emailID") as? String
            
            return cell!
        }
            
        else{
           let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell")
            
            let userImage = cell?.viewWithTag(1) as! UIImageView
            userImage.image = UIImage(named: "defaultUser.png")
            userImage.layer.cornerRadius = userImage.frame.size.width / 2
            
            let userName = cell?.viewWithTag(2) as! UILabel
            userName.text = contentArray[indexPath.row - 1]
            
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 1
        {
            self.performSegue(withIdentifier: "reportVCIdentifier", sender: nil)
        }
        if indexPath.row == 2
        {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}
