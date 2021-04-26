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
    
    public func createNewConvo(with otherUserID: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        
        let messageDate = firstMessage.sentDate
       
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
            "otherUserID": otherUserID,
            "name": firstMessage.sender.displayName,
            "latestMessage": [
                "id": firstMessage.messageId,
                "date": messageDate,
                "message": message,
                "isRead": false
            ]
        ]
        
        let otherNewConvData: [String: Any] = [
            "otherUserID": displayName!,
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
                
                } else {
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
    }
    public func getAllConvo(for otherUserID: String, _ completion: @escaping (_ data: [Conversation]) -> Void) { //pull all user convo
        
        var conversations = [Conversation]()
        
        let docRef = db.collection("account").document(uid)
            .collection("conversations")
            .getDocuments { (snap, err) in
                if snap!.isEmpty {
                    print("No conversations")
                } else {
                    for doc in snap!.documents {
                        
                        var id = doc.documentID
                        var name = doc.get("name") as! String
                        var otherUserID = doc.get("otherUserID") as! String
                        var latestMessageDict = doc.get("latestMessage") as! Dictionary<String, Any>
                        
                        
                        
                        var latestMessageStruct = [String: Any]()
                        for(key, value) in latestMessageDict {
                            latestMessageStruct[key] = value
                        }
                        
                        var date = latestMessageStruct["date"] as! Timestamp
                
                        
                        var latestMessageObj = LatestMessage(id: latestMessageStruct["id"] as! String,
                                                             date: date.dateValue().description as! String,
                                                         message: latestMessageStruct["message"] as! String,
                                                         isRead: latestMessageStruct["isRead"] as! Bool)
                    
                        conversations.append(Conversation(id: id, name: name, otherUserID: otherUserID, latestMessage: latestMessageObj))
                    
                        
                    }
                    completion(conversations)
                }
                
            }
            
        
    }
    
    public func getConvMessages(with id: String, _ completion: @escaping (_ data: [Message]) -> Void) {
        
        var convMessage:Message!
        var convMessages = [Message]()
        
        db.collection("account").document(uid)
            .collection("conversations").document(id)
            .collection("messages").addSnapshotListener { snap, err in
                guard let document = snap else{
                    print("No messages")
                    return
                }
                for doc in snap!.documents {

                        var msgContent = doc.get("content") as! String
                        var date = doc.get("date") as! Timestamp
                        var id = doc.get("id") as! String
                        var isRead = doc.get("isRead") as! Bool
                        var sender = doc.get("sender") as! String
                        var type = doc.get("type") as! String
                        var otherUserID = doc.get("otherUserID") as! String

                        var senderObj = Sender(senderId: sender, displayName: (Auth.auth().currentUser?.displayName)!, picURL: "")



                        convMessages.append(Message(sender: senderObj, otherUserID: otherUserID, messageId: id, sentDate: date.dateValue(), kind: .text(msgContent)))

                    }
                    completion(convMessages)
                }
            }
        
    
    public func sendMessage(to conversation: String, message: Message, completion: @escaping (Bool) -> Void) {
        
    }
    
}
