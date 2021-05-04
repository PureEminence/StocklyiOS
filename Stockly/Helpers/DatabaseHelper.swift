//
//  DatabaseHelper.swift
//  Stockly
//
//  Created by Matt Owen on 4/24/21.
//

import SDWebImage
import UIKit
import Firebase
import FirebaseDatabase
import Foundation


final class DatabaseHelper {
    
    static let shared = DatabaseHelper()
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid.description
    let displayName = Auth.auth().currentUser!.displayName
    
    
    //create new conversation ----------------------------------------------------
    
    public func createNewConvo(with otherUserID: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        
        let messageDate = firstMessage.sentDate
       
        print("other ID \(otherUserID)")
        //get message from firstmessage and deal with message cases
        var message = ""
        switch firstMessage.kind {
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        //data handler for db insert
        let newConvData: [String: Any] = [
            "id": uid,
            "otherUserID": otherUserID,
            "name": "self",
            "latestMessage": [
                "id": firstMessage.messageId,
                "date": messageDate,
                "message": message,
                "isRead": false
            ]
        ]
        
        let otherNewConvData: [String: Any] = [
            "id": otherUserID,
            "otherUserID": uid,
            "name": firstMessage.sender.displayName,
            "latestMessage": [
                "id": firstMessage.messageId,
                "date": messageDate,
                "message": message,
                "isRead": false
            ]
        ]
        
        let messages: [String: Any] = [
            "id": firstMessage.messageId,
            "name": firstMessage.sender.displayName,
            "otherUserID": otherUserID,
            "type": firstMessage.kind.description,
            "content": message,
            "date": firstMessage.sentDate,
            "sender": uid,
            "isRead": false
        ]
        
        let latestMessage: [String: Any] = [
                "id": firstMessage.messageId,
                "date": messageDate,
                "message": message,
                "isRead": false
        ]
        //Check if conversation exists then create new doc or append to existing
         let docRef = db.collection("account").document(uid)
        docRef.collection("conversations").whereField("otherUserID", isEqualTo: otherUserID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                
                } else {//if snapshot is empty create new doc
                    if querySnapshot!.isEmpty {
                        docRef.collection("conversations").document(otherUserID)
                            .setData(newConvData)
                        docRef.collection("conversations").document(otherUserID)
                            .collection("messages").document(firstMessage.messageId)
                            .setData(messages)
                    } else {
                        //if doc exists add message to messages
                        docRef.collection("conversations").document(otherUserID)
                            .collection("messages").document(firstMessage.messageId)
                            .setData(messages)
                        docRef.collection("conversations").document(otherUserID).updateData(["latestMessage" : latestMessage])
                    }
                }
            }
        
        //adds convo to other user db
        print("Other user id \(otherUserID)")
        let otherDocRef = db.collection("account").document(otherUserID)
            otherDocRef.collection("conversations").whereField("otherUserID", isEqualTo: uid)
            .getDocuments() { [self] (snap, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                
                } else { //if snapshot is empty create new doc
                    if snap!.isEmpty {
                        otherDocRef.collection("conversations").document(uid)
                            .setData(otherNewConvData)
                        otherDocRef.collection("conversations").document(uid)
                            .collection("messages").document(firstMessage.messageId)
                            .setData(messages)
                    } else {
                        //if doc exists add message to messages
                        otherDocRef.collection("conversations").document(uid)
                            .collection("messages").document(firstMessage.messageId)
                            .setData(messages)
                        otherDocRef.collection("conversations").document(uid).updateData(["latestMessage" : latestMessage])
                    }
                }
            }
    }
    
    
    // Get all conversations ------------------------------------------------------
    
    
    public func getAllConvo(for otherUserID: String, _ completion: @escaping (_ data: [Conversation]) -> Void) { //pull all user convo
        
        var conversations = [Conversation]()
        
         db.collection("account").document(uid)
            .collection("conversations")
            .getDocuments { (snap, err) in
                if snap!.isEmpty {
                    print("No conversations")
                } else {
                    for doc in snap!.documents {
                        
                        let id = doc.documentID
                        let name = doc.get("name") as! String
                        let otherUserID = doc.get("otherUserID") as! String
                        let latestMessageDict = doc.get("latestMessage") as! Dictionary<String, Any>
                        
                        
                        
                        var latestMessageStruct = [String: Any]()
                        for(key, value) in latestMessageDict {
                            latestMessageStruct[key] = value
                        }
                        
                        let date = latestMessageStruct["date"] as! Timestamp
                
                        
                        let latestMessageObj = LatestMessage(id: latestMessageStruct["id"] as! String,
                                                             date: date.dateValue().description,
                                                         message: latestMessageStruct["message"] as! String,
                                                         isRead: latestMessageStruct["isRead"] as! Bool)
                    
                        conversations.append(Conversation(id: id, name: name, otherUserID: otherUserID, latestMessage: latestMessageObj))
                        
                    }
                    completion(conversations)
                }
            }
    }
    
    
    //Get conversations messages --------------------------------------------------------------------
    
    public func getConvMessages(with id: String, _ completion: @escaping (_ data: [Message]) -> Void) {
        
        var convMessages = [Message]()
        
        db.collection("account").document(uid)
            .collection("conversations").document(id)
            .collection("messages").addSnapshotListener { snap, err in
                guard snap != nil else{
                    print("No messages")
                    return
                }
                for doc in snap!.documents {

                    let msgContent = doc.get("content") as! String
                    let date = doc.get("date") as! Timestamp
                    let id = doc.get("id") as! String
                    let isRead = doc.get("isRead") as! Bool
                    let sender = doc.get("sender") as! String
                    let type = doc.get("type") as! String
                    let otherUserID = doc.get("otherUserID") as! String

                    let senderObj = Sender(senderId: sender, displayName: (Auth.auth().currentUser?.displayName)!, picURL: "")



                        convMessages.append(Message(sender: senderObj, otherUserID: otherUserID, messageId: id, sentDate: date.dateValue(), kind: .text(msgContent)))

                    }
                    completion(convMessages)
                }
            }
        
    
    // Send message ----------------------------------------------------------------------------
    
    public func sendMessage(to conversation: String, message: Message, completion: @escaping (Bool) -> Void) {
        
    }
    
    
    public func getItemInfo(with itemID: String, _ completion: @escaping (_ data: [Item]) -> Void) {
        
        var itemDat = [Item]()
        
        db.collection("items").document("NbF2N1r1Sd46fKsxqFtq")
            .getDocument { doc, error in
                if error != nil {
                    print(error!)
                } else {
                    
                    let id = doc!.documentID
                    let name = doc!.get("name") as! String
                    let costPer = doc!.get("costPer") as! Int
                    let currentStock = doc!.get("currentStock") as! Int
                    let desc = doc!.get("desc") as! String
                    let price = doc!.get("price") as! Int
                    let tags = doc!.get("tags") as! String
                    let dateAdded = doc!.get("dateAdded") as! Timestamp
                    let picId = doc!.get("image") as! String
                    let numSold = doc!.get("numSold") as! Int
                    let sellerName = doc!.get("sellerName") as! String
                    let userID = doc!.get("uid") as! String
                    
                    itemDat.append(Item(name: name, costPer: costPer, currentStock: currentStock, desc: desc, numSold: numSold, price: price, tags: tags, dateAdded: dateAdded, uid: userID, id: id, picId: picId, sellerName: sellerName))
                    
                    
                }
                completion(itemDat)
            }
    }
    
    //----------------------------------
    
    
    
}
