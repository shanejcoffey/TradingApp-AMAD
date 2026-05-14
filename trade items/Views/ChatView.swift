//
//  ChatView.swift
//  trade items
//
//  Created by SHANE COFFEY on 5/7/26.
//

import FirebaseAuth
import FirebaseDatabase
import SwiftUI

struct ChatView: View {

    @State var offerID: String
    @State var chats: [Chat] = []
    @State private var item: Item?
    @State var message: String = ""
    @State var showFinalizeWarning = false

    let ref = Database.database().reference()

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    if let item = item {
                        if let base64 = item.imageStrings.first,
                            let uiImage = item.base64ToUIImage(base64)
                        {

                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 70)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(.headline)

                            Text("Trade chat")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }

                        Spacer()
                    }
                }

                Button {
                    showFinalizeWarning = true
                } label: {
                    Text("Finalize Trade")
                        .frame(maxWidth: .infinity)
                        .padding(10)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
            .padding()

            Divider()

            if let uid = Auth.auth().currentUser?.uid {
                VStack {
                    List {
                        ForEach(chats, id: \.id) { chat in
                            HStack {
                                if chat.sender == uid {
                                    Spacer()
                                }
                                ZStack {
                                    Text(chat.message)
                                        .padding()
                                        .background(
                                            chat.sender == uid ? .green : .gray,
                                            in: RoundedRectangle(
                                                cornerRadius: 15
                                            )
                                        )

                                }
                                if chat.sender != uid {
                                    Spacer()
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)

                    HStack(spacing: 12) {
                        TextField("Message", text: $message)
                            .padding(12)
                            .background(Color(.systemGray6))  // systemGray6 is like an off white color so it slightly stands out
                            .clipShape(RoundedRectangle(cornerRadius: 20))

                        Button {
                            sendMessage(uid: uid)
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .foregroundStyle(.white)
                                .padding(12)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, 10)
                }
                .onAppear {
                    getChats()
                }
            } else {
                Text("error")
            }
        }
        .onAppear {
            loadItem()
        }
        .alert("Finalize Trade?", isPresented: $showFinalizeWarning) {
            Button("Cancel", role: .cancel) { }
            Button("Finalize", role: .destructive) {
                finishTrade()
            }
        } message: {
            Text("Are you sure? This will delete the involved items and chat history.")
        }
    }

    func finishTrade() {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        let offerRef = ref.child("offers").child(offerID)

        offerRef.observeSingleEvent(of: .value) { snapshot in

            guard
                let offerData = snapshot.value as? [String: Any],
                let offerIN = offerData["offerIN"] as? String,
                let offerOUT = offerData["offerOut"] as? String,
                let fromUID = offerData["fromUID"] as? String
            else {
                return
            }

            ref.child("items").child(offerIN).removeValue()
            ref.child("items").child(offerOUT).removeValue()

            ref.child("users").child(uid).child("items").child(offerIN).removeValue()
            ref.child("users").child(fromUID).child("items").child(offerOUT).removeValue()

            ref.child("offers").child(offerID).removeValue()

            ref.child("offers").observeSingleEvent(of: .value) { snapshot in

                for case let snap as DataSnapshot in snapshot.children {

                    guard let dict = snap.value as? [String: Any],
                          let tempInKey = dict["offerIN"] as? String,
                          let tempOutKey = dict["offerOut"] as? String else {
                        continue
                    }

                    if tempInKey == offerIN || tempInKey == offerOUT ||
                        tempOutKey == offerIN || tempOutKey == offerOUT {

                        ref.child("offers").child(snap.key).removeValue()
                    }
                }
            }
        }
    }

    func sendMessage(uid: String) {

        let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            return
        }

        let chatRef = ref.child("offers").child(offerID).child("chats")
            .childByAutoId()

        let values: [String: Any] = [
            "message": trimmed,
            "sender": uid,
            "timestamp": ServerValue.timestamp(),
        ]

        chatRef.setValue(values)

        message = ""
    }

    func getChats() {

        ref.child("offers").child(offerID).child("chats").observe(
            .value,
            with: { snapshot in

                var loadedChats: [Chat] = []

                for child in snapshot.children {

                    guard
                        let snap = child as? DataSnapshot,
                        let dict = snap.value as? [String: Any],
                        let message = dict["message"] as? String,
                        let sender = dict["sender"] as? String
                    else {
                        continue
                    }

                    loadedChats.append(
                        Chat(id: snap.key, message: message, sender: sender)
                    )
                }

                DispatchQueue.main.async {
                    self.chats = loadedChats
                }
            }
        )
    }

    func loadItem() {

        let offerRef = ref.child("offers").child(offerID)

        offerRef.observeSingleEvent(of: .value) { snapshot in

            guard
                let offerData = snapshot.value as? [String: Any],
                let offerIN = offerData["offerOut"] as? String  // they are backwards in firebase
            else {
                return
            }

            let itemRef = ref.child("items").child(offerIN)

            itemRef.observeSingleEvent(of: .value) { itemSnapshot in

                guard
                    let dict = itemSnapshot.value as? [String: Any]
                else {
                    return
                }

                let loadedItem = Item(dict: dict)

                DispatchQueue.main.async {
                    self.item = loadedItem
                }
            }
        }
    }
}
