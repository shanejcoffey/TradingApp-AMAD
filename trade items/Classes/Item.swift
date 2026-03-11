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

class Item: ObservableObject {
    var ref = Database.database().reference()
    var name: String
    var category: ItemCategory
    var estimatedValue: Double
    var email: String
    var key = ""
    
    init(name: String, category: ItemCategory, estimatedValue: Double, email: String) {
        self.name = name
        self.category = category
        self.estimatedValue = estimatedValue
        self.email = email
    }
    //pull from FBase
    init(dict:[String : Any]){
        name = dict["name"] as! String
        let categoryString = dict["category"] as? String ?? ""
        category = ItemCategory(rawValue: categoryString) ?? .sports
        estimatedValue = dict["estimatedValue"] as! Double
        email = dict["email"] as! String
    }
    
    func toDict() -> [String: Any] {
        return [
            "name": name,
            "category": category.rawValue,
            "estimatedValue": estimatedValue,
            "email": email
        ]
    }
    
    func save(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let newRef = ref.child("items").childByAutoId()
        key = newRef.key ?? ""
        newRef.setValue(toDict())
        ref.child("users").child(uid).child("items").childByAutoId().setValue(key)
    }
    
    func delete() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("items").child(key).removeValue()
    }
    
    func update() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ref.child("items").child(key).updateChildValues(toDict())
    }
}
