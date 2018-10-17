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
}

let dummyPost = Post(username: "SleepyHead", text: "Soda is amazing")


