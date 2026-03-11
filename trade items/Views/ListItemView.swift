//
//  PostItemView.swift
//  trade items
//
//  Created by JAMES SCHRAUT on 2/26/26.
//

import SwiftUI
import FirebaseAuth

struct ListItemView: View {
    
    @State var nameIN = ""
    @State var estValueIN = 0.0
    @State var categoryIN: ItemCategory = .sports
    @State var alertON = false
    
    var body: some View {
        Text("List Item")
            .font(.largeTitle)
        TextField("Enter name", text: $nameIN)
        
            .frame(width: 100)
//        TextField("Enter estimated value", text: $nameIN)
//            .frame(width: 180)
        Spacer()
        
        HStack{
            Spacer()
            Text("Estimated value: $\(estValueIN, specifier: "%.0f")")
            Stepper("", value: $estValueIN)
            Spacer()
        }
        
        Slider(value: $estValueIN, in: 1...100, step: 1.0 ) {
            
        }
        
        Spacer()
        
        Text("Select category")
            .font(.title)
        
        HStack{
            Button {
                categoryIN = .technology
            } label: {
                ZStack{
                    Circle()
                        .frame(width: 100)
                    Text("Technology")
                        .foregroundStyle(.red)
                        .font(.title3)
                }
            }
            
            Button {
                categoryIN = .sports
            } label: {
                ZStack{
                    Circle()
                        .frame(width: 100)
                    Text("Sports")
                        .foregroundStyle(.red)
                        .font(.title3)
                }
            }
            
            Button {
                categoryIN = .clothing
            } label: {
                ZStack{
                    Circle()
                        .frame(width: 100)
                    Text("Clothing")
                        .foregroundStyle(.red)
                        .font(.title3)
                }
            }

        }
        
        Text("Selected category: \(categoryIN)")
        
        Spacer()
        Spacer()
        Spacer()
        
        Button {
            let tempItem = Item(name: nameIN, category: categoryIN, estimatedValue: estValueIN, email: (Auth.auth().currentUser?.email)!)
            tempItem.save()
            alertON = true
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius: 20, style: .circular)
                    .frame(width: 150, height: 100)
                Text("Create item")
                    .foregroundStyle(.red)
                    .font(.title2)
            }
        }
        .alert("Item listed", isPresented: $alertON) {
            
        }
        
        Spacer()
        Spacer()
        Spacer()
    }
        
}

#Preview {
    ListItemView()
}
