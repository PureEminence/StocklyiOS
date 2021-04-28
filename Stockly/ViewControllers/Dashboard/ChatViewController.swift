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
   public var otherUserID: String
   public var messageId: String
   public var sentDate: Date
   public var kind: MessageKind
}
extension MessageKind {
    var description: String {
        switch self {
        
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "link_preview"
        case .custom(_):
            return "customc"
        }
    }
}

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    public var isNewConv = false
    public var otherUserID: String!
    
    var currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: (Auth.auth().currentUser!.displayName)!, picURL: "")
    var messages = [Message]()
    var conversation = [Conversation]()
    
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid.description
    
    let user = Auth.auth().currentUser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        messagesCollectionView.messagesDataSource = self 
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {//after viewDidLoad
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }


    
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {//when user presses send on new message
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {//check if only spaces
            return
        }
        print("sent: \(text)")
        
        if isNewConv { //ifNewConv = true -> create new db entry
            
            let message = Message(sender: currentUser, otherUserID: otherUserID, messageId: getMessageID(), sentDate: Date(), kind: .text(text))
            
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
    
    func currentSender() -> SenderType { //gets storeName from current user and adds it to currentUser
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
        messageID = messageID.appending(String(uid.suffix(4)))
        messageID = messageID.appending(String(Date().timeIntervalSince1970).suffix(10))
        return messageID
    }
}
