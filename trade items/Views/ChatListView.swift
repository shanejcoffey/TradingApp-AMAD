//
//  ChatListView.swift
//  trade items
//
//  Created by SHANE COFFEY on 5/12/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

// this cleans up code a lot by storing stuff together
struct ChatPreview: Identifiable {
    var id: String
    var itemIn: Item
    var itemOut: Item
    var lastMessage: String
}

struct ChatsListView: View {

    @State private var chats: [ChatPreview] = []
    let ref = Database.database().reference()

    var body: some View {
        NavigationStack {
            VStack {
                Text("Chats")
                    .font(.largeTitle)
                
                List {
                    ForEach(chats) { chat in
                        NavigationLink {
                            ChatView(offerID: chat.id)
                        } label: {
                            HStack(spacing: 12) {
                                if let base64 = chat.itemIn.imageStrings.first,
                                   let uiImage = chat.itemIn.base64ToUIImage(base64) {
                                    
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 55, height: 55)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    
                                    Text("Trading \(chat.itemIn.name) and \(chat.itemOut.name)")
                                        .font(.headline)
                                        .lineLimit(1)
                                    
                                    Text(chat.lastMessage)
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                        .lineLimit(1)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
            }
        }
        .onAppear {
            loadChats()
        }
    }

    func loadChats() {

        guard let email = Auth.auth().currentUser?.email else {
            return
        }

        ref.child("offers")
            .observeSingleEvent(of: .value) { snapshot in

                guard let offersDict = snapshot.value as? [String: [String: Any]] else {
                    return
                }

                var loadedChats: [ChatPreview] = []

                for (offerID, offerInfo) in offersDict {
                    guard
                        let itemInId = offerInfo["offerIN"] as? String,
                        let itemOutId = offerInfo["offerOut"] as? String
                    else {
                        continue
                    }

                    let group = DispatchGroup()

                    var itemIn: Item?
                    var itemOut: Item?

                    group.enter() // not fully sure what this does but it does something to fix timing with Firebase pulls
                    ref.child("items").child(itemInId).observeSingleEvent(of: .value) { snap in
                        if let dict = snap.value as? [String: Any] {
                            itemIn = Item(dict: dict)
                        }
                        group.leave()
                    }

                    group.enter()
                    ref.child("items").child(itemOutId).observeSingleEvent(of: .value) { snap in
                        if let dict = snap.value as? [String: Any] {
                            itemOut = Item(dict: dict)
                        }
                        group.leave()
                    }

                    group.notify(queue: .main) {

                        guard let itemIn, let itemOut else {
                            return
                        }

                        if itemIn.email == email || itemOut.email == email {
                            self.ref.child("offers")
                                .child(offerID)
                                .child("chats")
                                .queryLimited(toLast: 1)
                                .observeSingleEvent(of: .value) { chatSnap in

                                    var lastMessage = "No messages yet"

                                    for child in chatSnap.children {
                                        if let snap = child as? DataSnapshot,
                                           let dict = snap.value as? [String: Any],
                                           let message = dict["message"] as? String {
                                            lastMessage = message
                                        }
                                    }

                                    let preview = ChatPreview(
                                        id: offerID,
                                        itemIn: itemIn,
                                        itemOut: itemOut,
                                        lastMessage: lastMessage
                                    )

                                    DispatchQueue.main.async {
                                        loadedChats.append(preview)
                                        self.chats = loadedChats
                                    }
                                }
                        }
                    }
                }
            }
    }
}
