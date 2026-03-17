//
//  OffersView.swift
//  trade items
//
//  Created by SHANE COFFEY on 3/13/26.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct OffersView: View {
    
    let ref = Database.database().reference()
    
    var screenWidth: CGFloat = UIScreen.main.bounds.width
    
    @State var offers: [Offer] = []
    
    var body: some View {
        NavigationStack {
            Text("Incoming offers")
                .font(.title)
            
            List(offers, id: \.id) { offer in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        
                        VStack {
                            Text("You recieve:")
                                .font(.headline)
                            ItemView(item: offer.offerOUT)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("You give:")
                                .font(.headline)
                            ItemView(item: offer.offerIN)
                        }
                    }
                    
                    HStack {
                        Button("Accept") {
                            acceptOffer(offer)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        .frame(maxWidth: .infinity)
                        
                        Spacer()
                        
                        Button("Decline") {
                            declineOffer(offer)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .shadow(radius: 5)
            }
            .listStyle(.plain)
            .onAppear() {
                offers.removeAll()
                loadOffers()
            }
        }
    }
    
    func acceptOffer(_ offer: Offer) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let inKey = offer.offerIN.key
        let outKey = offer.offerOUT.key
        
        ref.child("items").child(inKey).removeValue()
        ref.child("items").child(outKey).removeValue()
        ref.child("users").child(uid).child("items").child(inKey).removeValue()
        ref.child("users").child(offer.fromUID).child("items").child(outKey).removeValue()
        
        ref.child("offers").child(offer.id).removeValue()
        
        ref.child("offers").observeSingleEvent(of: .value) { snapshot in
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                if let dict = snap.value as? [String:Any],
                   let tempInKey = dict["offerIN"] as? String,
                   let tempOutKey = dict["offerOut"] as? String,
                   (tempInKey == outKey || tempInKey == inKey || tempOutKey == outKey || tempOutKey == inKey) {
                    ref.child("offers").child(snap.key).removeValue()
                    offers.removeAll {$0.id == snap.key}
                }
            }
        }
        
        offers.removeAll {$0.id == offer.id}
    }
    
    func declineOffer(_ offer: Offer) {
        ref.child("offers").child(offer.id).removeValue()
        offers.removeAll {$0.id == offer.id}
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

            ref.child("items").child(offerIN).observeSingleEvent(of: .value) { snapIN in
                guard let dictIN = snapIN.value as? [String:Any] else {
                    return
                }

                let itemIN = Item(dict: dictIN)
                itemIN.key = offerIN

                if itemIN.email != myEmail {
                    return
                }

                ref.child("items").child(offerOUT).observeSingleEvent(of: .value) { snapOUT in
                    guard let dictOUT = snapOUT.value as? [String:Any] else { return }

                    let itemOUT = Item(dict: dictOUT)
                    itemOUT.key = offerOUT

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
    OffersView()
}
