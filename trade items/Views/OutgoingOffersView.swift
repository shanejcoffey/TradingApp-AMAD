//
//  OffersInView.swift
//  trade items
//
//  Created by SHANE COFFEY on 3/17/26.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct OutgoingOffersView: View {
    
    let ref = Database.database().reference()
    
    var screenWidth: CGFloat = UIScreen.main.bounds.width
    @State var offers: [Offer] = []
    
    var body: some View {
        NavigationStack {
            Text("Outgoing offers")
                .font(.title)
            
            List(offers, id: \.id) { offer in
                OfferOutView(offer: offer)
            }
            .listStyle(.plain)
            .onAppear() {
                offers.removeAll()
                loadOffers()
            }
        }
    }
    
    func loadOffers() {
        guard let myEmail = Auth.auth().currentUser?.email else {
            return
        }
        
        ref.child("offers").observe(.childAdded) { snapshot in
            guard let dict = snapshot.value as? [String:Any],
                  let offerIN = dict["offerIN"] as? String,
                  let offerOUT = dict["offerOut"] as? String,
                  let fromUID = dict["fromUID"] as? String else {
                return
            }

            ref.child("items").child(offerOUT).observeSingleEvent(of: .value) { snapIN in
                guard let dictOUT = snapIN.value as? [String:Any] else {
                    return
                }

                let itemOUT = Item(dict: dictOUT)
                itemOUT.key = offerOUT

                if itemOUT.email != myEmail {
                    return
                }

                ref.child("items").child(offerIN).observeSingleEvent(of: .value) { snapIN in
                    guard let dictIN = snapIN.value as? [String:Any] else { return }

                    let itemIN = Item(dict: dictIN)
                    itemIN.key = offerIN

                    let offer = Offer(offerIN: itemIN, offerOUT: itemOUT, id: snapshot.key, fromUID: fromUID)

                    DispatchQueue.main.async {
                        offers.append(offer)
                    }
                }
            }
        }
    }
}

#Preview {
    OffersInView()
}
