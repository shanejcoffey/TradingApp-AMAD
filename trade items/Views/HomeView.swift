//
//  HomeView.swift
//  trade items
//
//  Created by JAMES SCHRAUT on 2/23/26.
//

import FirebaseAuth
import FirebaseDatabase
import SwiftUI

struct HomeView: View {

    var user: User? {
        Auth.auth().currentUser
    }
    @Environment(\.dismiss) private var dismiss
    @State private var selection: Int = 2
    @State var incomingOffers = 0
    @State var isSignedIn: Bool = true
    @State var showSettingsView: Bool = false
    let ref = Database.database().reference()
    
    @State var firstItem: Item?
    @State var firstOffer: Offer?
    
    var body: some View {

        VStack {
            HStack {
                Spacer()
                Button {
                    showSettingsView = true
                } label: {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                }
                .frame(width: 30, height: 30)
                .padding(.trailing, 30)
            }

            TabView(selection: $selection) {
                Tab("Outgoing", systemImage: "arrow.up.square.fill", value: 0) {
                    OutgoingOffersView()
                }

                Tab("My Items", systemImage: "archivebox", value: 1) {
                    ListedItemsView()
                }

                Tab("Home", systemImage: "house", value: 2) {
                    WelcomeView(isSignedIn: $isSignedIn, selection: $selection, firstItem: $firstItem, firstOffer: $firstOffer)
                }

                Tab("Browse", systemImage: "list.bullet.rectangle", value: 3) {
                    FindItemView(firstItem: firstItem)
                }

                Tab("Incoming", systemImage: "arrow.down.square.fill", value: 4) {
                    OffersView(firstOffer: firstOffer)
                }
                .badge(incomingOffers)
            }
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            .onChange(of: isSignedIn) {
                if !isSignedIn {
                    dismiss()
                }
            }
        }
        .onAppear {
            loadOffers()
        }
        .sheet(isPresented: $showSettingsView) {
            SettingsView(isSignedIn: $isSignedIn)
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
                            incomingOffers += 1
                            print(incomingOffers)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
