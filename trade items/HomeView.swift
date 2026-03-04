//
//  HomeView.swift
//  trade items
//
//  Created by JAMES SCHRAUT on 2/23/26.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    var user: User? {
        Auth.auth().currentUser
    }
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("Welcome back \(user?.email ?? "uh oh")")
                    .font(.largeTitle)
                Text("Id: \(user?.uid ?? "uh oh")")
                Button("sign out") {
                    signOut()
                }
                Spacer()
                HStack{
                    NavigationLink {
                        ListItemView()
                    } label: {
                        ZStack{
                            Circle()
                                .frame(width: 150)
                            Text("Post Item")
                                .foregroundStyle(.red)
                                .font(.title2)
                        }
                    }
                    
                    NavigationLink {
                        SearchView()
                    } label: {
                        ZStack{
                            Circle()
                                .frame(width: 150)
                            Text("Search Items")
                                .foregroundStyle(.red)
                                .font(.title2)
                        }
                    }
                }
                HStack{
                    NavigationLink {
                        OfferView()
                    } label: {
                        ZStack{
                            Circle()
                                .frame(width: 150)
                            Text("See Offers")
                                .foregroundStyle(.red)
                                .font(.title2)
                        }
                    }
                    
                    
                    NavigationLink {
                        ListedItemsView()
                    } label: {
                        ZStack{
                            Circle()
                                .frame(width: 150)
                            Text("See listed items")
                                .foregroundStyle(.red)
                                .font(.title2)
                        }
                    }
                }
                Spacer()
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            dismiss()
        } catch {
            print("Sign out error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    HomeView()
}
