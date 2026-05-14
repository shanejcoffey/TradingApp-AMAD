//
//  Offer.swift
//  trade items
//
//  Created by JAMES SCHRAUT on 3/11/26.
//

import Foundation
class Offer {
    
    var id: String = ""
    var offerIN: Item
    var offerOUT: Item
    var fromUID: String
    var chats: [String]
    
    init(offerIN: Item, offerOUT: Item, id: String, fromUID: String) {
        self.offerIN = offerIN
        self.offerOUT = offerOUT
        self.id = id
        self.fromUID = fromUID
        self.chats = []
    }
}
