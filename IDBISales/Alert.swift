//
//  Alert.swift
//  IDBISales
//
//  Created by Sachin Amrale on 04/08/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func AlertMessages(title: String?, message: String?, actionTitle:String?, alertStyle:UIAlertControllerStyle, actionStyle:UIAlertActionStyle, handler:((UIAlertAction) -> Void)?){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        let action = UIAlertAction(title: actionTitle, style: actionStyle, handler: handler)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension String {
    
    func stringReplace() -> String
    {
        return self.replacingOccurrences(of: "/", with: ":~:")
    }
}

extension UITextField {
    func drawUnderLineForTextField()
    {
        self.layoutIfNeeded()
        let underLineView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1))
        underLineView.backgroundColor = UIColor(red: (25.0/255.0), green: (111.0/255.0), blue: (61.0/255.0), alpha: 1.0)
        self.addSubview(underLineView)
    }
}


extension UILabel {
    func drawUnderLineForLabel()
    {
        self.layoutIfNeeded()
        let underLineView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1))
        underLineView.backgroundColor = UIColor.orange
        self.addSubview(underLineView)
    }
}
