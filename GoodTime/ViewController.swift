//
//  ViewController.swift
//  GoodTime
//
//  Created by Andrey Kasatkin on 9/28/18.
//  Copyright © 2018 Andrey Kasatkin. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {

    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var buttomInfo: UILabel!
    var connectivityHandler = WatchSessionManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector:#selector(ViewController.refreshScreen), name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         //self.activityIndicator.startAnimating()
         self.exectueRequest()
         self.refreshScreen()
    }
    
    

    @objc func refreshScreen(){
        let labelMessage = UserDefaults.standard.string(forKey: "time")
        self.totalTimeLabel.text = labelMessage
        
        let numberOfFetches = UserDefaults.standard.integer(forKey: "numberOfFetches")
        self.buttomInfo.text = "Number of fetches = \(numberOfFetches)"
    }
    
    func exectueRequest(){
        
        RescueApiManager.shared.getLatestTime(completionHandler: { result in
            if (result){
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    let labelMessage = UserDefaults.standard.string(forKey: "time")
                    self.totalTimeLabel.text = labelMessage
                }
            }
            else{
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.totalTimeLabel.text = "can't get the data"
                }
                
            }
        })
        }
}

extension ViewController: iOSDelegate {
    
    func applicationContextReceived(tuple: ApplicationContextReceived) {
        DispatchQueue.main.async() {
            if let row = tuple.applicationContext["row"] as? Int {
                
            }
        }
    }
    
    func messageReceived(tuple: MessageReceived) {
        // Handle receiving message
        
        guard let reply = tuple.replyHandler else {
            return
        }
        
        // Need reply to counterpart
        switch tuple.message["request"] as! RequestType.RawValue {
        case RequestType.time.rawValue:
            let currentTime = UserDefaults.standard.string(forKey: "time") ?? ""
            reply(["time" : currentTime])
        default:
            break
        }
    }
    
}
