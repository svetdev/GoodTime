//
//  InterfaceController.swift
//  GoodTime WatchKit Extension
//
//  Created by Andrey Kasatkin on 9/28/18.
//  Copyright © 2018 Andrey Kasatkin. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {

    // 1: Session property
    private var session = WCSession.default
    var connectivityHandler = WatchSessionManager.shared

    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    @IBOutlet weak var lastUpdatedTime: WKInterfaceLabel!
    
   
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    
        let currentTime = UserDefaults.standard.string(forKey: "time") ?? ""
        if !currentTime.isEmpty{
            self.timeLabel.setText(currentTime)
        }
        
        let lastUpdated = UserDefaults.standard.string(forKey: "lastUpdated") ?? ""
        if !lastUpdated.isEmpty{
            self.lastUpdatedTime.setText(lastUpdated)
        }
    }
    
    override func willActivate() {
        super.willActivate()
        connectivityHandler.startSession()
        connectivityHandler.watchOSDelegate = self
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    private func isSuported() -> Bool {
        return WCSession.isSupported()
    }
    
    private func isReachable() -> Bool {
        return session.isReachable
    }

    @IBAction func updateClicked() {
        if isReachable() {
            session.sendMessage(["request" : "time"], replyHandler: { (response) in
                
                guard let time = response["time"] else {
                    return
                }
                
                //persist data on watch
                UserDefaults.standard.set(time, forKey: "time")
                self.timeLabel.setText("\(time)")
                
            }, errorHandler: { (error) in
                print("Error sending message: %@", error)
            })
        } else {
            print("iPhone is not reachable!!")
        }
    }
}

extension InterfaceController: WatchOSDelegate {
    func applicationContextReceived(tuple: ApplicationContextReceived) {
        DispatchQueue.main.async() {
            if let time = tuple.applicationContext["time"] as? String {
                
                UserDefaults.standard.set(time, forKey: "time")
                self.timeLabel.setText("\(time)")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                let lastUpdated = dateFormatter.string(from: NSDate() as Date)
                self.lastUpdatedTime.setText("\(lastUpdated)")
                 UserDefaults.standard.set(lastUpdated, forKey: "lastUpdated")
            }
            
            if let totalTime = tuple.applicationContext["totalTime"] as? Int {
                UserDefaults.standard.set(totalTime, forKey: "totalTime")
            }
            
            if let d = WKExtension.shared().delegate as? ExtensionDelegate
            {
                d.scheduleNextBackgroundRefresh()
                d.scheduleSnapshotNow()
            }
            
            ComplicationController.refreshComplication()
        }
    }
    
    func messageReceived(tuple: MessageReceived) {
        DispatchQueue.main.async() {
            WKInterfaceDevice.current().play(.notification)
            if let msg = tuple.message["msg"] {
            
                UserDefaults.standard.set(msg, forKey: "time")
                self.timeLabel.setText("\(msg)")
            }
        }
    }
    
}
