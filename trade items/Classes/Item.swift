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
import SwiftUI

// CaseIterable allows ItemCategory.allCases
enum ItemCategory: String, Codable, CaseIterable {
    case clothing = "Clothing"
    case technology = "Technology"
    case sports = "Sports"
    
}

extension ItemCategory {
    var imageName: String {
        switch self {
        case .clothing: return "tshirt"
        case .sports: return "soccerball"
        case .technology: return "tv"
        default: return "globe"
        }
    }
}

class Item: ObservableObject, Identifiable {
    var ref = Database.database().reference()
    var name: String
    var category: ItemCategory
    var estimatedValue: Double
    var email: String
    var imageStrings: [String]
    var key = ""
    
    @MainActor
    init(name: String, category: ItemCategory, estimatedValue: Double, email: String, images: [Image]) {
        self.name = name
        self.category = category
        self.estimatedValue = estimatedValue
        self.email = email
        self.imageStrings = []
        
        for image in images {
            if let uiImage = convertToUIImage(image: image),
               let data = uiImage.jpegData(compressionQuality: 0.3) {
                let base64 = data.base64EncodedString()
                imageStrings.append(base64)
            }
        }
    }
    //pull from FBase
    init(dict:[String : Any]){
        name = dict["name"] as! String
        let categoryString = dict["category"] as? String ?? ""
        category = ItemCategory(rawValue: categoryString) ?? .sports
        estimatedValue = dict["estimatedValue"] as! Double
        email = dict["email"] as! String
        imageStrings = dict["images"] as? [String] ?? []
    }
    
    func toDict() -> [String: Any] {
        return [
            "name": name,
            "category": category.rawValue,
            "estimatedValue": estimatedValue,
            "email": email,
            "images": imageStrings
        ]
    }
    
    @MainActor func save(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let newRef = ref.child("items").childByAutoId()
        key = newRef.key ?? ""
        newRef.setValue(toDict())
        
        ref.child("users").child(uid).child("items").child(key).setValue(key)
    }
    
    func delete() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("items").child(key).removeValue()
    }
    
    func update() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ref.child("items").child(key).updateChildValues(toDict())
    }
    
    @MainActor func convertToUIImage(image: Image) -> UIImage? {
        let renderer = ImageRenderer(content: image)
        return renderer.uiImage
    }
    
    func base64ToUIImage(_ base64: String) -> UIImage? {
        guard let data = Data(base64Encoded: base64) else { return nil }
        return UIImage(data: data)
    }
}
