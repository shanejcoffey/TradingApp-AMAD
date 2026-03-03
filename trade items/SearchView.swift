//
//  SearchView.swift
//  trade items
//
//  Created by JAMES SCHRAUT on 3/2/26.
//

import SwiftUI

struct SearchView: View {
    @State var searchIN = ""
    @State var estValueSearch = 0.0
    var body: some View {
        NavigationStack{
            
            Text("Search For Items")
                .font(.largeTitle)
            TextField("Search", text: $searchIN)
                .background {
                    RoundedRectangle(cornerSize: .zero)
                        .foregroundStyle(.teal)
                }
            Text("Filter by:")
            HStack{
                Text("Estimated Value: \(estValueSearch, specifier: "%.0f")")
                Stepper("", value: $estValueSearch)
            }
            Slider(value: $estValueSearch, in: 1...100, step: 1.0 ) {
                
            }
                
                

            
            
            
            
            
            
            
            Spacer()
            Spacer()
            Spacer()
            NavigationLink {
                
            } label: {
                ZStack{
                    Circle()
                        .frame(width: 150)
                    Text("See results")
                        .foregroundStyle(.red)
                        .font(.title2)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    SearchView()
}
