//
//  Offer.swift
//  trade items
//
//  Created by JAMES SCHRAUT on 3/11/26.
//

import Foundation
class Offer{
    
    var itemIN: Item
    var itemOUT: Item
    var valueGap = 0.0
    
    init(itemIN: Item, itemOUT: Item) {
        self.itemIN = itemIN
        self.itemOUT = itemOUT
        self.valueGap = abs(itemOUT.estimatedValue - itemIN.estimatedValue)
    }
    
    
    
    
    
    
    
    
    
}
