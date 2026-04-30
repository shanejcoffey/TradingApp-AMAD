//
//  SettingsView.swift
//  trade items
//
//  Created by SHANE COFFEY on 4/22/26.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {

    @State var showSignOutConfirmation: Bool = false
    @Binding var isSignedIn: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section(header: Text("User info")) {
                Text("User info")
            }

            Section(header: Text("Account actions")) {
                HStack {
                    Text("Sign out")
                        .foregroundStyle(.red)
                }
                .onTapGesture {
                    showSignOutConfirmation = true
                }
            }
        }
        .alert("Sign out", isPresented: $showSignOutConfirmation) {
            Button("Cancel", role: .cancel) {

            }

            Button("Sign out", role: .destructive) {
                signOut()
                isSignedIn = false
                dismiss()
            }
        } message: {
            Text("Would you like to sign out?")
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            dismiss()
            isSignedIn = false
        } catch {
            print("Sign out error: \(error.localizedDescription)")
        }
    }
}
