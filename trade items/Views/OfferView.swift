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
    
    @Environment(\.dismiss) private var dismiss
    
    @State var selectedMyItem: Item? = nil
    @State var selectedOtherItem: Item
    
    @State var alertON = false
    @State var showMyItems = false
    
    var body: some View {
        NavigationStack {
            VStack() {
                Text("Offer for \(selectedOtherItem.name)")
                    .font(.largeTitle)
                
                HStack {
                    VStack {
                        Text("You Receive")
                            .font(.title2)
                        ItemView(item: selectedOtherItem)
                    }
                    
                    VStack {
                        Text("You Give")
                            .font(.title2)
                        
                        Button {
                            showMyItems = true
                        } label: {
                            if let myItem = selectedMyItem {
                                ItemView(item: myItem)
                            } else {
                                Text("Select Item")
                                    .foregroundStyle(.secondary)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(.gray))
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button("Send Offer") {
                    SaveOffer()
                }
                .disabled(selectedMyItem == nil)
                
                Spacer()
            }
            .alert("Offer sent", isPresented: $alertON) {
                Button("Ok") {
                    dismiss()
                }
            }
            .sheet(isPresented: $showMyItems) {
                SelectItemView(selectedItem: $selectedMyItem)
            }
        }
    }
    
    func SaveOffer(){
        guard let myItem = selectedMyItem else {
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let offerRef = ref.child("offers").childByAutoId()
        let offerData: [String: Any] = ["offerIN": selectedOtherItem.key, "offerOut": myItem.key, "fromUID": uid]
        
        offerRef.setValue(offerData)
        alertON = true
        
        let itemRef = ref.child("items").child(<#T##pathString: String##String#>)
    }
}
