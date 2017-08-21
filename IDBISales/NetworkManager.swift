//
//  NetworkManager.swift
//  IDBISales
//
//  Created by Sachin Amrale on 18/08/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager: NSObject
{
    var manager: SessionManager?
    
    override init() {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "http://10.144.118.20:1919": .pinCertificates(
                certificates: ServerTrustPolicy.certificates(),
                validateCertificateChain: true,
                validateHost: true
            ),
            "insecure.expired-apis.com": .disableEvaluation
        ]
        
        manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }
}
