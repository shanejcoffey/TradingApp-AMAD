//
//  PostItemView.swift
//  trade items
//
//  Created by JAMES SCHRAUT on 2/26/26.
//

import SwiftUI
import FirebaseAuth
import PhotosUI

struct ListItemView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var images: [Image] = []
    
    @State var nameIN = ""
    @State var estValueIN = 0.0
    @State var categoryIN: ItemCategory = .clothing
    @State var alertON = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("List Item")
                .font(.largeTitle)
                .bold()
            
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Item Name")
                    .font(.headline)
                    .padding(.horizontal)
                TextField("Enter name", text: $nameIN)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
            }
            
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Estimated value: $\(estValueIN, specifier: "%.0f")")
                    .font(.headline)
                    .padding(.horizontal)
                
                HStack {
                    Button {
                        if estValueIN > 1 {
                            estValueIN -= 1
                        }
                    } label: {
                        Image(systemName: "minus.rectangle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.red.opacity(0.9))
                    }
                    
                    Slider(value: $estValueIN, in: 1...100, step: 1)
                        .tint(.green)
                    
                    Button {
                        if estValueIN < 100 {
                            estValueIN += 1
                        }
                    } label: {
                        Image(systemName: "plus.rectangle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.green.opacity(0.9))
                    }
                }
                .padding(.horizontal)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Category")
                    .font(.headline)
                    .padding(.horizontal)
                
                HStack(spacing: 20) {
                    ForEach(ItemCategory.allCases, id: \.self) { category in
                        Button {
                            categoryIN = category
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(categoryIN == category ? .blue.opacity(0.9) : .gray.opacity(0.7))
                                    .frame(width: 100, height: 100)
                                
                                Text(category.rawValue)
                                    .foregroundStyle(.white)
                                    .font(.title3)
                                    .multilineTextAlignment(.center)
                                    .padding(5)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            TabView {
                ForEach(0..<images.count, id: \.self) { i in
                    images[i]
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .onChange(of: selectedImages) {
                Task {
                    images.removeAll()
                    
                    for image in selectedImages {
                        if let image = try? await image.loadTransferable(type: Image.self) {
                            images.append(image)
                        }
                    }
                }
            }
            
            PhotosPicker("Select images", selection: $selectedImages, matching: .images)
            
            Button {
                let tempItem = Item(name: nameIN, category: categoryIN, estimatedValue: estValueIN, email: (Auth.auth().currentUser?.email)!, images: images)
                tempItem.save()
                alertON = true
            } label: {
                Text("Create Item")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .alert("Item listed", isPresented: $alertON) {
            Button("Ok") {
                nameIN = ""
                estValueIN = 0.0
                categoryIN = .clothing
                dismiss()
            }
        }
    }
        
}

#Preview {
    ListItemView()
}
