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
    @State var items: [Item] = []
    @State var filtered: [Item] = []
    
    @State var selectedItem: Item? = nil
    
    @State var showFilterSheet = false
    @State var searchIN = ""
    @State var estValIN = 0.0
    @State var categoryIN: ItemCategory? = nil
    @State var useEstimatedValue = false
    @State var useCategory = false
    
    @State var firstItem: Item?
    
    var body: some View {
        VStack {
            HStack {
                Text("Other's Listed Items:")
                    .font(.largeTitle)
                
                Spacer()
                
                Button("Filter") {
                    showFilterSheet = true
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background(Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            List(filtered, id: \.key) { item in
                ItemView(item: item)
                    .onTapGesture {
                        selectedItem = item
                    }
            }
        }
        .onAppear {
            items.removeAll()
            getItems()
        }
        .sheet(item: $selectedItem) { item in
            OfferView(selectedOtherItem: item)
        }
        .sheet(isPresented: $showFilterSheet) {
            SearchView(searchIN: $searchIN, estValIN: $estValIN, categoryIN: $categoryIN, useEstimatedValue: $useEstimatedValue, useCategory: $useCategory)
        }
        .onChange(of: searchIN) {
            getItems()
        }
        .onChange(of: estValIN) {
            getItems()
        }
        .onChange(of: categoryIN) {
            getItems()
        }
    }
    
    func getItems() {
        let itemsRef = ref.child("items")
        guard let email = Auth.auth().currentUser?.email else { return }
        
        itemsRef.observeSingleEvent(of: .value) { snapshot in
            var allItems: [Item] = []
            
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                if let dict = snap.value as? [String: Any], dict["email"] as? String != email {
                    
                    let key = snap.key
                    
                    if !allItems.contains(where: { $0.key == key }) {
                        let item = Item(dict: dict)
                        item.key = key
                        allItems.append(item)
                    }
                }
            }
            items = allItems
            filter()
        }
    }
    
    func filter() {
        // items.filter does a loop and if its true then it keeps it
        var result = items.filter { item in
            let matchesName = searchIN.isEmpty || item.name.lowercased().contains(searchIN.lowercased())
            let matchesValue = !useEstimatedValue || abs(estValIN - item.estimatedValue) <= 10
            let matchesCategory = !useCategory || item.category == categoryIN
            return matchesName && matchesCategory && matchesValue
        }
        
        print("firstItem: \(firstItem?.key ?? "no item")")
        if let selected = firstItem,
           let index = result.firstIndex(where: { $0.key == selected.key }) {
            
            let item = result.remove(at: index)
            result.insert(item, at: 0)
        }
        
        filtered = result
    }
}

#Preview {
    FindItemView()
}
