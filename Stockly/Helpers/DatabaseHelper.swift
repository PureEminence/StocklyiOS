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
    
    
    public func createNewConvo(with otherUserID: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        
        let messageDate = firstMessage.sentDate.description
       
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
            "latestMessage": [
                "date": messageDate,
                "message": message,
                "isRead": false
            ]
        ]
        let messages: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind,
            "content": message,
            "date": firstMessage.sentDate,
            "sender": firstMessage.sender,
            "isRead": false
        ]
        
        
         let docRef = db.collection("account").document(uid)
        print("\(otherUserID)")
        docRef.collection("conversations").whereField("otherUserID", isEqualTo: otherUserID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                
                } else {
                    print(querySnapshot?.count)
                    if querySnapshot!.isEmpty {
                        docRef.collection("conversations").document(otherUserID)
                            .setData(newConvData)
                        docRef.collection("conversations").document(otherUserID)
                            .collection("messages").document(firstMessage.messageId)
                            .setData(messages)
                        
                        
                    } else {
                    
                    for doc in querySnapshot!.documents { //if doc already exists print
                        print(doc)
                        }
                        //if docs exists add message to messages
                        docRef.collection("conversations").document(otherUserID)
                            .collection("messages").document(firstMessage.messageId)
                            .setData(messages)
                        
                            
                        
                    }
                }
            }
                
        
        
//            .document(firstMessage.messageId)
//            .setData(["otherUserID" : otherUserID])
//
//        db.collection("account").document(uid)
//            .collection("conversations").document(firstMessage.messageId)
//            .collection("lastest_message").addDocument(data: ["date" : Date(),
//                                                              "latestMessage": "message",
//                                                              "isRead": false])
//        db.collection("account").document(uid)
//            .collection("conversations").document(firstMessage.messageId)
//            .collection("messages").addDocument(data: ["id":"String", "content": "String", "date": Date(), "senderID": "SenderID", "isRead": "true/false"])
//
//
    }
    
    public func getAllConvo(for otherUserID: String, completion: @escaping (Result<String, Error>) -> Void) {
                                
    }
    
    public func getConvMessages(with id: String, completion: @escaping (Result<String, Error>) -> Void) {
        
    }
    
    public func sendMessage(to conversation: String, message: Message, completion: @escaping (Bool) -> Void) {
        
    }
    
}
