//
//  OfferView.swift
//  trade items
//
//  Created by JAMES SCHRAUT on 2/25/26.
//
import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct OfferView: View {
    let ref = Database.database().reference()
    
    @State var selectedMyItemID = ""
    @State var selectedOtherItemID = ""
    @State var tempItemIN = Item(name: "Oxygen", category: ItemCategory(rawValue: "Sports")!, estimatedValue: 0.0, email: "")
    @State var tempItemOUT = Item(name: "Carbon", category: ItemCategory(rawValue: "Sports")!, estimatedValue: 0.0, email: "")
    @State var showMyItems = false
    @State var showOtherItems = false
    
    @State var alertON = false
    
    var body: some View {
        
        NavigationStack {
            
            VStack() {
                
                Text("Create Offer")
                    .font(.largeTitle)
                HStack {
                    VStack{
                        Text("You Receive")
                            .font(.title2)
                        
                        Button {
                            showOtherItems = true
                        } label: {
                            Text(selectedOtherItemID.isEmpty ? "Select Item" : selectedOtherItemID)
                            ItemView(item: tempItemIN)
                        }
                    }
                    
                    VStack{
                        Text("You Give")
                            .font(.title2)
                        
                        Button {
                            showMyItems = true
                        } label: {
                            Text(selectedMyItemID.isEmpty ? "Select Item" : selectedMyItemID)
                            ItemView(item: tempItemIN)
                        }
                    }
                }
                
                Spacer()
                
                Button("Send Offer") {
                    SaveOffer()
                }
                
                Spacer()
            }
            .alert("Offer sent", isPresented: $alertON) {
                
            }
            // sheet is like a popup
            .sheet(isPresented: $showMyItems) {
                SelectItemView(selectedItemId: $selectedMyItemID)
            }
            .sheet(isPresented: $showOtherItems) {
                SelectOtherItemView(selectedItemId: $selectedOtherItemID)
            }
        }
    }
    
    func SaveOffer(){
        guard !selectedMyItemID.isEmpty, !selectedOtherItemID.isEmpty else {
            return
        }
        
        let offerRef = ref.child("offers").childByAutoId()
        
        let offerData: [String: Any] = ["offerIN": selectedOtherItemID, "offerOut": selectedMyItemID]
        
        offerRef.setValue(offerData)
        alertON = true
        
        let itemRef = ref.child("items").child(<#T##pathString: String##String#>)
    }
}
