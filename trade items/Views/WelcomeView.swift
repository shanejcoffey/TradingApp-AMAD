//
//  WelcomeView.swift
//  trade items
//
//  Created by SHANE COFFEY on 3/16/26.
//

import SwiftUI
import FirebaseAuth

struct WelcomeView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Text("Hello, World!")
        Button("sign out") {
            signOut()
        }
        .tint(.red)
        .padding(.vertical)
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
    WelcomeView()
}
