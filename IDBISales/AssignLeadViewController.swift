//
//  AssignLeadViewController.swift
//  IDBISales
//
//  Created by Amit Dhadse on 10/08/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit

class AssignLeadViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate {

    
    
    
    private let autocompleteViewForAssign                   = LUAutocompleteView()
    private let autocompleteViewForCityForAssign            = LUAutocompleteView()
    private let autocompleteViewForBranchForAssign          = LUAutocompleteView()

    
    @IBOutlet var takerMailID           : UITextField!
    @IBOutlet var branchTextField       : UITextField!
    @IBOutlet var stateTextField        : UITextField!
    @IBOutlet var cityTextField         : UITextField!
    @IBOutlet var remarkTextView        : UITextView!
    @IBOutlet var assignButton          : UIButton!
    
    @IBAction func assignClicked(_ sender: Any) {
    }
    @IBAction func backButtonClicked(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.commonInitialization()

        // Do any additional setup after loading the view.
    }
    
    //MARK:  commonInitialization
    
    func commonInitialization()
    {
        stateTextField.drawUnderLineForTextField()
        cityTextField.drawUnderLineForTextField()
        branchTextField.drawUnderLineForTextField()
        takerMailID.drawUnderLineForTextField()
        
        assignButton.layer.cornerRadius = assignButton.frame.size.height / 2
        assignButton.layer.borderColor = UIColor.orange.cgColor
        assignButton.layer.borderWidth = 1
        
        remarkTextView.layer.cornerRadius = 1
        remarkTextView.layer.borderColor = UIColor.orange.cgColor
        remarkTextView.layer.borderWidth = 1
        
    }
    
    //MARK: textfield delegate
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == stateTextField
        {
            
        }
       
        
        return true
    }

    ////MARK: textfield delegate
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        return true
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
