//
//  RescueApiManager.swift
//  GoodTime
//
//  Created by Andrey Kasatkin on 9/29/18.
//  Copyright © 2018 Andrey Kasatkin. All rights reserved.
//

import UIKit

class RescueApiManager: NSObject {
    
    static let shared = RescueApiManager()
    var connectivityHandler = WatchSessionManager.shared
    
    func getLatestTime(completionHandler: @escaping (_ result: Bool) -> ()){
        print("getting time")
        let task = URLSession.shared.dataTask(with: getUrl()) { data, response, error in
            guard error == nil else {
                print(error ?? "error")
                completionHandler(false)
                return
            }
            guard let data = data else {
                print("Data is empty")
                completionHandler(false)
                return
            }
            
            print(response)
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            let labelMessage = self.extractLabelMessage(json: json)
            
            //persist data
            UserDefaults.standard.set(labelMessage, forKey: "time")
            let totalTime = UserDefaults.standard.integer(forKey: "totalTime")
            
            //sync data to watch when you have a moment
            do {
                try self.connectivityHandler.updateApplicationContext(applicationContext: ["time" : labelMessage,
                                                                                           "totalTime" : totalTime ])
            } catch {
                print("Error: \(error)")
            }
            
            completionHandler(true)
        }
        
        task.resume()
        
    }
    
    func getUrl() -> URL {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "y-MM-dd"
        let currentDay = myFormatter.string(from: Date())
        
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")
        let infoDict = NSDictionary(contentsOfFile: path!)
        let apiKey = infoDict!["RescueTimeAPIKey"] as! String
        
        
        return URL(string: "https://www.rescuetime.com/anapi/data?key=\(apiKey)&perspective=interval&restrict_kind=overview&interval=minute&restrict_begin=\(currentDay)&restrict_end=\(currentDay)&format=json")!
    }
    
    func extractLabelMessage(json: NSDictionary) -> String {
        let rows = json["rows"] as! NSArray as! [NSArray]
        
        var totalTime = 0
        for row in rows {
            totalTime += row[1] as! Int
        }
        
        //persist totalTime
        UserDefaults.standard.set(totalTime, forKey: "totalTime")
        
        let hours = totalTime/60/60
        let minutes = totalTime/60 % 60
        //let seconds = totalTime % 60
        
        var labelMessage = ""
        if hours > 0 {
            labelMessage += "\(hours):"
        } else {
            labelMessage += "0:"
        }
        if minutes > 0 {
            labelMessage += "\(minutes)"
        } else {
            labelMessage += "00"
        }
        
        return labelMessage
    }
}

