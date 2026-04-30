//
//  OfferInfoView.swift
//  trade items
//
//  Created by SHANE COFFEY on 4/22/26.
//

import SwiftUI

struct OfferInView: View {

    @State var offer: Offer

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {

                VStack {
                    Text("You give:")
                        .font(.headline)
                    ItemView(item: offer.offerIN)
                }

                Spacer()

                VStack {
                    Text("You receive:")
                        .font(.headline)
                    ItemView(item: offer.offerOUT)
                }
            }
        }
        .padding()
        .shadow(radius: 1)
    }
}
