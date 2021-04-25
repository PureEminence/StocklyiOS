//
//  ChatViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/24/21.
//

import UIKit
import MessageKit
import Firebase
import InputBarAccessoryView

struct Sender: SenderType {
 public var senderId: String
 public var displayName: String
 public var picURL: String
}

struct Message: MessageType {
   public var sender: SenderType
   public var messageId: String
   public var sentDate: Date
   public var kind: MessageKind
}

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    public var isNewConv = false
    public var otherUserID: String!
    
    
    let currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: "DisplayName", picURL: "")
    var messages = [Message]()
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid.description
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(otherUserID!)")
        print(getMessageID())
        
        messagesCollectionView.messagesDataSource = self 
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }


    
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        print("sent: \(text)")
        
        if isNewConv {
            
            let message = Message(sender: currentUser, messageId: getMessageID(), sentDate: Date(), kind: .text(text))
            
            DatabaseHelper.shared.createNewConvo(with: otherUserID, firstMessage: message, completion: { success in
                if success {
                    print("message sent")
                } else {
                    print("did not send")
                }
            })
        } else {
            //append to existing
        }
        
    }
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func getMessageID() -> String {
        var messageID = String(otherUserID.suffix(4))
        messageID = messageID.appending(String(uid!.suffix(4)))
        messageID = messageID.appending(String(Date().timeIntervalSince1970).suffix(10))
        return messageID
    }
}
