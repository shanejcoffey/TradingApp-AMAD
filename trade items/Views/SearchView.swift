//
//  SearchView.swift
//  trade items
//
//  Created by JAMES SCHRAUT on 3/2/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct SearchView: View {
    @State var alertON = false
    @State var searchIN = ""
    @State var estValIN = 1.0
    @State var categoryIN = "Sports"
    @State var allItems: [Item] = []
    var body: some View {
        NavigationStack{
            
            Text("Search For Items")
                .font(.largeTitle)
            TextField("Search", text: $searchIN)
                .background {
                    RoundedRectangle(cornerSize: .zero)
                        .foregroundStyle(.teal)
                }
            Text("Filter by:")
            HStack{
                Text("Estimated Value: $\(estValIN, specifier: "%.0f")")
                Stepper("", value: $estValIN)
            }
            Slider(value: $estValIN, in: 1...100, step: 1.0 ) {_ in
                
            }
                

            Text("Select category:")
                .font(.title2)
            Text("Current: \(categoryIN)")
            ScrollView {
                Button {
                    categoryIN = "Sports"
                } label: {
                    ZStack{
                        RoundedRectangle(cornerSize: CGSize(width: 10.0, height: 15.0))
                            .frame(width: 250,height: 35)
                            .foregroundStyle(.blue)
                        Text("Sports")
                            .foregroundStyle(.red)
                            .font(.title)
                    }
                }
                
                Button {
                    categoryIN = "Technology"
                } label: {
                    ZStack{
                        RoundedRectangle(cornerSize: CGSize(width: 10.0, height: 15.0))
                            .frame(width: 250,height: 35)
                            .foregroundStyle(.blue)
                        Text("Technology")
                            .foregroundStyle(.red)
                            .font(.title)
                    }
                }
                
                Button {
                    categoryIN = "Clothing"
                } label: {
                    ZStack{
                        RoundedRectangle(cornerSize: CGSize(width: 10.0, height: 15.0))
                            .frame(width: 250,height: 35)
                            .foregroundStyle(.blue)
                        Text("Clothing")
                            .foregroundStyle(.red)
                            .font(.title)
                    }
                }
            }
                
            Spacer()
            Spacer()
            Spacer()
            NavigationLink {
                FilteredItemsView(items: filter(name: searchIN, category: categoryIN, estVal: estValIN))
            } label: {
                ZStack{
                    Circle()
                        .frame(width: 150)
                    Text("Find Items")
                        .foregroundStyle(.red)
                        .font(.title2)
                }
            }
            
            Spacer()
        }
        .onAppear() {
            loadItems()
        }
        .alert("Invalid search parameters", isPresented: $alertON) {
            
        }
    }
    
    func loadItems() {
        let ref = Database.database().reference().child("items")
        guard let email = Auth.auth().currentUser?.email else {
            return
        }

        ref.observeSingleEvent(of: .value) { snapshot in
            allItems = []

            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                if let dict = snap.value as? [String: Any] {
                    if dict["email"] as! String == email {
                        continue
                    }
                    
                    let item = Item(dict: dict)
                    allItems.append(item)
                    print(allItems)
                }
            }
        }
    }
    
    func filter(name: String, category: String, estVal: Double) -> [Item] {
        var arrayOUT: [Item] = []
        for item in allItems {
            if (name == "" || item.name.lowercased().contains(name.lowercased())) &&
               category == item.category.rawValue &&
               abs(item.estimatedValue - estVal) < 10 {
                arrayOUT.append(item)
            }
        }
        return arrayOUT
    }
}

#Preview {
    SearchView()
}
