//
//  WelcomeView.swift
//  trade items
//
//  Created by SHANE COFFEY on 3/16/26.
//

import FirebaseAuth
import FirebaseDatabase
import SwiftUI

struct WelcomeView: View {

    @Environment(\.dismiss) private var dismiss
    @Binding var isSignedIn: Bool
    @Binding var selection: Int
    @Binding var firstItem: Item?
    @Binding var firstOffer: Offer?

    let ref = Database.database().reference()

    @State var item: Item? = nil
    @State var item2: Item? = nil

    @State var offer: Offer? = nil
    @State private var didFindOffer = false

    var body: some View {
        VStack {
            Text("Item Trader")
                .font(.largeTitle)

            Spacer()
            if let item = item {
                Text("For you")
                    .font(.title2)
                    .bold()
                HStack {
                    ItemView(item: item)
                        .onTapGesture {
                            selection = 3
                            firstItem = item
                        }

                    if let item2 = item2 {
                        ItemView(item: item2)
                            .onTapGesture {
                                selection = 3
                                firstItem = item2
                            }
                    }
                }
            } else {
                Text("No items on the market")
            }

            Divider()
                .padding(.vertical, 10)

            if let o = offer {
                Text("Incoming offer")
                    .font(.title2)
                    .bold()

                OfferInView(offer: o)
                    .onTapGesture {
                        selection = 4
                        firstOffer = offer
                    }
            } else {
                Text("No incoming offers")
            }

            Spacer()
        }
        .onAppear {
            loadItems()
            loadOffers()
        }
    }

    func loadItems() {
        guard let myEmail = Auth.auth().currentUser?.email else {
            return
        }

        ref.child("items").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else {
                return
            }

            for (id, itemData) in value {
                guard let dict = itemData as? [String: Any] else {
                    return
                }
                if dict["email"] as? String != myEmail {
                    if item == nil {
                        item = Item(dict: dict)
                        item!.key = id
                    } else {
                        item2 = Item(dict: dict)
                        item2!.key = id
                    }
                }
            }
        }
    }

    func loadOffers() {
        ref.child("offers").observeSingleEvent(of: .value) { snapshot in
            guard let offersDict = snapshot.value as? [String: [String: Any]]
            else {
                return
            }

            for (offerId, offerInfo) in offersDict {
                guard let itemInId = offerInfo["offerIN"] as? String,
                    let itemOutId = offerInfo["offerOut"] as? String
                else {
                    continue
                }

                ref.child("items").child(itemInId).observeSingleEvent(
                    of: .value
                ) { snapIn in
                    guard let dictIn = snapIn.value as? [String: Any] else {
                        return
                    }
                    let itemIn = Item(dict: dictIn)

                    ref.child("items").child(itemOutId).observeSingleEvent(
                        of: .value
                    ) { snapOut in
                        guard let dictOut = snapOut.value as? [String: Any]
                        else {
                            return
                        }
                        let itemOut = Item(dict: dictOut)

                        if itemIn.email == Auth.auth().currentUser?.email {
                            offer = Offer(
                                offerIN: itemIn,
                                offerOUT: itemOut,
                                id: offerId,
                                fromUID: itemOutId
                            )
                        }
                    }
                }
            }
        }
    }
}
