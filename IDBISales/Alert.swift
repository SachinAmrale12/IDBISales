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
