//
//  CreateAccountView.swift
//  trade items
//
//  Created by JAMES SCHRAUT on 2/23/26.
//

import SwiftUI
import FirebaseAuth

struct CreateAccountView: View {
    @State var email = ""
    @State var password = ""
    @State var errorMessage = ""
    @State var alertON = false
    var body: some View {
        NavigationStack{
            VStack {
                
                Text("Trading App")
                    .font(.largeTitle)
                
                Spacer()
                
                Text("Create Account")
                    .font(.title)
                
                HStack {
                    VStack {
                        TextField("Input new email", text: $email)
                            .offset(x: 60)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        
                        SecureField("Input new password", text: $password)
                            .offset(x: 60)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                    }
                    
                    Button {
                        if password.count < 6 {
                            alertON = true
                        } else {
                            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                                errorMessage = String(describing: error)
                            }
                        }
                    } label: {
                        ZStack{
                            Circle()
                                .frame(width: 100)
                            Text("Create")
                                .foregroundStyle(.red)
                        }
                        .offset(x: -50)
                    }
                }
                
                if errorMessage != "nil" && !errorMessage.isEmpty {
                    Text(errorMessage)
                }
                
                Spacer()
                Spacer()
            }
            .padding()
        }
        .alert("Password must be at least 6 characters", isPresented: $alertON) {
            
        }
    }
}

#Preview {
    CreateAccountView()
}
