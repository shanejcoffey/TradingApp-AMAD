//
//  OfferView.swift
//  trade items
//
//  Created by JAMES SCHRAUT on 2/25/26.
//
import SwiftUI

struct OfferView: View {
    var offerIN : Offer
    var body: some View {
        VStack{
            Text("Offer details")
                .font(.largeTitle)
            Spacer()
            
                Spacer()
            HStack{
                Text("You recieve:")
                    .font(.title2)
                NavigationLink(destination: ItemView(item: offerIN.itemIN)) {
                    Circle()
                        .frame(width: 100)
                }
            }
            Spacer()
            HStack{
                
                    Text("You lose:")
                        .font(.title2)
                NavigationLink(destination: ItemView(item: offerIN.itemOUT)) {
                    Circle()
                        .frame(width: 100)
                }
            }
                Spacer()
            
             
            Spacer()
                Spacer()
            
        }
        
    }
}

#Preview {
    OfferView(offerIN: Offer(itemIN: Item(name: "slop", category: ItemCategory(rawValue: "Sports")!, estimatedValue: 0.0, email: "oogabooga"), itemOUT: Item(name: "Gloop", category: ItemCategory(rawValue: "Technology")!, estimatedValue: 10.0, email: "blipblop")))
}
