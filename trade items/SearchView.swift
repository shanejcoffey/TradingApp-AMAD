//
//  SearchView.swift
//  trade items
//
//  Created by JAMES SCHRAUT on 3/2/26.
//

import SwiftUI

struct SearchView: View {
    @State var alertON = false
    @State var searchIN = ""
    @State var estValueSearch = 1.0
    @State var categoryIN = "sports"
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
                Text("Estimated Value: $\(estValueSearch, specifier: "%.0f")")
                Stepper("", value: $estValueSearch)
            }
            Slider(value: $estValueSearch, in: 1...100, step: 1.0 ) {_ in 
                
            }
                

            Text("Select category:")
                .font(.title2)
            Text("Current: \(categoryIN)")
            ScrollView {
                Button {
                    categoryIN = "sports"
                } label: {
                    ZStack{
                        RoundedRectangle(cornerSize: CGSize(width: 10.0, height: 15.0))
                            .frame(width: 250,height: 35)
                            .foregroundStyle(.blue)
                        Text("Sports")
                            .foregroundStyle(.red)
                            .font(.title)
                    }
                }
                
                Button {
                    categoryIN = "technology"
                } label: {
                    ZStack{
                        RoundedRectangle(cornerSize: CGSize(width: 10.0, height: 15.0))
                            .frame(width: 250,height: 35)
                            .foregroundStyle(.blue)
                        Text("Technology")
                            .foregroundStyle(.red)
                            .font(.title)
                    }
                }
                
                Button {
                    categoryIN = "clothing"
                } label: {
                    ZStack{
                        RoundedRectangle(cornerSize: CGSize(width: 10.0, height: 15.0))
                            .frame(width: 250,height: 35)
                            .foregroundStyle(.blue)
                        Text("Clothing")
                            .foregroundStyle(.red)
                            .font(.title)
                    }
                }
            }
            
            
            
            
            
            
            Spacer()
            Spacer()
            Spacer()
            Button {
                if estValueSearch < 1 {
                    estValueSearch = 1
                }
                
            } label: {
                ZStack{
                    Circle()
                        .frame(width: 150)
                    Text("Search")
                        .foregroundStyle(.red)
                        .font(.title2)
                }
            }
            
            Spacer()
        }
        .alert("Invalid search parameters", isPresented: $alertON) {
            
        }
    }
}

#Preview {
    SearchView()
}
