//
//  Chat.swift
//  trade items
//
//  Created by SHANE COFFEY on 5/8/26.
//

import Foundation

class Chat: Identifiable {
    var id: String
    var message: String
    var sender: String
    
    init(id: String = UUID().uuidString, message: String, sender: String) {
        self.id = id
        self.message = message
        self.sender = sender
    }
}
