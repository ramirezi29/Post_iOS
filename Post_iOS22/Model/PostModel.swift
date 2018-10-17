//
//  PostModel.swift
//  Post_iOS22
//
//  Created by Ivan Ramirez on 10/15/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import Foundation


struct Post: Codable {
    let username: String
    let text: String
    let timestamp: TimeInterval
    
    init(username: String, text: String) {
        self.username = username
        self.text = text
        self.timestamp = Date().timeIntervalSince1970
    }

    var timestampAsString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        let date = Date(timeIntervalSince1970: self.timestamp)
        
        
        return formatter.string(from: date)
    }
    
//    var dataAsString: String? {
//        let formatter = DateIntervalFormatter()
//        formatter.dateStyle = .none
//        formatter.timeStyle = .short
//        return formatter.string(from: timestamp)
//    }
}
