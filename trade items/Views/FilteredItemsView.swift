//
//  FilteredItemsView.swift
//  trade items
//
//  Created by SHANE COFFEY on 3/5/26.
//

import SwiftUI

struct FilteredItemsView: View {
    
    @State var items: [Item]
    
    var body: some View {
        VStack {
            Text("Filtered Items:")
                .font(.largeTitle)
            
            List(items, id: \.key) { item in
                ItemView(item: item)
            }
        }
    }
}
