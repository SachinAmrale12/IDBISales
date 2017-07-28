//
//  ViewController.swift
//  IDBISales
//
//  Created by Amit Dhadse on 28/07/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var userIdTextField          : RaisePlaceholder!
    @IBOutlet weak var passwordTextField        : RaisePlaceholder!
    @IBOutlet weak var loginButton              : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.commonInitialization()
        
    }

    func commonInitialization()
    {
        userIdTextField.animationDuration = 0.5
        userIdTextField.subjectColor = UIColor.orange
        userIdTextField.underLineColor = UIColor.orange
        
        passwordTextField.animationDuration = 0.5
        passwordTextField.subjectColor = UIColor.orange
        passwordTextField.underLineColor = UIColor.orange
        
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
        loginButton.layer.borderColor = UIColor.orange.cgColor
        loginButton.layer.borderWidth = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

