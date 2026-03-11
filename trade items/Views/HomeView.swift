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
    @State private var selection: Int = 0
    
    var body: some View {
        VStack {
            
            Text("Welcome back \(user?.email ?? "uh oh")")
                .font(.largeTitle)
            // Text("Id: \(user?.uid ?? "uh oh")")
            Button("sign out") {
                signOut()
            }
            
            Spacer()
            
            TabView(selection: $selection) {
                Tab("hello world", systemImage: "house", value: 0) {
                    HomeScreenView()
                }
                
                Tab("Post", systemImage: "hare", value: 1) {
                    ListItemView()
                }
                
                Tab("Your items", systemImage: "sharedwithyou", value: 2) {
                    ListedItemsView()
                }
                
                Tab("Search", systemImage: "magnifyingglass", value: 3) {
                    SearchView()
                }
                
                Tab("All items", systemImage: "list.clipboard", value: 4) {
                    FindItemView()
                }
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
