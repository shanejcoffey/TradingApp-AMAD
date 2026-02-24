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
                Text("\(item.name)")
                        .font(.title)
                HStack {
                    Text("\(item.category.rawValue)")
                }
            }
        }
    }
}

#Preview {
    ItemView(item: Item(name: "Basketball", category: .sports, estimatedValue: 20))
}
