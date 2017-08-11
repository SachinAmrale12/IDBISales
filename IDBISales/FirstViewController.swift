//
//  FirstViewController.swift
//  IDBISales
//
//  Created by Amit Dhadse on 11/08/17.
//  Copyright © 2017 Amit Dhadse. All rights reserved.
//

import UIKit
import ReachabilitySwift
import Charts

class FirstViewController: UIViewController {

    
    
    var sideMenu                        = MVYSideMenuController()
    let networkReachability             = Reachability()
    @IBOutlet var loaderView              : UIView!
    var loader                          : MaterialLoadingIndicator!
    var totalLead                       : String!
    var leadOpen                        : String!
    var leadClose                       : String!
    //secondVC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loader = MaterialLoadingIndicator(frame: self.loaderView.bounds)
        self.loaderView.addSubview(loader)
        self.loaderView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let encryptedFlag = AESCrypt.encrypt("G", password: DataManager.SharedInstance().getKeyForEncryption()).stringReplace()
        self.callReportsService(flag: encryptedFlag)
    }
    
    
    func updateChartData()  {
        
        let chart = PieChartView(frame: self.view.frame)
        let track = ["Total Leads", "Leads Close", "Leads Open"]
        let money = [Double(self.totalLead), Double(self.leadClose), Double(self.leadOpen)]
        
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value!
            entry.label = track[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "Giver")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        
        for _ in 0..<money.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        let data = PieChartData(dataSet: set)
        chart.data = data
        chart.noDataText = "No data available"
        // user interaction
        chart.isUserInteractionEnabled = true
        
        let d = Description()
        d.text = "iOSCharts.io"
        chart.chartDescription = d
        chart.centerText = "Pie Chart"
        chart.holeRadiusPercent = 0.2
        chart.transparentCircleColor = UIColor.clear
        self.view.addSubview(chart)
        
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
                                    self.totalLead = valuesArray[0]
                                    self.leadClose = valuesArray[1]
                                    self.leadOpen = valuesArray[2]
                                    
                                    self.updateChartData()
                                }
                                if let message = element["message"]
                                {
                                    let message = AESCrypt.decrypt(message as! String, password: DataManager.SharedInstance().getKeyForEncryption()) as String
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
    
    @IBAction func addLeadsClicked(_ sender: Any)
    {
        self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addLeadVCIndentifier"), animated: true)
    }
    @IBAction func viewLeadsClicked(_ sender: Any)
    {
        self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "secondVC"), animated: true)
    }
    
    @IBAction func menuButtonClicked(_ sender: Any)
    {
        sideMenu = self.sideMenuController()
        if (sideMenu != nil)
        {
            sideMenu.openMenu()
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
