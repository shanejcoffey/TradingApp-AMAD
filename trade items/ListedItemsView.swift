//
//  ListedItemsView.swift
//  trade items
//
//  Created by JAMES SCHRAUT on 2/24/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct ListedItemsView: View {
    
    let ref = Database.database().reference()
    
    @State var items: [Item] = []
    @State var loadedFirebase = false
    
    var body: some View {
        VStack {
            Text("Your Listed Items:")
                .font(.largeTitle)
            
            List(items, id: \.key) { item in
                ItemView(item: item)
                    .swipeActions {
                        Button("Delete") {
                            item.delete()
                        }
                        .tint(.red)
                    }
            }
        }
        .onAppear {
            // boolean prevents the observers from being created twice which would cause items to be duplicated
            if !loadedFirebase {
                loadedFirebase = true
                firebaseStuff()
            }
        }
    }
    
    func firebaseStuff() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let itemsRef = ref.child("users").child(uid).child("items")
        
        itemsRef.observe(.childAdded) { snapshot in
            guard let itemID = snapshot.value as? String else { return }
                
            ref.child("items").child(itemID).observeSingleEvent(of: .value) { snap in
                guard let dict = snap.value as? [String: Any] else { return }
                let item = Item(dict: dict)
                item.key = itemID
                items.append(item)
            }
        }
        
        itemsRef.observe(.childRemoved) { snapshot in
            // remove all items where the key == snapshot key
            items.removeAll { $0.key == snapshot.key }
        }
        
        itemsRef.observe(.childChanged) { snapshot in
            guard let itemID = snapshot.value as? String else { return }
            
            ref.child("items").child(itemID).observe(.value) { snap in
                guard let dict = snap.value as? [String: Any] else { return }
                guard let index = items.firstIndex(where: { $0.key == itemID }) else { return }
                
                let updatedItem = Item(dict: dict)
                updatedItem.key = itemID
                items[index] = updatedItem
            }
        }
    }
}

#Preview {
    ListedItemsView()
}
