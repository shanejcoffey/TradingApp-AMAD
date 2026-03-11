//
//  FindItemView.swift
//  trade items
//
//  Created by SHANE COFFEY on 3/2/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct FindItemView: View {
    
    let ref = Database.database().reference()
    @State var testText = "hi"
    
    @State var items: [Item] = []
    
    var body: some View {
        VStack {
            Text("Other's Listed Items:")
                .font(.largeTitle)
            
            Text(testText)
            
            List(items, id: \.key) { item in
                ItemView(item: item)
            }
        }
        .onAppear {
            items.removeAll()
            getItems()
        }
    }
    
    func getItems() {
        let itemsRef = ref.child("items")
        
        itemsRef.observe(.childAdded) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            if dict["email"] as? String == Auth.auth().currentUser?.email { return }
            
            var item = Item(dict: dict)
            item.key = snapshot.key
            items.append(item)
        }
        
        itemsRef.observe(.childRemoved) { snapshot in
            items.removeAll { $0.key == snapshot.key }
        }
        
        itemsRef.observe(.childChanged) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            guard let index = items.firstIndex(where: { $0.key == snapshot.key }) else { return }
            
            var updatedItem = Item(dict: dict)
            updatedItem.key = snapshot.key
            items[index] = updatedItem
        }
    }
}

#Preview {
    FindItemView()
}
