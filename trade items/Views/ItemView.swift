//
//  ItemView.swift
//  trade items
//
//  Created by SHANE COFFEY on 2/24/26.
//

import SwiftUI

struct ItemView: View {
    
    @State var item: Item
    var screenWidth: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .circular)
                .frame(width: screenWidth * 0.4, height: screenWidth * 0.4 / 1.618)
                .foregroundStyle(.gray)
            VStack(alignment: .leading) {
                Spacer()
                Text("\(item.name)")
                        .font(.title)
                HStack {
                    Text("\(item.category.rawValue)")
                    if item.estimatedValue != 0 {
                        Spacer()
                        Text("$\(item.estimatedValue, specifier: "%.2f")")
                    }
                }
                .frame(maxWidth: screenWidth * 0.4, maxHeight: screenWidth * 0.4)
                Spacer()
            }
            .frame(maxWidth: screenWidth * 0.4 * 0.8, maxHeight: screenWidth * 0.4 / 1.618 * 3/4)
        }
    }
}

#Preview {
    ItemView(item: Item(name: "Basketball", category: .sports, estimatedValue: 20, email: "test@gmail.com"))
}
