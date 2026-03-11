//
//  ContentView.swift
//  trade items
//
//  Created by SHANE COFFEY on 2/20/26.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @State var email = ""
    @State var password = ""
    @State var isLoggedIn = false
    @State var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Trading App")
                    .font(.largeTitle)
                
                Spacer()
                
                Text("Login")
                    .font(.title)
                
                HStack {
                    VStack {
                        
                        TextField("Input email", text: $email)
                            .offset(x: 60)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        
                        SecureField("Input password", text: $password)
                            .offset(x:60)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                        
                    }
                    
                    Button {
                        login()
                    } label: {
                        ZStack{
                            Circle()
                                .frame(width: 100)
                            Text("Login")
                                .foregroundStyle(.red)
                        }
                        .offset(x: -50)
                    }
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                }
                
                NavigationLink("Create new Account", destination: CreateAccountView())
                
                Spacer()
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $isLoggedIn) {
                HomeView()
            }
            .onAppear() {
                if Auth.auth().currentUser != nil {
                    isLoggedIn = true
                }
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let e = error {
                errorMessage = e.localizedDescription
                isLoggedIn = false
                return
            }
            
            guard result?.user != nil else {
                errorMessage = "Failed to login"
                isLoggedIn = false
                return
            }
            
            errorMessage = ""
            isLoggedIn = true
        }
    }
}

#Preview {
    ContentView()
}


/*
 {
 qopejr:
    Item
    Item
 rwrwerwerf:
    Item
 }
 */
