//
//  LeadDetails.swift
//  IDBISales
//
//  Created by Amit Dhadse on 08/08/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit

class LeadDetails: UIViewController {

   
    override func viewDidLoad() {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
