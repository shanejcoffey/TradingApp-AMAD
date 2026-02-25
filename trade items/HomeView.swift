//
//  HomeView.swift
//  trade items
//
//  Created by JAMES SCHRAUT on 2/23/26.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    @State var Username: String
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        Text("Welcome back \(Username)")
            .font(.largeTitle)
        
        Button("Sign out") {
            signOut()
        }
        .tint(.red)
        
        Spacer()
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
    HomeView(Username: "blob")
}
