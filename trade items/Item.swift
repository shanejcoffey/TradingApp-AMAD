//
//  Item.swift
//  trade items
//
//  Created by SHANE COFFEY on 2/23/26.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase




enum ItemCategory: String {
    case clothing = "Clothing"
    case technology = "Technology"
    case sports = "Sports"
    
}

class Item {
    var ref = Database.database().reference()
    var name: String
    var category: ItemCategory
    var estimatedValue: Double
    
    init(name: String, category: ItemCategory, estimatedValue: Double) {
        self.name = name
        self.category = category
        self.estimatedValue = estimatedValue
    }
    //pull from FBase
    init(dict:[String : Any]){
        name = dict["name"] as! String
        category = dict["category"] as! ItemCategory
        estimatedValue = dict["estimatedValue"] as! Double
    }
    
    func save(){
        let dict = ["name":name, "category":category, "estimatedValue":estimatedValue] as [String : Any]
        ref.child("Item").childByAutoId().setValue(dict)
    }
    
    
}
