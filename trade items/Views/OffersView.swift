//
//  OffersView.swift
//  trade items
//
//  Created by SHANE COFFEY on 3/13/26.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth
import FirebaseCore
import FirebaseStorage

struct OffersView: View {
    
    let ref = Database.database().reference()
    
    @State var loaded = false
    @State var offers: [Offer] = []
    
    var body: some View {
        NavigationStack {
            Text("Incoming offers")
                .font(.title)
            
            List(offers, id: \.offerIN.key) { offer in
                VStack {
                    Text("Offer:")
                        .font(.headline)
                    
                    HStack {
                        VStack {
                            Text("You recieve:")
                            ItemView(item: offer.offerOUT)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("You give:")
                            ItemView(item: offer.offerIN)
                        }
                    }
                }
            }
            .onAppear() {
                if !loaded {
                    loadOffers()
                }
            }
        }
    }
    
    func loadOffers() {
        
        loaded = true
        var dict : [String: Any]
        guard let myEmail = Auth.auth().currentUser?.email else { return }
        dict = ["":3]
        ref.child("offers").observe(.childAdded){snapshot in
            
            guard let doink = snapshot.value as? [String:Any] else { return }
            dict = doink
        }
        
            var itemIN: Item
            var itemOUT: Item
            guard let offerIN = dict["offerIN"] as? String,
                  let offerOUT = dict["offerOUT"] as? String else { return }
            
            ref.child("items").child(offerIN).observeSingleEvent(of: .value) { snapIN in
                    
                guard let dictIN = snapIN.value as? [String:Any] else { return }
                
                itemIN = Item(dict: dictIN)
                itemIN.key = offerIN
                
                if itemIN.email != myEmail { return }
            
            
            ref.child("items").child(offerOUT).
            { snapOUT in
                
                guard let dictOUT = snapOUT.value as? [String:Any] else { return }
                
                itemOUT = Item(dict: dictOUT)
                itemOUT.key = offerOUT
                
                let offer = Offer(itemIN: itemIN, itemOUT: itemOUT)
                
                offers.append(offer)
                 
            }
        }
    }
}

#Preview {
    OffersView()
}
