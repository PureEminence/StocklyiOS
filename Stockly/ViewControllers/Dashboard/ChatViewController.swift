//
//  ChatViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/24/21.
//

import UIKit
import MessageKit
import MessageUI
import Messages

struct Sender: SenderType {
    var senderId: String
    
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.dataSource = self
        
        
    }
    

    
    func currentSender() -> SenderType {
        <#code#>
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        <#code#>
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        <#code#>
    }
}
