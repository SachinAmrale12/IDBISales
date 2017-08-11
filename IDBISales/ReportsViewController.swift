//
//  ReportsViewController.swift
//  IDBISales
//
//  Created by Sachin Amrale on 05/08/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit
import Charts
import ReachabilitySwift

class ReportsViewController: UIViewController {

    let networkReachability                 = Reachability()
    var encryptedFlag                       : String!
    var leadOpen                            : String!
    var leadClose                           : String!
    @IBOutlet weak var loaderView           : UIView!
    var loader                              : MaterialLoadingIndicator!
    @IBOutlet weak var reportContainerView  : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loader = MaterialLoadingIndicator(frame: self.loaderView.bounds)
        self.loaderView.addSubview(loader)
        self.loaderView.isHidden = true
       // self.updateChartData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonClicked(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateChartData()  {
        
        let chart = PieChartView(frame: self.view.frame)
        // 2. generate chart data entries
        let track = ["Leads Close", "Leads Open"]
        let money = [Double(self.leadClose), Double(self.leadOpen)]
        
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value!
            entry.label = track[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        colors.append(UIColor(red: (236.0/255.0), green: (147.0/255.0), blue: (88.0/255.0), alpha: 1.0))
        colors.append(UIColor(red: (25.0/255.0), green: (111.0/255.0), blue: (61.0/255.0), alpha: 1.0))
        
//        for _ in 0..<money.count {
//            let red = Double(arc4random_uniform(256))
//            let green = Double(arc4random_uniform(256))
//            let blue = Double(arc4random_uniform(256))
//            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
//            colors.append(color)
//        }
        set.colors = colors
        let data = PieChartData(dataSet: set)
        chart.data = data
        chart.noDataText = "No data available"
        // user interaction
        chart.isUserInteractionEnabled = true
        
        let d = Description()
        d.text = nil
        chart.chartDescription = d
        chart.centerText = "Leads"
        chart.holeRadiusPercent = 0.15
        chart.frame = self.reportContainerView.bounds
        chart.transparentCircleColor = UIColor.clear
        self.reportContainerView.addSubview(chart)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.encryptedFlag = AESCrypt.encrypt("T", password: DataManager.SharedInstance().getKeyForEncryption()).stringReplace()
        self.callReportsService(flag: encryptedFlag)
    }
    
    func callReportsService(flag: String)
    {
        if (networkReachability?.isReachable)!
        {
            self.loaderView.isHidden = false
            self.loader.startAnimating()
            
            DataManager.getReports(ein: JNKeychain.loadValue(forKey: "encryptedCustID") as! String, clientId: JNKeychain.loadValue(forKey: "encryptedClientID") as! String, flg: flag, completionClouser: { (isSuccessful, error, result) in
                
                self.loaderView.isHidden = true
                self.loader.stopAnimating()
                
                if isSuccessful
                {
                    if let element = result as? NSDictionary
                    {
                        if let error = element["error"]
                        {
                            let error = AESCrypt.decrypt(error as! String, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                            print(error)
                            if error == "NA"
                            {
                                if let value = element["value"]
                                {
                                    let value = AESCrypt.decrypt(value as! String, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                    print(value)
                                    let valuesArray = value.components(separatedBy: "~")
                                    self.leadClose = valuesArray[1]
                                    self.leadOpen = valuesArray[2]
                                    
                                    self.updateChartData()
                                }
                                if let message = element["message"]
                                {
                                    let message = AESCrypt.decrypt(message as! String, password: DataManager.SharedInstance().getKeyForEncryption()) as String
                                    print(message)
                                }
                            }
                            else
                            {
                                self.AlertMessages(title: "Error", message: error, actionTitle: "OK", alertStyle: .alert, actionStyle: .cancel, handler: nil)
                                return
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

    override func didReceiveMemoryWarning() {
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
